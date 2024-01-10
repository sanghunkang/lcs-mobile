import 'package:flutter/material.dart';
import 'package:lcs_mobile/data/note.dart';
import 'package:lcs_mobile/page/note_edit_page.dart';
import 'package:lcs_mobile/providers.dart';

class NoteViewPage extends StatefulWidget {
  static const routeName = '/view';

  final int id;

  NoteViewPage(this.id);

  @override
  State createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Note>(
      future: noteManager().getNote(widget.id),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('오류: ${snap.error}'),
            ),
          );
        }

        final note = snap.requireData;
        return Scaffold(
          appBar: AppBar(
            title: Text(note.title.isEmpty ? '(제목 없음)' : note.title),
            actions: [
              IconButton(
                onPressed: () {
                  _edit(widget.id);
                },
                icon: const Icon(Icons.edit),
                tooltip: '편집',
              ),
              IconButton(
                onPressed: () {
                  _confirmDelete(widget.id);
                },
                icon: const Icon(Icons.delete),
                tooltip: '삭제',
              ),
            ],
          ),
          body: SizedBox.expand(
            child: Container(
              color: note.color,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12.0,
                ),
                child: Text(note.body),
              ),
            ),
          ),
        );
      },
    );
  }

  void _edit(int id) {
    Navigator.pushNamed(
      context,
      NoteEditPage.routeName,
      arguments: id,
    ).then((_) {
      setState(() {});
    });
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('이 노트를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('예'),
              onPressed: () {
                noteManager().deleteNote(id);
                Navigator.popUntil(context, (route) => route.isFirst);
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}
