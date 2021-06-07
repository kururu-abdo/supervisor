import 'dart:async';

import 'package:app3/main.dart';
import 'package:app3/screens/login.dart';
import 'package:app3/util/constants.dart';

import 'package:flutter/material.dart';

import '../firebase_init.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>   with SingleTickerProviderStateMixin {

   var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    FirebaseInit.init();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTimer();
  }

  startTimer() async {
    Timer(Duration(seconds: 4), () async {
      await navigateTo();
    });
  }

  navigateTo() async {
    var isLogged = getStorage.read('isLogged') ?? false;

    if (isLogged) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => 
             Material(child: HomePage())));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Material(child: Login())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
          padding: EdgeInsets.only(bottom: 30.0),
          child: new Image.asset(
            'assets/images/logo.jpg',
            height: 100.0,
            width: 100.0,
          )),
    )

        //  Stack(
        //   fit: StackFit.expand,
        //   children: <Widget>[
        //     new Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       mainAxisSize: MainAxisSize.min,
        //       children: <Widget>[

        //         Padding(padding: EdgeInsets.only(bottom: 30.0),child:new Image.asset('assets/images/splash.jpg',height: 25.0,fit: BoxFit.scaleDown,))

        //     ],),

        //   ],
        // ),
        );
  }
}