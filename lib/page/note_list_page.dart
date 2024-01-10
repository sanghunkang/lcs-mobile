import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lcs_mobile/data/note.dart';
import 'package:lcs_mobile/page/note_edit_page.dart';
import 'package:lcs_mobile/page/note_view_page.dart';
import 'package:lcs_mobile/providers.dart';

class NoteListPage extends StatefulWidget {
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _NoteListPageState();
  }
}

class _NoteListPageState extends State<NoteListPage> {
  BannerAd? _banner;

  @override
  void initState() {
    super.initState();
    adHelper().loadBanner((ad) {
      setState(() {
        _banner = ad;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sticky Notes'),
      ),
      body: FutureBuilder<List<Note>>(
        future: noteManager().listNotes(),
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

          final notes = snap.requireData;
          final gridView = GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) => _buildCard(notes[index]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
          );

          final banner = _banner;
          return banner != null
              ? Column(
                  children: [
                    _buildBanner(banner),
                    Expanded(
                      child: gridView,
                    ),
                  ],
                )
              : gridView;
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: '새 노트',
        onPressed: () {
          Navigator.pushNamed(context, NoteEditPage.routeName).then((_) => {
                setState(() {}),
              });
        },
      ),
    );
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  Widget _buildCard(Note note) {
    return InkWell(
      child: Card(
        color: note.color,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              note.title.isEmpty ? '제목 없음' : note.title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: Text(
                note.body,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          NoteViewPage.routeName,
          arguments: note.id,
        ).then((_) {
          setState(() {});
        });
      },
    );
  }

  Widget _buildBanner(BannerAd ad) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }
}
