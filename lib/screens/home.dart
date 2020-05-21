import 'package:Bechneho/model/account.dart';
import 'package:Bechneho/screens/screens.dart';
import 'package:Bechneho/utils/colors.dart';
import 'package:flutter/material.dart';

import '../user_repository.dart';

class ChatHomeScreen extends StatelessWidget {
  final Account _accountModel;
  ChatHomeScreen(this._accountModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black45),
        iconTheme: IconThemeData(color: Colors.black45),
        title: Text("${_accountModel.firstname} ${_accountModel.lastname}"),
      ),
      body: FutureBuilder(
          future: UserRepository().fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (ctx, i) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            isThreeLine: true,
                            //   onLongPress: () {},
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPageScreen(
                                          reciever: snapshot.data[
                                              snapshot.data.length - i - 1],
                                          user: _accountModel,
                                        ))),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.3),
                                      offset: Offset(0, 5),
                                      blurRadius: 25)
                                ],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(snapshot
                                          .data[snapshot.data.length - i - 1]
                                          .profilepic),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              "${snapshot.data[snapshot.data.length - i - 1].firstname} ${snapshot.data[snapshot.data.length - i - 1].lastname}",
                              style: Theme.of(context).textTheme.title,
                            ),
                            subtitle: snapshot.data[i].lastMsg.length > 20
                                ? Text(
                                    "${snapshot.data[snapshot.data.length - i - 1].lastMsg.substring(0, 20)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle
                                        .apply(color: Colors.black87),
                                  )
                                : Text(
                                    "${snapshot.data[snapshot.data.length - i - 1].lastMsg}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle
                                        .apply(color: Colors.black87),
                                  ),
                            trailing: Container(
                              width: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.check,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    height: 25,
                                    width: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider()
                        ],
                      );
                    },
                  )
                : Center(child: RefreshProgressIndicator());
          }),
    );
  }
}
