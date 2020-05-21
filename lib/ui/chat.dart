import 'dart:async';

import 'package:Bechneho/account_bloc/account_model.dart';
import 'package:Bechneho/model/account.dart';
import 'package:Bechneho/model/message_model.dart';
import 'package:Bechneho/src/user_repository.dart';
import 'package:Bechneho/ui/chatlist.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/custom_shape.dart';
import 'package:Bechneho/widgets/customappbar.dart';
import 'package:Bechneho/widgets/responsive_ui.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final Account user;
  final Account reciever;

  ChatScreen({this.user, this.reciever});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();
  String tok;
  http.Response response;
  List<Message> messages = [];

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  Timer _timer;
  static const oneSec = const Duration(seconds: 5);
  @override
  void initState() {
    SharedPreferences.getInstance().then((onValue) {
      setState(() {
        tok = onValue.getString('token');
      });
    });
    UserRepository().getMsg(widget.reciever.chatDialog).then((onValue) {
      onValue.forEach((f) {
        setState(() {
          print(f.text);
          messages.add(f);
        });
      });
    });

    _timer = Timer.periodic(oneSec, (Timer t) => _updatemsg());
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Future<Null> _updatemsg() {
    messages.clear();
    return UserRepository().getMsg(widget.reciever.chatDialog).then((onValue) {
      onValue.forEach((f) {
        setState(() {
          messages.add(f);
        });
      });
    });
  }

  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      margin: isMe == true
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0, right: 5)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, left: 5),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.60,
      decoration: BoxDecoration(
        gradient: isMe
            ? LinearGradient(
                colors: [colorCurve, colorCurve],
              )
            : LinearGradient(
                colors: [Color(0xFFFFEFEE), Color(0xFFFFEFEE)],
              ),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.text,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontFamily: "NotoEmoji",
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[msg],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: msgController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              print(widget.user.id);
              String msg = msgController.text;
              setState(() {
                messages.add(
                    Message(text: msgController.text, sender: widget.user.id));
                msgController.clear();
              });
              await http.post(
                'https://bechneho.com/api/chat/createmessage/',
                body: {
                  'message': msg,
                  'sender': widget.user.id.toString(),
                  'chatdialog_id': widget.reciever.chatDialog.toString()
                },
                headers: {
                  'Authorization': 'Token $tok',
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(children: <Widget>[
          Opacity(
              opacity: 0.88,
              child: CustomAppBar(
                  title:
                      "${widget.reciever.firstname} ${widget.reciever.lastname}")),
          clipShape(),
          Expanded(
              child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.only(top: 15.0),
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Message message =
                            messages[messages.length - index - 1];
                        final bool isMe = widget.user.id == message.sender;
                        print(isMe);
                        return _buildMessage(message, isMe);
                      },
                    ),
                  ),
                ),
                _buildMessageComposer(),
              ],
            ),
          )),
        ]));
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
      ],
    );
  }
}
