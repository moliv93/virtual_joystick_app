import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late final RawDatagramSocket socket;
  int port = 2812;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 55555).then((value) {
      socket = value;
      socket.broadcastEnabled = true;
    });
    // socket.broadcastEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
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
                socket.send('BTN L 1'.codeUnits, InternetAddress('192.168.1.136'), port);
                print('L pressed');
              },
              onTapUp: (details) async {
                socket.send('BTN L 0'.codeUnits, InternetAddress('192.168.1.136'), port);
                print('L released');
              },
              onTapCancel: () async {
                socket.send('BTN L 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
              socket.send('ABS UP 1'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('UP pressed');
            },
            onTapUp: (details) async {
              socket.send('ABS UP 0'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('UP released');
            },
            onTapCancel: () async {
              socket.send('ABS UP 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
              socket.send('BTN Y 1'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('Y pressed');
            },
            onTapUp: (details) async {
              socket.send('BTN Y 0'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('Y released');
            },
            onTapCancel: () async {
              socket.send('BTN Y 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
              socket.send('BTN R 1'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('R pressed');
            },
            onTapUp: (details) async {
              socket.send('BTN R 0'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('R released');
            },
            onTapCancel: () async {
              socket.send('BTN R 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
              socket.send('ABS LEFT -1'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('LEFT pressed');
            },
            onTapUp: (details) async {
              socket.send('ABS LEFT 0'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('LEFT released');
            },
            onTapCancel: () async {
              socket.send('ABS LEFT 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
              socket.send('ABS RIGHT 1'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('RIGHT pressed');
            },
            onTapUp: (details) async {
              socket.send('ABS RIGHT 0'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('RIGHT released');
            },
            onTapCancel: () async {
              socket.send('ABS RIGHT 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
              socket.send('BTN X 1'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('X pressed');
            },
            onTapUp: (details) async {
              socket.send('BTN X 0'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('X released');
            },
            onTapCancel: () async {
              socket.send('BTN X 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
              socket.send('BTN B 1'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('B pressed');
            },
            onTapUp: (details) async {
              socket.send('BTN B 0'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('B released');
            },
            onTapCancel: () async {
              socket.send('BTN B 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
              socket.send('ABS DOWN -1'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('DOWN pressed');
            },
            onTapUp: (details) async {
              socket.send('ABS DOWN 0'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('DOWN released');
            },
            onTapCancel: () async {
              socket.send('ABS DOWN 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
              socket.send('BTN SELECT 1'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('SELECT pressed');
            },
            onTapUp: (details) async {
              socket.send('BTN SELECT 0'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('SELECT released');
            },
            onTapCancel: () async {
              socket.send('BTN SELECT 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
              socket.send('BTN START 1'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('START pressed');
            },
            onTapUp: (details) async {
              socket.send('BTN START 0'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('START released');
            },
            onTapCancel: () async {
              socket.send('BTN START 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
              socket.send('BTN A 1'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('A pressed');
            },
            onTapUp: (details) async {
              socket.send('BTN A 0'.codeUnits, InternetAddress('192.168.1.136'), port);
              print('A released');
            },
            onTapCancel: () async {
              socket.send('BTN A 0'.codeUnits, InternetAddress('192.168.1.136'), port);
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
      )
    );
  }
}