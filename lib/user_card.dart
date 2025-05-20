import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_first_app/crud_menu.dart';
import 'package:my_first_app/user.dart';
import 'package:my_first_app/user_details.dart';

class UserCard extends StatelessWidget {
  final User user;
  final Function onDelete;
  final Function onUpdate;

  const UserCard({
    super.key,
    required this.user,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          return UserDetails(user: user);
        },
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Profile picture or avatar
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child:
                    user.profilePicture != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.file(
                            File(user.profilePicture!),
                            fit: BoxFit.cover,
                          ),
                        )
                        : Icon(
                          Icons.person,
                          size: 40.0,
                          color: Colors.yellow.shade800,
                        ),
              ),
              const SizedBox(width: 16.0),
              // User information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Icon(
                          user.gender == 'Male'
                              ? Icons.male
                              : user.gender == 'Female'
                              ? Icons.female
                              : Icons.person,
                          size: 16.0,
                          color:
                              user.gender == 'Male'
                                  ? Colors.yellow[800]
                                  : user.gender == 'Female'
                                  ? Colors.pink[300]
                                  : Colors.purple[300],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Age: ${user.age}',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              CrudMenu(onDelete: onDelete, onUpdate: onUpdate),
            ],
          ),
        ),
      ),
    );
  }
}
