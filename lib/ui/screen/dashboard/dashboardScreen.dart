import 'package:credixo/providers/boardProvider.dart';
import 'package:credixo/ui/screen/board.dart';
import 'package:credixo/ui/screen/dashboard/createboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return ChangeNotifierProvider(
      create: (context) => BoardProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Boards"),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                accountName: Text(user?.displayName ?? "No Name"),
                accountEmail: Text(user?.email ?? "No Email"),
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    (user?.displayName != null && user!.displayName!.isNotEmpty)
                        ? user.displayName![0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  backgroundColor: Colors.purple,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () {
                  // Add navigation or functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  // Add navigation or functionality
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Sign Out"),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('boards')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading boards"));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty.png',
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "No boards",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Create your first board",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final boards = snapshot.data!.docs;

            return ListView.builder(
              itemCount: boards.length,
              itemBuilder: (context, index) {
                final board = boards[index];
                final boardColor = Color(int.parse("0xFF${board['color'].substring(1)}"));
                return ListTile(
                  title: Text(board['name']),
                  subtitle: Text("Workspace: ${board['workspace']}"),
                  trailing: Text(board['visibility']),
                  leading: Container(
                    width: 50,
                    height: 50,
                    color: boardColor,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => BoardProvider()..fetchLists(board.id),
                          child: BoardScreen(
                            backgroundColor: boardColor,
                            boardName: board['name'],
                            boardId: board.id,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: SizedBox(
          width: 200,
          height: 50,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateBoardScreen(),
                ),
              );
            },
            label: const Text(
              "Create board",
              style: TextStyle(fontSize: 18),
            ),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
