import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:listener_widgets/JoystickUI.dart';
import 'package:listener_widgets/main.dart';

// const A_BIN_INDEX = 0;
// const B_BIN_INDEX = 1;
// const Y_BIN_INDEX = 2;
// const X_BIN_INDEX = 3;
// const R_BIN_INDEX = 4;
// const L_BIN_INDEX = 5;
// const SELECT_BIN_INDEX = 6;
// const START_BIN_INDEX = 7;

class JoystickMover extends StatefulWidget {
  const JoystickMover({Key? key, this.title = 'ui of joystick'}) : super(key: key);

  final String title;

  @override
  _JoystickMoverState createState() => _JoystickMoverState();
}

final _counter = ValueNotifier<int>(0);

class _JoystickMoverState extends State<JoystickMover> {
  _JoystickMoverState() : super();

  JoystickPainterMover joystick = JoystickPainterMover(notifier: _counter);
  int _downCounter = 0;
  int _upCounter = 0;
  double x = 0.0;
  double y = 0.0;

  @override
  void initState() {
    super.initState();
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

  // void send_data() {
  //   String buttonData = joystick.generateButtonData();
  //   if (buttonData != oldButtonData) {
  //     print(buttonData);
  //     oldButtonData = buttonData;
  //     socket.send(buttonData.codeUnits, InternetAddress(hostIP), port);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    // send_data();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JoystickHomepage(title: 'joystick')));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.close),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterTop,
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

// class CanvasDrawable {
//   void draw(Canvas canvas) {
//     print('BASE CLASS DRAWABLE');
//   }
// }

// class CanvasInteractor extends CanvasDrawable {
//   bool isPressed = false;
//   Offset center = Offset(200, 300);

//   void activate(PointerEvent details) {
//     print('BASE INTERACTOR ACTIVATE');
//   }

//   void deactivate(PointerEvent details) {
//     print('BASE INTERACTOR DEACTIVATE');
//   }

//   void move_test(PointerEvent details) {
//     print('BASE INTERACTOR MOVE_TEST');
//   }
// }

class CanvasHandlerMover extends CanvasHandler {
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

  CanvasHandlerMover({
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
    center = center + details.delta;
    // Offset distance = details.position - handlerAnchor;
    // drag = distance;
    // if (drag.distance > effectRadius) {
    //   drag = drag.scale(1/drag.distance, 1/drag.distance) * effectRadius;
    // }
    // handlerCenter = handlerAnchor+drag;
  }

  @override
  void draw(Canvas canvas) {
    canvas.drawCircle(center, activationRadius, activationAreaPaint);
    // if (controlPointer != -1) {
    //   canvas.drawCircle(handlerAnchor, effectRadius, backgroundPaint);
    //   canvas.drawCircle(handlerCenter, handlerRadius, handlerPaint);
    // }
  }
}

class CanvasButtonMover extends CanvasButton {
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

  CanvasButtonMover({String text = 'B',
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
      center = center + details.delta;
      // pointers.add(details.pointer);
      // isPressed = pointers.length > 0;
    }
    // else {
    //   pointers.remove(details.pointer);
    //   isPressed = pointers.length > 0;
    // }
  }

  @override
  void draw(Canvas canvas) {
    canvas.drawCircle(center, bigRadius, backgroundPaint);
    canvas.drawCircle(center, smallRadius, isPressed ? pressedPaint : normalPaint);
    textPainter.paint(canvas, center-textOffset);
  }
}



class CanvasButtonCaller extends CanvasButton {
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
  VoidCallback? callback;

  CanvasButtonCaller({String text = 'B',
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
                VoidCallback? callback}) {
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
                  this.callback = callback;
  }

  @override
  void activate(PointerEvent details) {
    Offset distance = details.position - center;
    if (sqrt(pow(distance.dx, 2) + pow(distance.dy, 2)) <= bigRadius) {
      pointers.add(details.pointer);
      if (callback != null) {
        callback?.call;
      }
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
      center = center + details.delta;
      // pointers.add(details.pointer);
      // isPressed = pointers.length > 0;
    }
    // else {
    //   pointers.remove(details.pointer);
    //   isPressed = pointers.length > 0;
    // }
  }

  @override
  void draw(Canvas canvas) {
    canvas.drawCircle(center, bigRadius, backgroundPaint);
    canvas.drawCircle(center, smallRadius, isPressed ? pressedPaint : normalPaint);
    textPainter.paint(canvas, center-textOffset);
  }
}

class JoystickPainterMover extends CustomPainter {
  ValueNotifier<int> notifier;
  Map<String, CanvasInteractor> buttons = Map();
  CanvasHandler handler = CanvasHandler();
  Paint handlerBackgroundPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = Colors.indigo.shade100;
  Paint handlerPaint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = Colors.indigo.shade400;

  void loadTrueCoordinates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    handler.center = Offset(prefs.getDouble('HandlerX') ?? 0, prefs.getDouble('HandlerY') ?? 0);
    buttons['XYAB']?.center = Offset(prefs.getDouble('PizzaButtonsX') ?? 0, prefs.getDouble('PizzaButtonsY') ?? 0);
    buttons['L']?.center = Offset(prefs.getDouble('LButtonX') ?? 0, prefs.getDouble('LButtonY') ?? 0);
    buttons['R']?.center = Offset(prefs.getDouble('RButtonX') ?? 0, prefs.getDouble('RButtonY') ?? 0);
    buttons['Start']?.center = Offset(prefs.getDouble('StartX') ?? 0, prefs.getDouble('StartY') ?? 0);
    buttons['Select']?.center = Offset(prefs.getDouble('SelectX') ?? 0, prefs.getDouble('SelectY') ?? 0);
    // print("X position:");
    // print(Offset(prefs.getDouble('PizzaButtonsX') ?? 0, prefs.getDouble('PizzaButtonsY') ?? 0));
  }

  void saveNewCoordinates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('PizzaButtonsX', buttons['XYAB']?.center.dx ?? 0);
    prefs.setDouble('PizzaButtonsY', buttons['XYAB']?.center.dy ?? 0);
    
    prefs.setDouble('LButtonX', buttons['L']?.center.dx ?? 0);
    prefs.setDouble('LButtonY', buttons['L']?.center.dy ?? 0);
    
    prefs.setDouble('RButtonX', buttons['R']?.center.dx ?? 0);
    prefs.setDouble('RButtonY', buttons['R']?.center.dy ?? 0);
    
    prefs.setDouble('SelectX', buttons['Select']?.center.dx ?? 0);
    prefs.setDouble('SelectY', buttons['Select']?.center.dy ?? 0);
    
    prefs.setDouble('StartX', buttons['Start']?.center.dx ?? 0);
    prefs.setDouble('StartY', buttons['Start']?.center.dy ?? 0);
    
    prefs.setDouble('HandlerX', handler.center.dx ?? 0);
    prefs.setDouble('HandlerY', handler.center.dy ?? 0);
  }

  JoystickPainterMover({required this.notifier}) : super(repaint: notifier) {
   handler = CanvasHandlerMover(
      effectRadius: 100,
      centerX: 200,
      centerY: 300,
      handlerRadius: 40,
      backgroundColor: Colors.indigo.shade100,
      handlerColor: Colors.indigo.shade400,
      activationColor: Colors.black26,
    );

    buttons['XYAB'] = CanvasButtonMover(
      text: 'XYAB',
      centerX: 700,
      centerY: 200,
      smallRadius: 100,
      bigRadius: 110,
      normalColor: Colors.blue.shade800,
      pressedColor: Colors.blue.shade400,
    );

    buttons['R'] = CanvasButtonMover(
      text: 'R',
      centerX: 800,
      centerY: 50,
      normalColor: Colors.grey.shade800,
      pressedColor: Colors.grey.shade400,
    );

    buttons['L'] = CanvasButtonMover(
      text: 'L',
      centerX: 100,
      centerY: 50,
      normalColor: Colors.grey.shade800,
      pressedColor: Colors.grey.shade400,
    );

    buttons['Select'] = CanvasButtonMover(
      text: 'Select',
      centerX: 400,
      centerY: 400,
      normalColor: Colors.grey.shade800,
      pressedColor: Colors.grey.shade400,
      fontSize: 20,
      textOffsetX: 25,
      textOffsetY: 15,
    );

    buttons['Start'] = CanvasButtonMover(
      text: 'Start',
      centerX: 600,
      centerY: 400,
      normalColor: Colors.grey.shade800,
      pressedColor: Colors.grey.shade400,
      fontSize: 20,
      textOffsetX: 20,
      textOffsetY: 15,
    );

    // buttons['Exit'] = CanvasButtonCaller(
    //   text: 'Exit',
    //   centerX:600,
    //   centerY: 30,
    //   normalColor: Colors.blueGrey.shade400,
    //   pressedColor: Colors.blueGrey.shade200,
    //   fontSize: 20,
    //   textOffsetX: 20,
    //   textOffsetY: 15,
    //   callback: () {Navigator.pop(context);},
    // );

    loadTrueCoordinates();
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

    saveNewCoordinates();
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
  bool shouldRepaint(JoystickPainterMover oldDelegate) => true;
}