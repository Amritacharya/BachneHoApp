import 'dart:convert';

import 'package:Bechneho/login_bloc/signup_page.dart';
import 'package:Bechneho/ui/page_home.dart';
import 'package:Bechneho/ui/page_splash.dart';
import 'package:Bechneho/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication/authentication.dart';
import 'authentication/authentication_bloc.dart';
import 'bloc_delegate.dart';
import 'error.dart';
import 'login_bloc/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _App();
  }
}

class _App extends State<App> {
  bool status;
  @override
  void initState() {
    getConnection().then((f) {
      setState(() {
        status = f;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> getConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool flag;
    if (connectivityResult == ConnectivityResult.mobile) {
      flag = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      flag = true;
    } else {
      flag = false;
    }
    return flag;
  }

  @override
  Widget build(BuildContext context) {
    return status == false
        ? ErrorPage()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is AuthenticationUninitialized) {
                  return LoginPage(userRepository: widget.userRepository);
                }
                if (state is AuthenticationAuthenticated) {
                  print("called");
                  return HomePage();
                }
                if (state is AuthenticationAuthenticate) {
                  print("called2");
                  return HomePage();
                }
                if (state is AuthenticationSignUp) {
                  print("called3");
                  return SignUpPage(userRepository: widget.userRepository);
                }
                if (state is AuthenticationUnauthenticated) {
                  return LoginPage(userRepository: widget.userRepository);
                }
                if (state is AuthenticationLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SplashScreen(userRepository: widget.userRepository);
              },
            ),
          );
  }
}
