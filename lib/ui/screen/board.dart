import 'package:credixo/providers/boardProvider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  final Color backgroundColor;
  final String boardName;
  final String boardId;

  const BoardScreen({Key? key, required this.backgroundColor, required this.boardName, required this.boardId}) : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  bool _isAdding = false;
  bool _isAddingCard = false;
  String _currentListId = '';
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<BoardProvider>(context, listen: false).fetchLists(widget.boardId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: _isAdding ? (_isAddingCard ? const Text("Add card") : const Text("Add list")) : Text(widget.boardName),
        leading: IconButton(
          icon: Icon(_isAdding ? Icons.close : Icons.arrow_back),
          onPressed: () {
            if (_isAdding) {
              setState(() {
                _isAdding = false;
                _isAddingCard = false;
                _nameController.clear();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: _isAdding
            ? [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (_nameController.text.isNotEmpty) {
                if (_isAddingCard) {
                  await _addCardToList();
                } else {
                  await _addListToBoard();
                }
                setState(() {
                  _isAdding = false;
                  _isAddingCard = false;
                  _nameController.clear();
                });
              }
            },
          ),
        ]
            : [],
      ),
      body: Container(
        color: widget.backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: Consumer<BoardProvider>(
                builder: (context, provider, child) {
                  if (provider.lists.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: provider.lists.map((list) {
                      return DragTarget<Map<String, dynamic>>(
                        onAccept: (draggedCard) {
                          _moveCardToList(
                            draggedCard: draggedCard,
                            targetListId: list['id'],
                            sourceListId: draggedCard['sourceListId'],
                          );
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            width: 200,
                            margin: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    color: Colors.black,
                                  ),
                                  width: 200,
                                  child: Row(
                                    children: [
                                      Text(
                                        list['name'],
                                        style: const TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView(
                                    children: (list['cards'] ?? []).map<Widget>((card) {
                                      return Draggable<Map<String, dynamic>>(
                                        data: {
                                          'card': card, // Pass the card data, including 'id'
                                          'sourceListId': list['id'], // Pass the source list ID
                                        },
                                        feedback: Material(
                                          child: Card(
                                            color: Colors.grey,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(card['name']),
                                            ),
                                          ),
                                        ),
                                        child: Card(
                                          child: ListTile(
                                            title: Text(card['name'], style: const TextStyle(color: Colors.black)),
                                          ),
                                        ),
                                      );

                                    }).toList(),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isAdding = true;
                                      _isAddingCard = true;
                                      _currentListId = list['id']; // Use the list ID
                                    });
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(Icons.add, color: Colors.black),
                                      Text(
                                        "Add card",
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            if (_isAdding)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: _isAddingCard ? "Enter card name" : "Enter list name",
                  ),
                ),
              ),
            if (!_isAdding)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isAdding = true;
                      _isAddingCard = false;
                    });
                  },
                  child: const Text(
                    'Add list',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _moveCardToList({
    required Map<String, dynamic> draggedCard,
    required String targetListId,
    required String sourceListId,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cardData = draggedCard['card'];

    try {
      // Reference for the source card (to be deleted)
      final sourceCardRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('boards')
          .doc(widget.boardId)
          .collection('lists')
          .doc(sourceListId)
          .collection('cards')
          .doc(cardData['id']); // Delete using card's Firestore ID

      // Reference for the target list (to add the card)
      final targetCardRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('boards')
          .doc(widget.boardId)
          .collection('lists')
          .doc(targetListId)
          .collection('cards');

      // Add the card to the target list
      await targetCardRef.add({
        'name': cardData['name'],
        'createdAt': cardData['createdAt'],
      });

      // Remove the card from the source list
      await sourceCardRef.delete();

      // Refresh the UI
      Provider.of<BoardProvider>(context, listen: false).fetchLists(widget.boardId);
    } catch (e) {
      print("Failed to move card: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to move card: $e")),
      );
    }
  }




  Future<void> _addListToBoard() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in!")),
      );
      return;
    }

    try {
      final listCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('boards')
          .doc(widget.boardId)
          .collection('lists');

      // Add the list with an auto-generated ID
      final listRef = listCollection.doc();
      await listRef.set({
        'name': _nameController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Provider.of<BoardProvider>(context, listen: false).fetchLists(widget.boardId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("List added successfully!")),
      );
    } catch (error) {
      print("Failed to add list: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add list: $error")),
      );
    }
  }

  Future<void> _addCardToList() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in!")),
      );
      return;
    }

    if (_currentListId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No list selected!")),
      );
      return;
    }

    try {
      final cardCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('boards')
          .doc(widget.boardId)
          .collection('lists')
          .doc(_currentListId)
          .collection('cards');

      await cardCollection.add({
        'name': _nameController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Provider.of<BoardProvider>(context, listen: false).fetchLists(widget.boardId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Card added successfully!")),
      );
    } catch (error) {
      print("Failed to add card: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add card: $error")),
      );
    }
  }
}
