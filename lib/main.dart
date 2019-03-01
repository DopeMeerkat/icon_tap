//import 'dart:math';
import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart' show timeDilation;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.lightBlue[100],
        primaryColorDark: Colors.red[300],
        // colorScheme: ColorScheme.dark(),
        //primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: NewHomePage(),
    );
  }
}

class NewHomePage extends StatelessWidget {
  NewHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          // Image.asset(
          //   'images/map.jpg',
          //   fit: BoxFit.fitHeight,
          // ),
          TapDemo(),
        ],
      ),
    );
  }
}

class TapDemo extends StatefulWidget {
  @override
  _TapDemoState createState() => _TapDemoState();
}

class _TapDemoState extends State<TapDemo> with TickerProviderStateMixin {
  AnimationController _controller;

  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
      builder: (context) => Positioned(
            left: offset.dx,
            top: offset.dy,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              //onTap:
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
                  ),
                  child: Container(
                    height: 130,
                    width: 130,
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        image: new ExactAssetImage('images/ryxu.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(75.0)),
                      border: new Border.all(
                        color: Colors.lightBlue,
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      this._overlayEntry = this._createOverlayEntry();
      Overlay.of(context).insert(this._overlayEntry);
      await _controller.forward().orCancel;
    } on TickerCanceled {}
  }

  Future<void> _reverseAnimation() async {
    try {
      await _controller.reverse().orCancel;
      this._overlayEntry.remove();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 550,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                onPressed: _playAnimation,
                child: Icon(Icons.play_arrow),
                elevation: 2.0,
              ),
              SizedBox(width: 50),
              FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColorDark,
                onPressed: _reverseAnimation,
                child: Icon(
                  Icons.stop, /*color: Theme.of(context).primaryColor*/
                ),
                elevation: 2.0,
              ),
            ],
          ),
        ]);
  }
}
