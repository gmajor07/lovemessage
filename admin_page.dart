import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'messages_list_page.dart';  // Import the MessagesListPage

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _messageController = TextEditingController();
  String? _selectedCategory;

  // Define categories manually
  final List<Map<String, dynamic>> _categories = [
    {'title': 'good-morning', 'icon': Icons.wb_sunny},
    {'title': 'good-night', 'icon': Icons.nights_stay},
    {'title': 'break-up', 'icon': Icons.breakfast_dining},
    {'title': 'sad', 'icon': Icons.emoji_emotions_outlined},
    {'title': 'sorry', 'icon': Icons.emoji_emotions},
    {'title': 'birthday', 'icon': Icons.cake},
    {'title': 'for-him', 'icon': Icons.male},
    {'title': 'for-her', 'icon': Icons.female},
    {'title': 'love', 'icon': Icons.favorite},
    {'title': 'friendship', 'icon': Icons.people},
    {'title': 'happiness', 'icon': Icons.sentiment_satisfied},
    {'title': 'life', 'icon': Icons.accessibility},
  ];

  Future<void> _addMessage() async {
    final message = _messageController.text;

    if (message.isNotEmpty && _selectedCategory != null) {
      try {
        await FirebaseFirestore.instance.collection('messages').add({
          'category': _selectedCategory,
          'content': message,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message added successfully')),
        );
        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add message: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category and enter a message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Message',style: TextStyle(color: Colors.white70),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 150,),
              // TextField with rounded border and some padding
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Message',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0), // Adjust vertical padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
        
              const SizedBox(height: 10),
        
              // DropdownButton with custom styling
              DropdownButton<String>(
                value: _selectedCategory,
                hint: const Text('Select Category'),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['title'],
                    child: Row(
                      children: [
                        Icon(category['icon'], color: Colors.purple),
                        const SizedBox(width: 10),
                        Text(
                          category['title'] as String,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.bodyMedium?.color, // Adjust text color based on theme
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                dropdownColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF212F3C) // Dark theme color
                    : Colors.white, // Light theme color
                underline: Container(),
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).textTheme.bodyMedium?.color, // Adjust button text color based on theme
                ),
              ),

              const SizedBox(height: 20),
        
              // ElevatedButton with rounded corners and some padding
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: _addMessage,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  ),
                  child: const Text('Save Message'),
                ),
              ),
        
              const SizedBox(height: 20),
        
              // Similar styling for the second ElevatedButton
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedCategory != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagesListPage(
                            category: _selectedCategory!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a category')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  ),
                  child: const Text('View Messages'),
                ),
              ),
            ],
        
          ),
        ),
      ),
    );
  }
}
