import 'package:flutter/material.dart';
import 'package:my_first_app/book_details.dart';
import 'book.dart';
import 'user.dart';
import 'crud_menu.dart';
import 'dart:io';
import 'database_helper.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final Function delete;
  final Function update;
  const BookCard({
    super.key,
    required this.book,
    required this.delete,
    required this.update,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  final dbHelper = DatabaseHelper.instance;
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void didUpdateWidget(BookCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.book.userId != widget.book.userId) {
      setState(() {
        isLoading = true;
      });
      _loadUser();
    }
  }

  Future<void> _loadUser() async {
    try {
      user = await dbHelper.getUser(widget.book.userId);
    } catch (e) {
      // Silently handle error
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showDetailsDialog() {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User information unavailable')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BookDetails(book: widget.book, user: user!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: _showDetailsDialog,
      child: Card(
        margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.book.imagePath != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(widget.book.imagePath!),
                                width: 30.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.book.title,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Row(
                              children: [
                                if (user != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Author: ${user!.name}',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.yellow.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 40.0),
                    CrudMenu(onDelete: widget.delete, onUpdate: widget.update),
                  ],
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
