import 'package:flutter/material.dart';
import 'package:my_first_app/empty_user.dart';
import 'package:my_first_app/user_card.dart';
import 'user.dart';
import 'user_dialog.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final Function(
    String name,
    int age,
    String gender,
    String hometown,
    String? profilePicture,
  )
  addUser;
  final Function(int index) onDelete;
  final Function(
    User user,
    String name,
    int age,
    String gender,
    String hometown,
    String? profilePicture,
  )
  onUpdate;

  const UserList({
    super.key,
    required this.users,
    required this.addUser,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Users',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.person_add, color: Colors.white),
                label: Text('Add User', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return UserDialog(onSubmit: addUser);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        users.isEmpty
            ? EmptyUser()
            : ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserCard(
                  user: user,
                  onDelete: () {
                    onDelete(index);
                  },
                  onUpdate: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UserDialog(
                          onSubmit: (
                            name,
                            age,
                            gender,
                            hometown,
                            profilePicture,
                          ) {
                            onUpdate(
                              user,
                              name,
                              age,
                              gender,
                              hometown,
                              profilePicture,
                            );
                          },
                          user: user,
                        );
                      },
                    );
                  },
                );
              },
            ),
      ],
    );
  }
}
