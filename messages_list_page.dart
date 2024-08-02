import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lovemsg/string_extensions.dart';

class MessagesListPage extends StatelessWidget {
  final String category;

  const MessagesListPage({super.key, required this.category});

  Future<void> _showDeleteConfirmationDialog(BuildContext context, String docId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this message?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('messages')
                      .doc(docId)
                      .delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message deleted')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete message: $e')),
                  );
                }
                Navigator.of(context).pop(); // Close the dialog
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
        title: Text('${category.replaceAll('-', ' ').capitalize()} Messages',style: const TextStyle(color: Colors.white70),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/no_messages.png', // Add your image path here
                      width: 100, height: 100), // Adjust size as needed
                  const SizedBox(height: 20),
                  const Text('No messages found.',style: TextStyle(color: Colors.blueGrey),),
                ],
              ),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                final message = doc['content'] as String;
                return ListTile(
                  title: Text(message),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete,color: Colors.red,),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, doc.id);
                    },
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
