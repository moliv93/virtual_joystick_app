import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Test App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late final Socket socket;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    Socket.connect('192.168.1.136', 55555).then((value) => socket = value);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 6,
        children: <Widget>[
          GestureDetector( // first row
            onTapDown: (details) async {
                socket.write('BTN L 1');
                print('L pressed');
              },
              onTapUp: (details) async {
                socket.write('BTN L 0');
                print('L released');
              },
              onTapCancel: () async {
                socket.write('BTN L 0');
                print('L canceled');
              },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("L", style: TextStyle(fontSize: 40, color: Colors.brown, fontWeight: FontWeight.bold))),
            )
          ),
          GestureDetector(
            onTapDown: (details) async {
              socket.write('ABS UP 1');
              print('UP pressed');
            },
            onTapUp: (details) async {
              socket.write('ABS UP 0');
              print('UP released');
            },
            onTapCancel: () async {
              socket.write('ABS UP 0');
              print('UP canceled');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("UP", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))),
            )
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black,
            // this container is left blank for spacing
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black,
            // this container is left blank for spacing
          ),
          GestureDetector(
            onTapDown: (details) async {
              socket.write('BTN Y 1');
              print('Y pressed');
            },
            onTapUp: (details) async {
              socket.write('BTN Y 0');
              print('Y released');
            },
            onTapCancel: () async {
              socket.write('BTN Y 0');
              print('Y canceled');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("Y", style: TextStyle(fontSize: 40, color: Colors.yellow, fontWeight: FontWeight.bold))),
            )
          ),
          GestureDetector(
            onTapDown: (details) async {
              socket.write('BTN R 1');
              print('R pressed');
            },
            onTapUp: (details) async {
              socket.write('BTN R 0');
              print('R released');
            },
            onTapCancel: () async {
              socket.write('BTN R 0');
              print('R canceled');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("R", style: TextStyle(fontSize: 40, color: Colors.brown, fontWeight: FontWeight.bold))),
            )
          ),
          GestureDetector( // 2 row
            onTapDown: (details) async {
              socket.write('ABS LEFT -1');
              print('LEFT pressed');
            },
            onTapUp: (details) async {
              socket.write('ABS LEFT 0');
              print('LEFT released');
            },
            onTapCancel: () async {
              socket.write('ABS LEFT 0');
              print('LEFT canceled');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("LEFT", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))),
            )
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black,
            // this container is left blank for spacing
          ),
          GestureDetector(
            onTapDown: (details) async {
              socket.write('ABS RIGHT 1');
              print('RIGHT pressed');
            },
            onTapUp: (details) async {
              socket.write('ABS RIGHT 0');
              print('RIGHT released');
            },
            onTapCancel: () async {
              socket.write('ABS RIGHT 0');
              print('RIGHT canceled');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("RIGHT", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))),
            )
          ),
          GestureDetector(
            onTapDown: (details) async {
              socket.write('BTN X 1');
              print('X pressed');
            },
            onTapUp: (details) async {
              socket.write('BTN X 0');
              print('X released');
            },
            onTapCancel: () async {
              socket.write('BTN X 0');
              print('X canceled');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("X", style: TextStyle(fontSize: 40, color: Colors.blue, fontWeight: FontWeight.bold))),
            )
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black,
            // this container is left blank for spacing
          ),
          GestureDetector(
            onTapDown: (details) async {
              socket.write('BTN B 1');
              print('B pressed');
            },
            onTapUp: (details) async {
              socket.write('BTN B 0');
              print('B released');
            },
            onTapCancel: () async {
              socket.write('BTN B 0');
              print('B canceled');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("B", style: TextStyle(fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold))),
            )
          ),
          Container( // 3 row
            padding: const EdgeInsets.all(8),
            color: Colors.black,
            // this container is left blank for spacing
          ),
          GestureDetector(
            onTapDown: (details) async {
              socket.write('ABS DOWN -1');
              print('DOWN pressed');
            },
            onTapUp: (details) async {
              socket.write('ABS DOWN 0');
              print('DOWN released');
            },
            onTapCancel: () async {
              socket.write('ABS DOWN 0');
              print('DOWN canceled');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("DOWN", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))),
            )
          ),
          GestureDetector(
            onTapDown: (details) async {
              socket.write('BTN SELECT 1');
              print('SELECT pressed');
            },
            onTapUp: (details) async {
              socket.write('BTN SELECT 0');
              print('SELECT released');
            },
            onTapCancel: () async {
              socket.write('BTN SELECT 0');
              print('SELECT canceled');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("SELECT", style: TextStyle(fontSize: 25, color: Colors.pink, fontWeight: FontWeight.bold))),
            )
          ),
          GestureDetector(
            onTapDown: (details) async {
              socket.write('BTN START 1');
              print('START pressed');
            },
            onTapUp: (details) async {
              socket.write('BTN START 0');
              print('START released');
            },
            onTapCancel: () async {
              socket.write('BTN START 0');
              print('START canceled');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("START", style: TextStyle(fontSize: 25, color: Colors.pink, fontWeight: FontWeight.bold))),
            )
          ),
          GestureDetector(
            onTapDown: (details) async {
              socket.write('BTN A 1');
              print('A pressed');
            },
            onTapUp: (details) async {
              socket.write('BTN A 0');
              print('A released');
            },
            onTapCancel: () async {
              socket.write('BTN A 0');
              print('A canceled');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: const Center(child: Text("A", style: TextStyle(fontSize: 40, color: Colors.green, fontWeight: FontWeight.bold))),
            )
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black,
            // this container is left blank for spacing
          ),
        ],
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}