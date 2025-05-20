import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_first_app/book.dart';
import 'package:my_first_app/user.dart';
import 'package:my_first_app/user_badge.dart';

class BookDetails extends StatelessWidget {
  final Book book;
  final User user;

  const BookDetails({super.key, required this.book, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (book.imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(book.imagePath!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16.0),
              ],
              Text(
                book.title,
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              UserBadge(user: user),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text(
                    "Created: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    book.createdAt.toString().substring(0, 19),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Text(
                    "Updated: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    book.updatedAt.toString().substring(0, 19),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 16.0),
              Text(
                book.text,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
