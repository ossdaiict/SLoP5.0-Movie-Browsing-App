import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  int favCount = 0;
  String username = '';
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }





  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final email = user.email ?? '';
    final displayName = user.displayName ?? email.split("@").first;
    print(displayName);

    setState(() {
      user.updateDisplayName(displayName);
      username = displayName;
    });
  }

  Future<void> _updateUsername()async
  {
    final user =_auth.currentUser;

    final newName=_nameController.text.trim();

    if (user == null || newName.isEmpty) return;

    await user.updateDisplayName(newName);

    setState(() {
      username = newName;
      _isEditing = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final favStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('favourites')
        .snapshots();


    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user == null
            ? const Center(child: Text('No user logged in'))
            : Center(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Row(children: [
                      const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          )),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _isEditing
                            ? TextField(
                          controller: _nameController..text = user.displayName ?? '',
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "Edit Username",
                            suffixIcon: IconButton(
                                onPressed: _updateUsername,
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )),
                          ),
                        )
                            :  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.displayName ?? "No Name",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      user.email ?? "No Email",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),

                                  ]),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() => _isEditing = true);
                                },
                              ),
                            ]),)
                    ]),
                  ),

                  const SizedBox(height: 24),

                  StreamBuilder<QuerySnapshot>(
                    stream: favStream,
                    builder: (context, favSnap) {
                      if (favSnap.hasError) {
                        return const Text(
                          'Favourites: error',
                          style: TextStyle(fontSize: 18),
                        );
                      }

                      if (favSnap.connectionState ==
                          ConnectionState.waiting) {
                        return const Text(
                          'Favourites: ...',
                          style: TextStyle(fontSize: 18),
                        );
                      }

                      final favDocs = favSnap.data?.docs ?? [];
                      final favCount = favDocs.length;

                      return Text(
                        'Favourites: $favCount',
                        style: const TextStyle(fontSize: 18),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () async {
                        await _auth.signOut();
                        //if (!context.mounted) return;
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
