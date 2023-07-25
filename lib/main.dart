import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterMidi flutterMidi = FlutterMidi();
  String? choice;

  @override
  void initState() {
    load('assets/Guitar.sf2');
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    flutterMidi.prepare(
        sf2: _byte, name: 'assets/$choice.sf2'.replaceAll('assets/', ''));
  }

  Uri? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: DropdownButton(
            items: const [
              DropdownMenuItem(
                value: 'Yamaha-Grand',
                child: Text('Piano'),
              ),
              DropdownMenuItem(
                value: 'Guitar',
                child: Text('Guitar'),
              ),
              DropdownMenuItem(
                value: 'Strings',
                child: Text('Strings'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                choice = value;
              });
              load('assets/$choice.sf2');
            },
            value: choice ?? 'Strings',
          ),
        ),
        leadingWidth: 100,
        title: const Text('Piano'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              url = Uri.parse('tel:123');
              launchUrl(url!);
            },
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {
              url = Uri.parse('sms:123');
              launchUrl(url!);
            },
            icon: const Icon(Icons.sms),
          ),
          IconButton(
            onPressed: () {
              url = Uri.parse('mailto:example@gmail.com');
              launchUrl(url!);
            },
            icon: const Icon(Icons.email),
          ),
          IconButton(
            onPressed: () {
              url = Uri.parse('https://google.com');
              launchUrl(url!, mode: LaunchMode.externalApplication);
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Center(
        child: InteractivePiano(
          highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: 60,
          noteRange: NoteRange.forClefs([
            Clef.Bass,
          ]),
          onNotePositionTapped: (position) {
            print(position.pitch);
            flutterMidi.playMidiNote(midi: position.pitch);
          },
        ),
      ),
    );
  }
}
