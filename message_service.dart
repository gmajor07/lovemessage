import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String baseUrl = 'https://api.quotable.io';  // Use your actual base URL

  Future<List<String>> fetchMessages(String category) async {
    List<String> messages = [];

    // Fetch from Firestore
    try {
      final firestoreMessages = await _fetchMessagesFromFirestore(category);
      messages.addAll(firestoreMessages);
    } catch (e) {
      print('Error fetching from Firestore: $e');
    }

    // Fetch from API
    try {
      final apiMessages = await _fetchMessagesFromApi(category);
      messages.addAll(apiMessages);
    } catch (e) {
      print('Error fetching from API: $e');
    }

    return messages;
  }

  Future<List<String>> _fetchMessagesFromFirestore(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection('messages')
          .where('category', isEqualTo: category)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      return querySnapshot.docs.map((doc) => doc['content'] as String).toList();
    } catch (e) {
      throw Exception('Failed to fetch messages from Firestore: $e');
    }
  }

  Future<List<String>> _fetchMessagesFromApi(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/quotes?tags=$category'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['results'];
      return data.map((message) => message['content'] as String).toList();
    } else {
      throw Exception('Failed to load messages from API');
    }
  }

  Future<void> addMessage(String category, String message) async {
    try {
      final docRef = _firestore
          .collection('messages')
          .doc(category)
          .collection('items')
          .doc();

      await docRef.set({
        'content': message,
      });
    } catch (e) {
      throw Exception('Failed to add message: $e');
    }
  }
}
