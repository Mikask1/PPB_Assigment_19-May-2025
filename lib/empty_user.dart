import 'package:flutter/material.dart';

class EmptyUser extends StatelessWidget {
  const EmptyUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.person_off, size: 48, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No users yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Add a user to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
