import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_first_app/user.dart';

class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails({super.key, required this.user});

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (user.profilePicture != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.file(
                    File(user.profilePicture!),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16.0),
              ],
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Age: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    user.age.toString(),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Gender: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    user.gender.toString(),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Hometown: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    user.hometown.toString(),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Divider(),
              SizedBox(height: 8.0),
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
                    user.createdAt.toString().substring(0, 19),
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
                    user.updatedAt.toString().substring(0, 19),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
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
