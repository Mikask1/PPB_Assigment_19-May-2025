import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_first_app/user.dart';
import 'package:my_first_app/user_details.dart';

class UserBadge extends StatelessWidget {
  final User user;

  const UserBadge({super.key, required this.user});

  void _showDetailsDialog(context) {
    showDialog(
      builder: (BuildContext context) {
        return UserDetails(user: user);
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        _showDetailsDialog(context);
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                user.profilePicture != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(user.profilePicture!),
                        width: 18.0,
                        height: 18.0,
                        fit: BoxFit.cover,
                      ),
                    )
                    : Icon(Icons.person, size: 18.0, color: Colors.yellow[800]),
                SizedBox(width: 8.0),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.yellow[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
