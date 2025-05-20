import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:my_first_app/user.dart';

class UserDialog extends StatefulWidget {
  final User? user;
  final Function(String name, int age, String gender, String hometown, String? profilePicture) onSubmit;
  
  const UserDialog({
    super.key,
    this.user,
    required this.onSubmit,
  });
  
  @override
  State<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController hometownController;
  late String gender;
  String? imagePath;
  File? imageFile;
  
  @override
  void initState() {
    super.initState();
    // Init for update book
    nameController = TextEditingController(text: widget.user?.name ?? '');
    ageController = TextEditingController(text: widget.user?.age.toString() ?? '');
    hometownController = TextEditingController(text: widget.user?.hometown ?? '');
    gender = widget.user?.gender ?? "Male";
    imagePath = widget.user?.profilePicture;
    imageFile = widget.user?.profilePicture != null ? File(widget.user!.profilePicture!) : null;
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    hometownController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        imagePath = image.path;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New User'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: imageFile != null 
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.grey[800],
                      ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Tap to add profile picture',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: <String>['Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      gender = newValue;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: hometownController,
                decoration: InputDecoration(
                  labelText: 'Hometown',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your hometown';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                nameController.text,
                int.parse(ageController.text),
                gender,
                hometownController.text,
                imagePath,
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
} 