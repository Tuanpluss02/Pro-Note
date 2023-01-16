import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro_note/styles/app_style.dart';

class EditNote extends StatefulWidget {
  final bool isUpdate;
  final QueryDocumentSnapshot? docs;
  const EditNote({super.key, this.docs, required this.isUpdate});

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
    _isChanged()
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
                            .collection('Notes')
                            .doc(widget.docs!.id)
                            .update({
                            'title': _titleController.text,
                            'content': _contentController.text,
                          })
                        : FirebaseFirestore.instance.collection('Notes').add({
                            'title': _titleController.text,
                            'content': _contentController.text,
                            // 'date': DateTime.now().toString(),
                            'date':
                                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            'color': _ranColor,
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
              textAlign: TextAlign.center,
              controller: _titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter title',
                hintStyle: AppStyle.mainTitle,
              ),
              style: AppStyle.mainTitle,
            ),
            Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                child: AutoSizeText(
                  widget.docs != null
                      ? widget.docs!['date']
                      : DateTime.now().toString(),
                  style: AppStyle.dateTitle,
                  maxLines: 1,
                )),
            Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: AppStyle.mainContent,
                  ),
                  style: AppStyle.mainContent,
                  maxLines: 8,
                ))
          ]),
          floatingActionButton: _isChanged()
              ? FloatingActionButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('notes')
                        .doc(widget.docs!.id)
                        .update({
                      'title': _titleController.text,
                      'content': _contentController.text,
                    });
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.save),
                )
              : null),
    );
  }
}
