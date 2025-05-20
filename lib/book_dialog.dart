import 'package:flutter/material.dart';
import 'book.dart';
import 'user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BookDialog extends StatefulWidget {
  final Book? book;
  final List<User> users;
  final Function(String title, String text, String userId, String? imagePath) onSubmit;

  const BookDialog({
    super.key, 
    this.book, 
    required this.users,
    required this.onSubmit
  });

  @override
  State<BookDialog> createState() => _BookDialogState();
}

class _BookDialogState extends State<BookDialog> {
  late TextEditingController _textController;
  late TextEditingController _titleController;
  final _formKey = GlobalKey<FormState>();
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  String? _selectedUserId;
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    // Init for update book
    _textController = TextEditingController(text: widget.book?.text ?? '');
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    
    if (widget.book != null && widget.users.isNotEmpty) {
      _selectedUserId = widget.book!.userId;
      _imagePath = widget.book?.imagePath;
      _selectedUser = widget.users.firstWhere(
        (user) => user.id == _selectedUserId,
        orElse: () => widget.users.first,
      );
      if (_selectedUser == null && widget.users.isNotEmpty) {
        _selectedUser = widget.users.first;
        _selectedUserId = _selectedUser!.id;
      }
    } else if (widget.users.isNotEmpty) {
      // Init for add book
      _selectedUser = widget.users.first;
      _selectedUserId = _selectedUser!.id;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[800]!),
      ),
      backgroundColor: Colors.grey[200],
      title: Row(
        children: [
          Icon(
            widget.book == null ? Icons.add_circle_outline : Icons.edit_note,
            color: Colors.grey[800],
          ),
          const SizedBox(width: 8),
          Text(
            widget.book == null ? 'Add New Book' : 'Update Book',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.users.isEmpty)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[700]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange[800]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Please add a user first before creating a book.',
                          style: TextStyle(color: Colors.orange[800]),
                        ),
                      ),
                    ],
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  value: _selectedUserId,
                  decoration: InputDecoration(
                    labelText: 'Select User',
                    hintText: 'Choose a user',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: widget.users.map((User user) {
                    return DropdownMenuItem<String>(
                      value: user.id,
                      child: Text(user.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUserId = newValue;
                      _selectedUser = widget.users.firstWhere(
                        (user) => user.id == _selectedUserId,
                      );
                    });
                  }
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter your book title here...',
                  labelText: 'Book Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.book),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a book title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Enter your book text here...',
                  labelText: 'Book Text',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.book),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a book text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imagePath!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 40,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Image (Optional)',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.close, color: Colors.grey[800]),
                    label: Text('Cancel', style: TextStyle(color: Colors.grey[800])),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: Icon(widget.book == null ? Icons.add : Icons.save, color: Colors.white),
                    label: Text(widget.book == null ? 'Add Book' : 'Update', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.yellow.shade300,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _selectedUserId != null) {
                        widget.onSubmit(
                          _titleController.text.trim(),
                          _textController.text.trim(),
                          _selectedUserId!,
                          _imagePath,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}