import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

const A_BIN_INDEX = 0;
const B_BIN_INDEX = 1;
const Y_BIN_INDEX = 2;
const X_BIN_INDEX = 3;
const R_BIN_INDEX = 4;
const L_BIN_INDEX = 5;
const SELECT_BIN_INDEX = 6;
const START_BIN_INDEX = 7;

class JoystickUI extends StatefulWidget {
  const JoystickUI({Key? key, this.title = 'ui of joystick', required this.socket, required this.hostIP}) : super(key: key);

  final String title;
  final RawDatagramSocket socket;
  final String hostIP;

  @override
  _JoystickUIState createState() => _JoystickUIState(socket: socket, hostIP: hostIP);
}

final _counter = ValueNotifier<int>(0);

class _JoystickUIState extends State<JoystickUI> {
  _JoystickUIState({required this.socket, required this.hostIP}) : super();

  final RawDatagramSocket socket;
  final String hostIP;
  int port = 2812;
  JoystickPainter joystick = JoystickPainter(notifier: _counter);
  int _downCounter = 0;
  int _upCounter = 0;
  double x = 0.0;
  double y = 0.0;
  String  oldButtonData = '';

  @override
  void initState() {
    super.initState();
    // RawDatagramSocket.bind(InternetAddress.anyIPv4, 55555).then((value) {
    //   socket = value;
    //   socket.broadcastEnabled = true;
    // });
    // socket.broadcastEnabled = true;
  }  

  void _incrementDown(PointerEvent details) {
    joystick.updateStatesPress(details);
    _counter.value++;
    // _updateLocation(details);
    setState(() {
      // joystick.isBPressed = true;
      // _downCounter++;
    });
  }

  void _incrementUp(PointerEvent details) {
    joystick.updateStatesRelease(details);
    _counter.value++;
    // _updateLocation(details);
    setState(() {
      // joystick.isBPressed = false;
      // _upCounter++;
    });
  }

  void _updateLocation(PointerEvent details) {
    joystick.updateStatesMove(details);
    _counter.value++;
    setState(() {
      // x = details.position.dx;
      // y = details.position.dy;
      // joystick.buttonCenter = details.position;
      // print(joystick.buttonCenter);
    });
  }

  void send_data() {
    String buttonData = joystick.generateButtonData();
    if (buttonData != oldButtonData) {
      print(buttonData);
      oldButtonData = buttonData;
      socket.send(buttonData.codeUnits, InternetAddress(hostIP), port);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    send_data();
    return Scaffold(
      body: Container(
        child: Listener(
          onPointerDown: _incrementDown,
          onPointerMove: _updateLocation,
          onPointerUp: _incrementUp,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: CustomPaint(painter: joystick),
          ),
        ),
      )
    );
  }
}

class CanvasDrawable {
  void draw(Canvas canvas) {
    print('BASE CLASS DRAWABLE');
  }
}

class CanvasInteractor extends CanvasDrawable {
  bool isPressed = false;

  void activate(PointerEvent details) {
    print('BASE INTERACTOR ACTIVATE');
  }

  void deactivate(PointerEvent details) {
    print('BASE INTERACTOR DEACTIVATE');
  }

  void move_test(PointerEvent details) {
    print('BASE INTERACTOR MOVE_TEST');
  }
}

class CanvasHandler extends CanvasInteractor {
  double activationRadius = 150;
  double effectRadius = 100;
  Offset center = Offset(200, 300);
  double handlerRadius = 40;
  Offset handlerCenter = Offset(200, 300);
  Offset handlerAnchor = Offset(200, 300);
  double xDrag = 0;
  double yDrag = 0;
  Offset drag = Offset(0, 0);
  int controlPointer = -1;
  Paint backgroundPaint = Paint();
  Paint handlerPaint = Paint();
  Paint activationAreaPaint = Paint();

  CanvasHandler({
    double effectRadius = 100,
    double centerX = 200,
    double centerY = 300,
    double handlerRadius = 40,
    Color backgroundColor = Colors.indigo,
    Color handlerColor = Colors.blue,
    Color activationColor = Colors.blue,
  }) {
    this.effectRadius = effectRadius;
    this.center = Offset(centerX, centerY);
    this.handlerRadius = handlerRadius;
    this.handlerCenter = this.center;
    this.handlerAnchor = this.center;
    this.backgroundPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = backgroundColor;
    this.handlerPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = handlerColor;
    this.activationAreaPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = activationColor;
  }

  @override
  void activate(PointerEvent details) {
    if (controlPointer != -1) return;
    Offset distance = details.position - center;
    if (sqrt(pow(distance.dx, 2) + pow(distance.dy, 2)) <= activationRadius) {
      controlPointer = details.pointer;
      handlerAnchor = details.position;
      // drag = distance;
      // if (drag.distance > effectRadius) {
      //   drag = drag.scale(1/drag.distance, 1/drag.distance) * effectRadius;

      // }
      handlerCenter = handlerAnchor;
    }
  }

  @override
  void deactivate(PointerEvent details) {
    if (controlPointer == details.pointer) {
      controlPointer = -1;
      drag = Offset(0, 0);
      handlerAnchor = center;
    }
    handlerCenter = center+drag;
  }

  @override
  void move_test(PointerEvent details) {
    if (controlPointer != details.pointer) return;
    Offset distance = details.position - handlerAnchor;
    drag = distance;
    if (drag.distance > effectRadius) {
      drag = drag.scale(1/drag.distance, 1/drag.distance) * effectRadius;
    }
    handlerCenter = handlerAnchor+drag;
  }

  @override
  void draw(Canvas canvas) {
    canvas.drawCircle(center, activationRadius, activationAreaPaint);
    if (controlPointer != -1) {
      canvas.drawCircle(handlerAnchor, effectRadius, backgroundPaint);
      canvas.drawCircle(handlerCenter, handlerRadius, handlerPaint);
    }
  }
}

class CanvasButton extends CanvasInteractor{
  bool isPressed = false;
  Set<int> pointers = Set();
  double bigRadius = 40;
  double smallRadius = 35;
  Offset center = Offset(775, 200);
  Paint backgroundPaint = Paint();
  Paint normalPaint = Paint();
  Paint pressedPaint = Paint();
  TextStyle textStyle = TextStyle();
  TextSpan textSpan = TextSpan();
  TextPainter textPainter = TextPainter();
  Offset textOffset = Offset(10, 20);

  CanvasButton({String text = 'B',
                double bigRadius = 40,
                double smallRadius = 35,
                double centerX = 500,
                double centerY = 500,
                Color backgroundColor = Colors.black,
                Color normalColor = Colors.red,
                Color pressedColor = Colors.yellow,
                Color textColor = Colors.black,
                double textOffsetX = 10,
                double textOffsetY = 20,
                double fontSize = 35}) {
                  this.bigRadius = bigRadius;
                  this.smallRadius = smallRadius;
                  this.center = Offset(centerX, centerY);
                  this.textOffset = Offset(textOffsetX, textOffsetY);
                  this.backgroundPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = backgroundColor;
                  this.normalPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = normalColor;
                  this.pressedPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = pressedColor;
                  this.textStyle = TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                  );
                  this.textSpan = TextSpan(
                    text: text,
                    style: this.textStyle,
                  );
                  this.textPainter = TextPainter(
                    text: this.textSpan,
                    textDirection: TextDirection.ltr,
                  );
                  this.textPainter.layout(
                    minWidth: 0,
                  );
  }

  @override
  void activate(PointerEvent details) {
    Offset distance = details.position - center;
    if (sqrt(pow(distance.dx, 2) + pow(distance.dy, 2)) <= bigRadius) {
      pointers.add(details.pointer);
    }
    if (pointers.length > 0) {
      isPressed = true;
    }
    else {
      isPressed = false;
    }
  }

  @override
  void deactivate(PointerEvent details) {
    if (!pointers.contains(details.pointer)) return;
    Offset distance = details.position - center;
    if (sqrt(pow(distance.dx, 2) + pow(distance.dy, 2)) <= bigRadius) {
      pointers.remove(details.pointer);
    }
    if (pointers.length > 0) {
      isPressed = true;
    }
    else {
      isPressed = false;
    }
  }

  @override
  void move_test(PointerEvent details) {
    Offset distance = details.position - center;
    if (sqrt(pow(distance.dx, 2) + pow(distance.dy, 2)) <= bigRadius) {
      pointers.add(details.pointer);
      isPressed = pointers.length > 0;
    }
    else {
      pointers.remove(details.pointer);
      isPressed = pointers.length > 0;
    }
  }

  @override
  void draw(Canvas canvas) {
    canvas.drawCircle(center, bigRadius, backgroundPaint);
    canvas.drawCircle(center, smallRadius, isPressed ? pressedPaint : normalPaint);
    textPainter.paint(canvas, center-textOffset);
  }
}

class CanvasConeButton extends CanvasInteractor {
  bool isPressed = false;
  Set<int> pointers = Set();
  double bigRadius = 40;
  double smallRadius = 35;
  Offset center = Offset(775, 200);
  Paint backgroundPaint = Paint();
  Paint normalPaint = Paint();
  Paint pressedPaint = Paint();
  TextStyle textStyle = TextStyle();
  TextSpan textSpan = TextSpan();
  TextPainter textPainter = TextPainter();
  Offset textOffset = Offset(10, 20);
  double startAngle = 0;
  double sweepAngle = pi*2;
  double twoPI = pi*2;
  Offset pointingDirection = Offset(0, 0);

  CanvasConeButton({String text = 'B',
                double bigRadius = 40,
                double smallRadius = 35,
                double centerX = 500,
                double centerY = 500,
                Color backgroundColor = Colors.black,
                Color normalColor = Colors.red,
                Color pressedColor = Colors.yellow,
                Color textColor = Colors.black,
                double textOffsetX = 10,
                double textOffsetY = 20,
                double fontSize = 35,
                double startAngle = 0,
                double sweepAngle = pi*2}) {
                  this.bigRadius = bigRadius;
                  this.smallRadius = smallRadius;
                  this.center = Offset(centerX, centerY);
                  this.textOffset = Offset(textOffsetX, textOffsetY);
                  this.startAngle = startAngle;
                  this.sweepAngle = sweepAngle;
                  this.backgroundPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = backgroundColor;
                  this.normalPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = normalColor;
                  this.pressedPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = pressedColor;
                  this.textStyle = TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                  );
                  this.textSpan = TextSpan(
                    text: text,
                    style: this.textStyle,
                  );
                  this.textPainter = TextPainter(
                    text: this.textSpan,
                    textDirection: TextDirection.ltr,
                  );
                  this.textPainter.layout(
                    minWidth: 0,
                  );
                  this.pointingDirection = Offset.fromDirection(startAngle+(sweepAngle/2));
  }

  bool inside(PointerEvent details) {
    Offset distance = details.position - center;
    double direction = distance.direction;
    if (direction < 0) {
      double opposite = -direction;
      direction = pi + (pi + direction);
    }
    return (sqrt(pow(distance.dx, 2) + pow(distance.dy, 2)) <= bigRadius
            && (direction > startAngle && direction < startAngle+sweepAngle ||
                direction+twoPI > startAngle && direction+twoPI < startAngle+sweepAngle));
  }

  @override
  void activate(PointerEvent details) {
    Offset distance = details.position - center;
    double direction = distance.direction;
    if (direction < 0) {
      double opposite = -direction;
      direction = pi + (pi + direction);
    }
    if (inside(details)) {
      pointers.add(details.pointer);
    }
    if (pointers.length > 0) {
      isPressed = true;
    }
    else {
      isPressed = false;
    }
  }

  @override
  void deactivate(PointerEvent details) {
    if (!pointers.contains(details.pointer)) return;
    if (inside(details)) {
      pointers.remove(details.pointer);
    }
    if (pointers.length > 0) {
      isPressed = true;
    }
    else {
      isPressed = false;
    }
  }

  @override
  void move_test(PointerEvent details) {
    if (inside(details)) {
      pointers.add(details.pointer);
      isPressed = pointers.length > 0;
    }
    else {
      pointers.remove(details.pointer);
      isPressed = pointers.length > 0;
    }
  }

  @override
  void draw(Canvas canvas) {
    canvas.drawArc(Rect.fromCircle(center: center, radius: bigRadius), startAngle, sweepAngle, true, backgroundPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: smallRadius), startAngle, sweepAngle, true, isPressed ? normalPaint : pressedPaint);
    textPainter.paint(canvas, center+(pointingDirection*(bigRadius/2))-textOffset);
  }
}

class JoystickPainter extends CustomPainter {
  ValueNotifier<int> notifier;
  Map<String, CanvasInteractor> buttons = Map();
  CanvasHandler handler = CanvasHandler();
  Paint handlerBackgroundPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = Colors.indigo.shade100;
  Paint handlerPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = Colors.indigo.shade400;

  JoystickPainter({required this.notifier}) : super(repaint: notifier) {
    handler = CanvasHandler(
      effectRadius: 100,
      centerX: 200,
      centerY: 300,
      handlerRadius: 40,
      backgroundColor: Colors.indigo.shade100,
      handlerColor: Colors.indigo.shade400,
      activationColor: Colors.black26,
    );

    buttons['A'] = CanvasConeButton(
      text: 'A',
      centerX: 700,
      centerY: 200,
      smallRadius: 100,
      bigRadius: 110,
      normalColor: Colors.green.shade800,
      pressedColor: Colors.green.shade400,
      startAngle: (pi/4),
      sweepAngle: pi/2,
    );

    buttons['B'] = CanvasConeButton(
      text: 'B',
      centerX: 700,
      centerY: 200,
      smallRadius: 100,
      bigRadius: 110,
      normalColor: Colors.red.shade800,
      pressedColor: Colors.red.shade400,
      startAngle: (pi/4)*7,
      sweepAngle: pi/2,
    );

    buttons['Y'] = CanvasConeButton(
      text: 'Y',
      centerX: 700,
      centerY: 200,
      smallRadius: 100,
      bigRadius: 110,
      normalColor: Colors.yellow.shade800,
      pressedColor: Colors.yellow.shade400,
      startAngle: (pi/4)*5,
      sweepAngle: pi/2,
    );

    buttons['X'] = CanvasConeButton(
      text: 'X',
      centerX: 700,
      centerY: 200,
      smallRadius: 100,
      bigRadius: 110,
      normalColor: Colors.blue.shade800,
      pressedColor: Colors.blue.shade400,
      startAngle: (pi/4)*3,
      sweepAngle: pi/2,
    );

    buttons['R'] = CanvasButton(
      text: 'R',
      centerX: 800,
      centerY: 50,
      normalColor: Colors.grey.shade800,
      pressedColor: Colors.grey.shade400,
    );

    buttons['L'] = CanvasButton(
      text: 'L',
      centerX: 100,
      centerY: 50,
      normalColor: Colors.grey.shade800,
      pressedColor: Colors.grey.shade400,
    );

    buttons['Select'] = CanvasButton(
      text: 'Select',
      centerX: 400,
      centerY: 400,
      normalColor: Colors.grey.shade800,
      pressedColor: Colors.grey.shade400,
      fontSize: 20,
      textOffsetX: 25,
      textOffsetY: 15,
    );

    buttons['Start'] = CanvasButton(
      text: 'Start',
      centerX: 600,
      centerY: 400,
      normalColor: Colors.grey.shade800,
      pressedColor: Colors.grey.shade400,
      fontSize: 20,
      textOffsetX: 20,
      textOffsetY: 15,
    );
  }

  void updateStatesPress(PointerEvent details) {
    buttons.forEach((String k, CanvasInteractor b) {
      b.activate(details);
    });

    handler.activate(details);
  }

  void updateStatesRelease(PointerEvent details) {
    buttons.forEach((String k, CanvasInteractor b) {
      b.deactivate(details);
    });

    handler.deactivate(details);
  }

  void updateStatesMove(PointerEvent details) {
    buttons.forEach((String k, CanvasInteractor b) {
      b.move_test(details);
    });

    handler.move_test(details);
  }

  String generateButtonData() {
    String data = '';
    data = data + (buttons['A']!.isPressed ? '1' : '0');
    data = data + (buttons['B']!.isPressed ? '1' : '0');
    data = data + (buttons['Y']!.isPressed ? '1' : '0');
    data = data + (buttons['X']!.isPressed ? '1' : '0');
    data = data + (buttons['R']!.isPressed ? '1' : '0');
    data = data + (buttons['L']!.isPressed ? '1' : '0');
    data = data + (buttons['Select']!.isPressed ? '1' : '0');
    data = data + (buttons['Start']!.isPressed ? '1' : '0');
    data = data + '/' + handler.drag.dx.round().toString();
    data = data + '/' + handler.drag.dy.round().toString();
    return data;
  }

  @override
  void paint(Canvas canvas, Size size) {
    buttons.forEach((String k, CanvasInteractor b) {
      b.draw(canvas);
    });

    handler.draw(canvas);
  }

  @override
  bool shouldRepaint(JoystickPainter oldDelegate) => true;
}