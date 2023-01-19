class Note {
  late String id;
  late String title;
  late String content;
  late String date;
  int color;
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.color = 0,
  });
}
