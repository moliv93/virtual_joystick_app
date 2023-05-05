import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:listener_widgets/JoystickUI.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Joystick',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JoystickHomepage(title: 'Flutter Demo Home Page'),
    );
  }
}

class JoystickHomepage extends StatefulWidget {
  const JoystickHomepage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _JoystickHomepageState createState() => _JoystickHomepageState();
}

class _JoystickHomepageState extends State<JoystickHomepage> {
  int serverPort = 2812;
  int clientPort = 55555;
  TextEditingController ipReader = TextEditingController();
  List<Widget> buttonInterfaces = [];

  @override
  void initState() {
    super.initState();
    NetworkInterface.list().then((var interfaces) {
      interfaces.forEach((var i) {
        final name = i.name;
        buttonInterfaces.add(TextButton(
          onPressed: () {
            findServer(name);
          },
          child: Text(name),
          )
        );
      });
      setState((){});
    });

  }

  void findServer(String interfaceName) async {

    final interfaces = await NetworkInterface.list();
    print(interfaces);

    // NetworkInterface wifi = null;
    // interfaces.forEach((interface) {
    //   if (interface.name == 'wlp6s0') {
    //     wifi = interface;
    //   }
    // });
    // print(interfaces);

    // Find the interface associated with the WiFi network
    final chosenInterface = interfaces.firstWhere(
      (interface) => interface.name.startsWith(interfaceName),
    );

    // Obtain the first IPv4 address associated with the WiFi interface
    final ipAddress = chosenInterface?.addresses
        .firstWhere((address) => address.type == InternetAddressType.IPv4,)
        ?.address;

    if (ipAddress != null) {
      print('The IP address of your network is: $ipAddress');
    } else {
      print('Unable to determine the IP address of your network.');
    }

    RawDatagramSocket handShakeSocket = await RawDatagramSocket.bind(ipAddress, clientPort);
    handShakeSocket.broadcastEnabled = true;
    // handShakeSocket.listen((RawSocketEvent e) {
    //   Datagram? d = handShakeSocket.receive();
    //   if (d == null) return;

    //   String message = new String.fromCharCodes(d.data);
    //   print('Datagram from ${d.address.address}:${d.port}: ${message.trim()}');
    //   if (message == 'GOODAY') {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JoystickUI(title: 'joystick', socket: handShakeSocket, hostIP: d.address.address)));
    //   }
    // });
    handShakeSocket.send('HENLO'.codeUnits, InternetAddress('255.255.255.255'), serverPort);
    sleep(Duration(seconds:1));
    Datagram? d = handShakeSocket.receive();
    if (d != null) {
      String message = new String.fromCharCodes(d.data);
      print('Datagram from ${d.address.address}:${d.port}: ${message.trim()}');
      if (message == 'GOODAY') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JoystickUI(title: 'joystick', socket: handShakeSocket, hostIP: d.address.address)));
      }
    }
  }

  void directlyConect(String ip) async {
    RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, clientPort);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JoystickUI(title: 'joystick', socket: socket, hostIP: ip)));
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    return Scaffold(
      body: Column(
        children: <Widget>[
          // TextButton(
          //   onPressed: () {findServer();},
          //   child: Text('Search for server automatically'),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttonInterfaces,
          ),
          TextField(
            controller: ipReader,
            decoration: InputDecoration(
              labelText: 'Or put the host IP manually:'
            )
          ),
          TextButton(
            onPressed: () {directlyConect(ipReader.text);},
            child: Text('Connect to the given IP'),
          )
        ],
      )
    );
  }
}