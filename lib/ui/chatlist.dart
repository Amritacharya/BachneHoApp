import 'package:Bechneho/account_bloc/account_model.dart';
import 'package:Bechneho/model/account.dart';
import 'package:Bechneho/ui/chat.dart';
import 'package:Bechneho/user_repository.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/custom_shape.dart';
import 'package:Bechneho/widgets/customappbar.dart';
import 'package:Bechneho/widgets/responsive_ui.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  final Account _accountModel;
  ChatListPage(this._accountModel);
  @override
  State<StatefulWidget> createState() {
    return _ChatListPage();
  }
}

class _ChatListPage extends State<ChatListPage> {
  @override
  initState() {
    super.initState();
  }

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  Widget _eventView(BuildContext context) {
    return FutureBuilder(
      future: UserRepository().fetchUsers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                dragStartBehavior: DragStartBehavior.down,
                padding: const EdgeInsets.only(left: 10.0),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: new ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              NetworkImage(snapshot.data[index].profilepic),
                        ),
                        title: new Text(
                          snapshot.data[index].firstname +
                              " " +
                              snapshot.data[index].lastname,
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                        reciever: snapshot.data[index],
                                        user: widget._accountModel,
                                      )));
                        }),
                  );
                },
              )
            : Center(child: RefreshProgressIndicator());
      },
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
          Opacity(opacity: 0.88, child: CustomAppBar(title: "Chat List")),
          clipShape(),
          Expanded(
              //height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(child: _eventView(context)))
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
