import 'package:flutter/material.dart';
import 'package:lcs_mobile/page/note_edit_page.dart';
import 'package:lcs_mobile/page/note_list_page.dart';
import 'package:lcs_mobile/page/note_view_page.dart';

void main() {
  runApp(const MyApp());
}

Text sampleText = const Text(
  '나랏미 영국에라 문장와로 서로 사맣디 아니할새',
  maxLines: 1,
  overflow: TextOverflow.clip,
  textAlign: TextAlign.end,
  style: TextStyle(
    // color: Theme.of(context).colorScheme.onPrimary,
    fontSize: 24.0,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w900,
    fontFamily: 'NotoSansKR',
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        // useMaterial3: true,
      ),
      initialRoute: NoteListPage.routeName,
      routes: {
        NoteListPage.routeName: (context) => NoteListPage(),
        NoteEditPage.routeName: (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final id = args != null ? args as int : null;
          return NoteEditPage(id);
        },
        NoteViewPage.routeName: (context) {
          final id = ModalRoute.of(context)!.settings.arguments as int;
          return NoteViewPage(id);
        },
      },
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//       _counter++;
//     });
//   }

//   void _decrementCounter() {
//     setState(() {
//       _counter--;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       // body: Container(
//       //   color: Colors.blue,
//       //   padding: EdgeInsets.all(16.0),
//       //   alignment: Alignment.topRight,
//       //   width: 200,
//       //   height: 200,
//       //   child: sampleText,
//       // ),
//       // body: SizedBox.expand(),
//       // body: Padding(padding: EdgeInsets.all(16.0), child: sampleText),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           sampleText,
//           sampleText,
//           sampleText,
//           sampleText,
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _decrementCounter,
//         tooltip: 'Increment',
//         icon: const Icon(Icons.remove),
//         label: const Text('Remove'),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//     );
//   }
// }
