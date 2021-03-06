import 'package:Bechneho/ui/page_login.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Bechneho/user_repository.dart';
import 'package:Bechneho/authentication/authentication.dart';
import 'package:Bechneho/login_bloc/login.dart';

class LoginPage extends StatefulWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  UserRepository _userRepository;

  @override
  void initState() {
    setState(() {
      _userRepository = widget.userRepository;
    });
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      userRepository: widget.userRepository,
      authenticationBloc: _authenticationBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: LoginScreen(
        authenticationBloc: _authenticationBloc,
        loginBloc: _loginBloc,
      ),
    ));
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }
}
