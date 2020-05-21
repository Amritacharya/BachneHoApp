import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Image.asset(
                  "assets/logo_splash.png",
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
                Text(
                  "Please connect to wifi or turn on mobile data to explore the store.",
                  textAlign: TextAlign.center,
                ),
                RaisedButton(
                  child: Text(
                    "Go to Setting",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color.fromRGBO(63, 169, 245, 1),
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
              ])),
        ));
  }
}
