import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:lovemsg/string_extensions.dart'; // Ensure you have this extension for capitalize()
import 'message_service.dart';

class MessagesPage extends StatefulWidget {
  final String category;

  const MessagesPage({super.key, required this.category});

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late Future<List<String>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = MessageService().fetchMessages(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.category.replaceAll('-', ' ').capitalize()} Messages',
          style: const TextStyle(color: Colors.white70),
        ),
        backgroundColor: const Color(0xFFC34A99), // Example color
// Change to your preferred color
        elevation: 4.0,
      ),
      body: FutureBuilder<List<String>>(
        future: _messages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red.shade600),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/no_messages.png', // Add your image path here
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No messages found.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final message = snapshot.data![index].capitalize();
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 5.0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      message,
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: message));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied to clipboard')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () async {
                            await FlutterShare.share(
                              title: 'Share Love Message',
                              text: message,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
