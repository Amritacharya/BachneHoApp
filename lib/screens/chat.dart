import 'dart:async';

import 'package:Bechneho/model/account.dart';
import 'package:Bechneho/model/message_model.dart';
import 'package:Bechneho/user_repository.dart';
import 'package:Bechneho/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:Bechneho/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChatPageScreen extends StatefulWidget {
  final Account user;
  final Account reciever;
  final int chatDialogId;

  ChatPageScreen({this.user, this.reciever, this.chatDialogId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatPageScreen> {
  TextEditingController msgController = TextEditingController();
  String tok;
  http.Response response;
  List<Message> messages = [];
  Timer _timer;
  int chatId;
  static const oneSec = const Duration(seconds: 5);
  @override
  void initState() {
    SharedPreferences.getInstance().then((onValue) {
      setState(() {
        tok = onValue.getString('token');
      });
    });
    if (widget.chatDialogId == null) {
      setState(() {
        chatId = widget.reciever.chatDialog;
      });
    } else {
      setState(() {
        chatId = widget.chatDialogId;
      });
    }

    UserRepository().getMsg(chatId).then((onValue) {
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

  Future<Null> _updatemsg() {
    messages.clear();
    return UserRepository().getMsg(chatId).then((onValue) {
      onValue.forEach((f) {
        setState(() {
          messages.add(f);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyCircleAvatar(
              imgUrl: widget.reciever.profilepic,
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${widget.reciever.firstname} ${widget.reciever.lastname}",
                  style: Theme.of(context).textTheme.subhead,
                  overflow: TextOverflow.clip,
                ),
              ],
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (ctx, i) {
                      final Message message = messages[messages.length - i - 1];
                      if (widget.user.id != message.sender) {
                        return ReceivedMessagesWidget(
                          msg: message,
                          acc: widget.reciever,
                        );
                      } else {
                        return SentMessageWidget(msg: message);
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  height: 61,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35.0),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 5,
                                  color: Colors.grey)
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: msgController,
                                  decoration: InputDecoration(
                                      hintText: "Type Something...",
                                      border: InputBorder.none),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.photo_camera),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.attach_file),
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: colorCurve, shape: BoxShape.circle),
                        child: InkWell(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onTap: () async {
                            print(widget.reciever.id);
                            String msg = msgController.text;
                            setState(() {
                              messages.add(Message(
                                  text: msgController.text,
                                  sender: widget.user.id,
                                  time: "sending"));
                              msgController.clear();
                            });
                            await http.post(
                              'https://bechneho.com/api/chat/createmessage/',
                              body: {
                                'message': msg,
                                'receiver': widget.reciever.id.toString(),
                              },
                              headers: {
                                'Authorization': 'Token $tok',
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
