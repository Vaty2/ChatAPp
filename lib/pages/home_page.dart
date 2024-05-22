import 'package:chat_zone/pages/chat_page.dart';
import 'package:chat_zone/pages/profile_page.dart';
import 'package:chat_zone/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void signOut() {
    final authservice = Provider.of<AuthService>(context, listen: false);
    authservice.signOut();
  }

  void profile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat page'),
        actions: [
          IconButton(onPressed: profile, icon: const Icon(Icons.person)),
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("loading..");
          }
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
          title: Row(
            children: [
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: data['photoURL'] != "" && data['photoURL'] != null
                        ? Image.network(
                            data['photoURL'],
                            width: 40,
                            height: 40,
                            fit: BoxFit.fitHeight,
                          )
                        : const Icon(Icons.person),
                  )),
              const SizedBox(
                width: 10,
              ),
              Text(data['displayName'])
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          receiverUserEmail: data['displayName'],
                          receiverUserID: data['uid'],
                          photoURL: data['photoURL'],
                        )));
          });
    } else {
      return Container();
    }
  }
}
