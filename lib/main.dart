import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:imtihon/birinchi.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: bir(),
  ));
}

class bir extends StatefulWidget {
  const bir({super.key});

  @override
  State<bir> createState() => _birState();
}

class _birState extends State<bir> {
  void keyingisahifa() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keyingisahifa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Center(
          child: Lottie.asset("loti/loti1.json"),
        ),
        Container(
          child: SpinKitThreeBounce(
            size: 20,
            color: Colors.amber,
          ),
        )
      ],
    ));
  }
}
