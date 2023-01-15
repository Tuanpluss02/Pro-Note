import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro_note/styles/app_style.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot docs) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppStyle.cardsColors[docs['color']],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        AutoSizeText(docs['title'], style: AppStyle.mainTitle),
        Text(docs['date'], style: AppStyle.dateTitle),
        AutoSizeText(
          docs['content'],
          style: AppStyle.mainContent,
          maxLines: 8,
        )
      ]),
    ),
  );
}
