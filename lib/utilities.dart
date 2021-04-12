import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Utilities {
  Gradient themeColor = LinearGradient(
      colors: [Color.fromRGBO(22, 34, 42, 1), Color.fromRGBO(58, 96, 115, 1)]);

  
  Gradient homeCardThemeColor = LinearGradient(colors: [
    Color.fromRGBO(192, 108, 132,1),
    Color.fromRGBO(108, 91, 123, 1),
    Color.fromRGBO(53, 92, 125, 1),
  ]);
  Gradient homeCardThemeColorLight = LinearGradient(colors: [
    Color.fromRGBO(63, 173, 168, 1),
    Color.fromRGBO(128, 128, 128, 1),
  ]);
  
  Gradient kurCardThemeColor = LinearGradient(colors: [
    Color.fromRGBO(162, 171, 88, 1),
    Color.fromRGBO(99,99,99, 1),
  ]);

  Gradient addParaBirimColor = LinearGradient(colors: [
    Color.fromRGBO(67, 198, 172, 1),
    Color.fromRGBO(248, 255, 174, 1),
  ]);
  Gradient graphicSeeColor = LinearGradient(colors: [
    Color.fromRGBO(0, 242, 96, 1),
    Color.fromRGBO(5, 117, 230, 1),
  ]);



  Widget spinkit() {
    return Center(
        child: SpinKitChasingDots(
      duration: const Duration(milliseconds: 900),
      size: 50,
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Colors.white60),
        );
      },
    ));
  }
}