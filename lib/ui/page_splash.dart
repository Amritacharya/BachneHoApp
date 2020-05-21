import 'dart:async';
import 'package:Bechneho/authentication/authentication_bloc.dart';
import 'package:Bechneho/login_bloc/login_page.dart';
import 'package:flutter/material.dart';
import 'package:Bechneho/utils/utils.dart';

import '../LocalBindings.dart';
import '../user_repository.dart';
import 'page_home.dart';
import 'page_login.dart';
import 'page_onboarding.dart';

class SplashScreen extends StatefulWidget {
  final UserRepository userRepository;

  SplashScreen({Key key, @required this.userRepository}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserRepository get _userRepository => widget.userRepository;

  Screen size;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      navigateFromSplash();
    });
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
        body: Center(
            child: Container(
                width: size.getWidthPx(300),
                height: size.getWidthPx(300),
                child: Image.asset("assets/logo_splash.png"))));
  }

  Future navigateFromSplash() async {
    // String isOnBoard =
    //     await LocalStorage.sharedInstance.readValue(Constants.isOnBoard);
    // if (isOnBoard == null || isOnBoard == "0") {
    //   //Navigate to OnBoarding Screen.
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
    // } else {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(userRepository: _userRepository)));
  }
  //}
}
