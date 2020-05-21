import 'package:Bechneho/authentication/authentication.dart';
import 'package:Bechneho/authentication/authentication_bloc.dart';
import 'package:Bechneho/login_bloc/login_bloc.dart';
import 'package:Bechneho/login_bloc/login_event.dart';
import 'package:Bechneho/login_bloc/login_state.dart';
import 'package:Bechneho/src/user_repository.dart';
import 'package:Bechneho/ui/page_register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'page_forgotpass.dart';
import 'page_home.dart';

class LoginScreen extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;
  LoginScreen({
    Key key,
    @required this.loginBloc,
    @required this.authenticationBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> with TickerProviderStateMixin {
  bool status = false;
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  FocusNode _emailFocusNode = new FocusNode();
  FocusNode _passFocusNode = new FocusNode();
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LoginBloc get _loginBloc => widget.loginBloc;
  Screen size;
  AuthenticationBloc get _authenticationBloc => widget.authenticationBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    size = Screen(MediaQuery.of(context).size);
    return BlocBuilder<LoginBloc, LoginState>(
        bloc: _loginBloc,
        builder: (
          BuildContext context,
          LoginState state,
        ) {
          if (state is LoginFailure) {
            _onWidgetDidBuild(() {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }

          return Scaffold(
              backgroundColor: backgroundColor,
              resizeToAvoidBottomInset: false,
              body: AnnotatedRegion(
                value: SystemUiOverlayStyle(
                    statusBarColor: backgroundColor,
                    statusBarBrightness: Brightness.light,
                    statusBarIconBrightness: Brightness.dark,
                    systemNavigationBarIconBrightness: Brightness.light,
                    systemNavigationBarColor: colorCurveSecondary),
                child: Container(
                  color: backgroundColor,
                  child: SafeArea(
                    top: true,
                    bottom: false,
                    child: Stack(fit: StackFit.expand, children: <Widget>[
                      ClipPath(
                          clipper: BottomShapeClipper(),
                          child: Container(
                            color: colorCurveSecondary,
                          )),
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.getWidthPx(20),
                              vertical: size.getWidthPx(20)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _loginGradientText(),
                                SizedBox(height: size.getWidthPx(10)),
                                _textAccount(authenticationBloc),
                                SizedBox(height: size.getWidthPx(30)),
                                loginFields(state)
                              ]),
                        ),
                      )
                    ]),
                  ),
                ),
              ));
        });
  }

  RichText _textAccount(AuthenticationBloc authenticationBloc) {
    return RichText(
      text: TextSpan(
          text: "Don't have an account? ",
          children: [
            TextSpan(
                style: TextStyle(color: Colors.deepOrange),
                text: 'Create your account.',
                recognizer: TapGestureRecognizer()
                  ..onTap = () => authenticationBloc.add(SignUp()))
          ],
          style: TextStyle(
              color: Colors.black87, fontSize: 14, fontFamily: 'Exo2')),
    );
  }

  GradientText _loginGradientText() {
    return GradientText('BechneHo',
        gradient:
            LinearGradient(colors: [Color(0xffed1c24), Color(0xffeaf2ff)]),
        style: TextStyle(
            fontFamily: 'Exo2', fontSize: 36, fontWeight: FontWeight.bold));
  }

  BoxField _emailWidget() {
    return BoxField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        hintText: "Enter Username/email",
        lableText: "Username/Email",
        obscureText: false,
        onSaved: (String value) {
          _formData['email'] = value;
        },
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(_passFocusNode);
        },
        icon: Icons.email,
        iconColor: colorCurve);
  }

  BoxField _passwordWidget() {
    return BoxField(
        controller: _passwordController,
        focusNode: _passFocusNode,
        hintText: "Enter Password",
        lableText: "Password",
        obscureText: true,
        icon: Icons.lock_outline,
        onSaved: (String value) {
          _formData['password'] = value;
        },
        iconColor: colorCurve);
  }

  Container _loginButtonWidget(LoginState state) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.getWidthPx(20), horizontal: size.getWidthPx(16)),
      width: size.getWidthPx(200),
      child: RaisedButton(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        padding: EdgeInsets.all(size.getWidthPx(12)),
        child: Text(
          "LOGIN",
          style: TextStyle(
              fontFamily: 'Exo2', color: Colors.white, fontSize: 20.0),
        ),
        color: colorCurve,
        onPressed: state is! LoginLoading ? _onLoginButtonPressed : null,
      ),
    );
  }

  loginFields(LoginState state) => Container(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _emailWidget(),
                SizedBox(height: size.getWidthPx(8)),
                _passwordWidget(),
                GestureDetector(
                    onTap: () {
                      //Navigate to Forgot Password Screen...
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageForgotPassword()));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: size.getWidthPx(24)),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("Forgot Password?",
                              style: TextStyle(
                                  fontFamily: 'Exo2', fontSize: 16.0))),
                    )),
                SizedBox(height: size.getWidthPx(8)),
                _loginButtonWidget(state),
              ],
            )),
      );

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    _loginBloc.add(LoginButtonPressed(
      username: _emailController.text,
      password: _passwordController.text,
    ));
  }
}
