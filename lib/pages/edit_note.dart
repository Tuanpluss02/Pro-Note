import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro_note/styles/app_style.dart';

class EditNote extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userId;
  final bool isUpdate;
  final QueryDocumentSnapshot? docs;
  const EditNote(
      {super.key, this.docs, required this.isUpdate, required this.userId});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final int _ranColor = Random().nextInt(AppStyle.cardsColors.length);
  late final String _oldTitle = widget.isUpdate ? widget.docs!['title'] : '';
  late final String _oldContent =
      widget.isUpdate ? widget.docs!['content'] : '';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isEditing = false;
  final String _dateNote =
      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
  @override
  void initState() {
    super.initState();
    _titleController.text = _oldTitle;
    _contentController.text = _oldContent;
  }

  bool _isChanged() {
    return _titleController.text != _oldTitle ||
        _contentController.text != _oldContent;
  }

  Future<bool> _requestPop() {
    (_isChanged() && _isEditing)
        ? showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('You have unsaved changes.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Discard'),
                ),
                TextButton(
                  onPressed: () {
                    widget.isUpdate
                        ? FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.userId)
                            .collection('UserNotes')
                            .doc(widget.docs!.id)
                            .update({
                            'title': _titleController.text,
                            'content': _contentController.text,
                          })
                        : FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.userId)
                            .collection('UserNotes')
                            .add({
                            'title': _titleController.text,
                            'content': _contentController.text,
                            'date':
                                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            'color': _ranColor,
                          });
                    setState(() {
                      _isEditing = false;
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          )
        : Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _requestPop();
      },
      child: Scaffold(
          backgroundColor: widget.isUpdate
              ? AppStyle.cardsColors[widget.docs!['color'] ?? _ranColor]
              : AppStyle.cardsColors[_ranColor],
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: Text(widget.isUpdate ? 'Edit Note' : 'Add new note',
                style: AppStyle.mainTitle),
            backgroundColor: widget.isUpdate
                ? AppStyle.cardsColors[widget.docs!['color'] ?? _ranColor]
                : AppStyle.cardsColors[_ranColor],
            elevation: 0,
            centerTitle: true,
          ),
          body: Column(children: [
            TextField(
              onChanged: (p) {
                setState(() {
                  _isEditing = true;
                });
              },
              textAlign: TextAlign.center,
              controller: _titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter title',
                // hintStyle: AppStyle.mainTitle,
              ),
              style: AppStyle.mainTitle,
            ),
            Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                child: AutoSizeText(
                  widget.docs != null ? widget.docs!['date'] : _dateNote,
                  style: AppStyle.dateTitle,
                  maxLines: 1,
                )),
            Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                child: TextField(
                  onChanged: (p) {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  controller: _contentController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: AppStyle.mainContent,
                  ),
                  style: AppStyle.mainContent,
                  maxLines: 8,
                ))
          ]),
          floatingActionButton: _isEditing
              ? FloatingActionButton(
                  onPressed: () {
                    widget.isUpdate
                        ? FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.userId)
                            .collection('UserNotes')
                            .doc(widget.docs!.id)
                            .update({
                            'title': _titleController.text,
                            'content': _contentController.text,
                          })
                        : FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.userId)
                            .collection('UserNotes')
                            .add({
                            'title': _titleController.text,
                            'content': _contentController.text,
                            'date':
                                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            'color': _ranColor,
                          });
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  child: const Icon(Icons.save),
                )
              : null),
    );
  }
}
