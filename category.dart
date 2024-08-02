import 'package:flutter/material.dart';
import 'package:lovemsg/string_extensions.dart';
import 'messages_page.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const CategoryCard({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessagesPage(category: title),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 50, height: 50), // Use Image.asset for displaying images
            const SizedBox(height: 10),
            Text(
              title.replaceAll('-', ' ').capitalize(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
