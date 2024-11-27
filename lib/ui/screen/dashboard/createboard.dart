import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CreateBoardScreen extends StatefulWidget {
  @override
  _CreateBoardScreenState createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends State<CreateBoardScreen> {
  final TextEditingController _boardNameController = TextEditingController();
  String _selectedWorkspace = "";
  String _selectedVisibility = "";
  Color _selectedColor = Colors.white; // Default color white

  final List<String> _workspaces = ["Workspace 1", "Workspace 2"];
  final List<String> _visibilityOptions = ["Public", "Private"];

  final User? user = FirebaseAuth.instance.currentUser; // Get the logged-in user

  // Function to create a new board in Firebase
  Future<void> _createBoard() async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in!")),
      );
      return;
    }

    if (_boardNameController.text.isEmpty ||
        _selectedWorkspace.isEmpty ||
        _selectedVisibility.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields!")),
      );
      return;
    }

    try {
      // Reference to the user's boards sub-collection
      final boardCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('boards');

      // Create a new board
      await boardCollection.add({
        'name': _boardNameController.text,
        'workspace': _selectedWorkspace,
        'visibility': _selectedVisibility,
        'color': '#${_selectedColor.value.toRadixString(16).substring(2)}',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Board created successfully!")),
      );
      Navigator.pop(context);

      // Clear input fields after creating the board
      _boardNameController.clear();
      setState(() {
        _selectedWorkspace = "";
        _selectedVisibility = "";
        _selectedColor = Colors.white;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create board: $error")),
      );
    }
  }

  // Color picker dialog
  Future<void> _pickColor() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Board"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Board Name
              const Text(
                "Board Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _boardNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter board name",
                ),
              ),
              const SizedBox(height: 20),

              // Workspace Dropdown
              const Text(
                "Workspace",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedWorkspace.isEmpty ? null : _selectedWorkspace,
                items: _workspaces
                    .map((workspace) => DropdownMenuItem(
                  value: workspace,
                  child: Text(workspace),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedWorkspace = value ?? "";
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Select a workspace",
                ),
              ),
              const SizedBox(height: 20),

              // Visibility Dropdown
              const Text(
                "Visibility",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedVisibility.isEmpty ? null : _selectedVisibility,
                items: _visibilityOptions
                    .map((visibility) => DropdownMenuItem(
                  value: visibility,
                  child: Text(visibility),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVisibility = value ?? "";
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Select visibility",
                ),
              ),
              const SizedBox(height: 20),

              // Color Picker
              const Text(
                "Board Background",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickColor,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: _selectedColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text("Selected Color: #${_selectedColor.value.toRadixString(16).substring(2)}"),
                ],
              ),
              const SizedBox(height: 20),

              // Create Board Button
              Center(
                child: ElevatedButton(
                  onPressed: _createBoard,
                  child: const Text("Create Board"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}