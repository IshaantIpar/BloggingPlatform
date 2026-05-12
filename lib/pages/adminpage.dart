import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Dashboard"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.article), text: "Moderation"),
              Tab(icon: Icon(Icons.people), text: "Users"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Moderation (Pending Posts)
            _buildModerationList(),
            // Tab 2: User Management
            _buildUserList(),
          ],
        ),
      ),
    );
  }

  Widget _buildModerationList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return const Center(child: Text("No pending posts."));
        
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var post = snapshot.data!.docs[index];
            return ListTile(
              title: Text(post['title']),
              subtitle: Text("Author: ${post['authorName']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => post.reference.update({'status': 'approved'}),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => post.reference.update({'status': 'rejected'}),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUserList() {
     // Similar StreamBuilder but for the 'users' collection
     return const Center(child: Text("User Management Table Here"));
  }
}