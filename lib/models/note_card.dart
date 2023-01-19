import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro_note/styles/app_style.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot docs,
    BuildContext context, String userId) {
  return InkWell(
    onTap: onTap,
    onLongPress: () => showDialog(
      context: context,
      builder: (context) => alertDel(context, docs, userId),
    ),
    child: Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppStyle.cardsColors[docs['color']],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        Text(docs['title'],
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.mainTitle),
        Text(docs['date'], style: AppStyle.dateTitle),
        Text(
          docs['content'],
          overflow: TextOverflow.ellipsis,
          maxLines: 10,
          style: AppStyle.mainContent,
          // maxLines: 8,
        )
      ]),
    ),
  );
}

Widget alertDel(
    BuildContext context, QueryDocumentSnapshot docs, String userId) {
  return AlertDialog(
    title: const Text('Are you sure?'),
    content: const Text('This note will be deleted permanently.'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('Notes')
              .doc(userId)
              .collection('UserNotes')
              .doc(docs.id)
              .delete();
          Navigator.pop(context);
        },
        child: const Text('Delete'),
      ),
    ],
  );
}
