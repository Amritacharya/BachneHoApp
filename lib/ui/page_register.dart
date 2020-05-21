import 'dart:convert';
import 'dart:io';

import 'package:Bechneho/authentication/authentication.dart';
import 'package:Bechneho/login_bloc/login.dart';
import 'package:Bechneho/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:Bechneho/widgets/custom_shape.dart';
import 'package:Bechneho/widgets/customappbar.dart';
import 'package:Bechneho/widgets/responsive_ui.dart';
import 'package:Bechneho/widgets/textformfield.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'profile',
  ],
);

class RegisterPage extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;
  RegisterPage({
    Key key,
    @required this.loginBloc,
    @required this.authenticationBloc,
  }) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressline1Controller = TextEditingController();
  TextEditingController _profileController = TextEditingController();

  FacebookLogin facebookSignIn = new FacebookLogin();
  bool fbStatus = false;
  bool emailStatus = true;

  File images;
  LoginBloc get _loginBloc => widget.loginBloc;
  String _error;
  Future<void> loadAssets() async {
    setState(() {
      images = null;
    });

    File resultList;
    String error;

    try {
      resultList = await ImagePicker.pickImage(source: ImageSource.gallery);
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  Future<Null> signInWithGoogle() async {
    await GoogleSignIn().signOut();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    print(_profileController.text);
    setState(() {
      _emailController.text = user.email;
      _profileController.text = user.photoUrl;
    });
    setState(() {
      fbStatus = false;
      emailStatus = false;
    });
    if (user.displayName.contains(" ")) {
      _firstnameController.text =
          user.displayName.substring(0, user.displayName.indexOf(" "));
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
  }

  Future<Null> _login() async {
    facebookSignIn.logOut();
    facebookSignIn.loginBehavior = FacebookLoginBehavior.webOnly;
    final result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        setState(() {
          fbStatus = true;
          emailStatus = false;
        });
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=$token');
        final profile = jsonDecode(graphResponse.body);
        setState(() {
          _firstnameController.text = profile['first_name'];
          _lastnameController.text = profile['last_name'];
          _emailController.text = profile['email'];
          _profileController.text = profile['picture']['data']['url'];
        });

        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  void _showMessage(String message) {
    _onWidgetDidBuild(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _loginBloc.add(ErrorButton());
                },
              )
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return BlocBuilder<LoginBloc, LoginState>(
        bloc: _loginBloc,
        builder: (
          BuildContext context,
          LoginState state,
        ) {
          if (state is SignUpFailure) {
            _onWidgetDidBuild(() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('An Error Occurred!'),
                    content: Text("${state.error}"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _loginBloc.add(ErrorButton());
                        },
                      )
                    ],
                  );
                },
              );
            });
          }
          return Material(
            child: Scaffold(
              body: Container(
                height: _height,
                width: _width,
                margin: EdgeInsets.only(bottom: 5),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Opacity(opacity: 0.88, child: CustomAppBar()),
                      clipShape(),
                      form(),
                      acceptTermsTextRow(),
                      SizedBox(
                        height: _height / 35,
                      ),
                      button(state),
                      infoTextRow(),
                      socialIconsRow(),
                      //signInTextRow(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], colorCurve],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], colorCurve],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height / 5.5,
          width: _height / 5.5,
          margin: EdgeInsets.only(left: (_width / 2) - ((_height / 5.5) / 2)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.0,
                  color: Colors.black26,
                  offset: Offset(1.0, 10.0),
                  blurRadius: 20.0),
            ],
            color: _profileController.text.isNotEmpty || images != null
                ? Colors.transparent
                : backgroundColor,
            image: _profileController.text.isNotEmpty || images != null
                ? images == null
                    ? DecorationImage(
                        image: NetworkImage(
                          _profileController.text,
                        ),
                        fit: BoxFit.contain,
                      )
                    : DecorationImage(
                        image: FileImage(
                          images,
                        ),
                        fit: BoxFit.cover,
                      )
                : DecorationImage(
                    image: AssetImage(
                      "assets/logo_splash.png",
                    ),
                    fit: BoxFit.contain,
                  ),
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
              onTap: () {
                loadAssets();
              },
              child: Icon(
                Icons.add_a_photo,
                size: _large ? 40 : (_medium ? 33 : 31),
                color: backgroundColor,
              )),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      textEditingController: _firstnameController,
      keyboardType: TextInputType.text,
      icon: Icons.person,
      obscureText: false,
      hint: "First Name",
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      textEditingController: _lastnameController,
      keyboardType: TextInputType.text,
      icon: Icons.person,
      obscureText: false,
      hint: "Last Name",
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      textEditingController: _emailController,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      obscureText: false,
      hint: "Email ID",
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      textEditingController: _mobileController,
      keyboardType: TextInputType.number,
      icon: Icons.phone,
      obscureText: false,
      hint: "Mobile Number",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      textEditingController: _passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.orange[200],
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button(LoginState state) {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: state is! SignUpLoading && checkBoxValue == true
          ? _onSignUpButtonPressed
          : null,
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 3 : (_medium ? _width / 3 : _width / 2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200], Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'SIGN UP',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget socialIconsRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 80.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/icons/googlelogo.png"),
            ),
            onTap: signInWithGoogle,
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            child: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/icons/fblogo.jpg"),
            ),
            onTap: _login,
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onSignUpButtonPressed() async {
    print(fbStatus);
    if (images == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Error Occured"),
                content: Text("Please upload a profile picture."),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop,
                      child: Text("Okay"))
                ]);
          });
    }
    if (fbStatus == true || emailStatus == true) {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    }
    String uuid;

    await FirebaseAuth.instance.currentUser().then((FirebaseUser users) async {
      uuid = users.uid;
      print(uuid);
    });

    _loginBloc.add(SignUpButtonPressed(
        firstName: _firstnameController.text,
        lastName: _lastnameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        fuuid: uuid,
        mobilephone: "+977" + _mobileController.text,
        profile: images,
        fbUserProfile: _profileController.text));
    //  });
  }
}
