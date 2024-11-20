import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cinesearch/bottomnav.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNav(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Lottie.network(
              'https://lottie.host/06389638-1efe-4cf8-b99f-4b611ba9c8b4/s1H31MhaZ4.json',
              width: 100,
              height: 100,
            ),
            AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                ScaleAnimatedText(
                  "CineSearch",
                  textStyle: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  duration: Duration(seconds: 4),
                ),
              ],
            ),
          ]),
        ));
  }
}
