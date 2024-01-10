import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lcs_mobile/data/note.dart';
import 'package:lcs_mobile/providers.dart';

class NoteEditPage extends StatefulWidget {
  static const routeName = '/edit';

  final int? id;

  NoteEditPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return _NoteEditorPageState();
  }
}

class _NoteEditorPageState extends State<NoteEditPage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  Color color = Note.colorDefault;
  InterstitialAd? _interstitial;

  @override
  void initState() {
    super.initState();

    final noteId = widget.id;

    if (noteId != null) {
      noteManager().getNote(noteId).then((note) {
        titleController.text = note.title;
        bodyController.text = note.body;
        setState(() {
          color = note.color;
        });
      });
    }

    adHelper().loadInterstitial((ad) {
      setState(() {
        _interstitial = ad;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('노트 편집'), actions: [
        IconButton(
          onPressed: _displayColorSelectionDialog,
          icon: Icon(Icons.color_lens),
          tooltip: '배경색 선택',
        ),
        IconButton(
          onPressed: _saveNote,
          icon: Icon(Icons.save),
          tooltip: '저장',
        ),
      ]),
      body: SizedBox.expand(
        child: Container(
          color: color,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '제목을 입력하세요',
                  ),
                  maxLines: 1,
                  style: TextStyle(fontSize: 20.0),
                  controller: titleController,
                ),
                SizedBox(height: 8.0),
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '노트 입력',
                  ),
                  maxLines: null,
                  style: TextStyle(fontSize: 20.0),
                  keyboardType: TextInputType.multiline,
                  controller: bodyController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interstitial?.dispose();
    super.dispose();
  }

  void _displayColorSelectionDialog() {
    FocusManager.instance.primaryFocus?.unfocus();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('배경색 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('없음'),
                onTap: () => _applyColor(Note.colorDefault),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Note.colorBlue),
                title: Text('파랑'),
                onTap: () => _applyColor(Note.colorBlue),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Note.colorLime),
                title: Text('라임'),
                onTap: () => _applyColor(Note.colorLime),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Note.colorOrange),
                title: Text('주황'),
                onTap: () => _applyColor(Note.colorOrange),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Note.colorRed),
                title: Text('빨강'),
                onTap: () => _applyColor(Note.colorRed),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Note.colorYellow),
                title: Text('노랑'),
                onTap: () => _applyColor(Note.colorYellow),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyColor(Color newColor) {
    setState(() {
      Navigator.pop(context);
      color = newColor;
    });
  }

  void _saveNote() {
    if (bodyController.text.isNotEmpty) {
      final note = Note(
        bodyController.text,
        title: titleController.text,
        color: color,
      );

      final noteId = widget.id;
      if (noteId != null) {
        noteManager().updateNote(noteId, note);
      } else {
        noteManager().addNote(note);
      }

      _interstitial?.show();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('노트를 입력하세요'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
