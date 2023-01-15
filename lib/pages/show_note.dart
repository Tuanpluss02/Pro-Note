import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro_note/styles/app_style.dart';

class NoteShow extends StatefulWidget {
  final QueryDocumentSnapshot docs;
  const NoteShow({super.key, required this.docs});
  @override
  State<NoteShow> createState() => _NoteShowState();
}

class _NoteShowState extends State<NoteShow> {
  late final int _color = widget.docs['color'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColors[_color],
      appBar: AppBar(
        title: AutoSizeText(widget.docs['title'], style: AppStyle.mainTitle),
        backgroundColor: AppStyle.cardsColors[_color],
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(children: [
        Text(widget.docs['date'], style: AppStyle.dateTitle),
        // const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          child: AutoSizeText(
            widget.docs['content'],
            style: AppStyle.mainContent,
            maxLines: 8,
          ),
        )
      ]),
    );
  }
}
