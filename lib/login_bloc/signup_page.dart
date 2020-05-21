import 'package:Bechneho/ui/page_login.dart';
import 'package:Bechneho/ui/page_register.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Bechneho/user_repository.dart';
import 'package:Bechneho/authentication/authentication.dart';
import 'package:Bechneho/login_bloc/login.dart';

class SignUpPage extends StatefulWidget {
  final UserRepository userRepository;

  SignUpPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
      child: RegisterPage(
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
