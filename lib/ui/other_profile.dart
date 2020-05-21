import 'package:Bechneho/model/account.dart';
import 'package:Bechneho/model/product.dart';
import 'package:Bechneho/src/product_repository.dart';
import 'package:Bechneho/screens/chat.dart';
import 'package:Bechneho/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bechneho/ui/photo_list.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/utils_widget.dart';
import 'package:Bechneho/widgets/widgets.dart';

class OtherPage extends StatefulWidget {
  final Account account;
  OtherPage(this.account);
  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  Screen size;
  Account acc;
  Account myAcc;
  List<Product> items = [];
  @override
  void initState() {
    UserRepository().getAccount().then((onValue) {
      setState(() {
        myAcc = onValue;
      });
    });
    setState(() {
      acc = widget.account;
    });
    ProductRepository().getOtherAds(acc.id).then((onValue) {
      onValue.forEach((f) {
        setState(() {
          items.add(f);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: backgroundColor,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: backgroundColor),
        child: Container(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: <Widget>[upperPart(acc, items)],
            ),
          ),
        ),
      ),
    );
  }

  Widget upperPart(Account account, List<Product> items) {
    return Stack(children: <Widget>[
      ClipPath(
        clipper: UpperClipper(),
        child: Container(
          height: size.getWidthPx(150),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorCurve, colorCurve],
            ),
          ),
        ),
      ),
      Column(
        children: <Widget>[
          profileWidget(acc),
          Center(
            child: nameWidget(acc),
          ),
          SizedBox(height: size.getWidthPx(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              followersWidget(items),
              SizedBox(width: size.getWidthPx(4)),
              likeWidget(acc),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: size.getWidthPx(8),
                left: size.getWidthPx(20),
                right: size.getWidthPx(20)),
            child: Container(height: size.getWidthPx(4), color: colorCurve),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buttonWidget("Chat"),
            ],
          ),
          leftAlignText(
              text: "Advertisements",
              leftPadding: size.getWidthPx(16),
              textColor: textPrimaryColor,
              fontSize: 14.0),
          PhotosList(
            allList: items,
          )
        ],
      )
    ]);
  }

  GestureDetector followerAvatarWidget(String assetIcon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        maxRadius: size.getWidthPx(24),
        backgroundColor: Colors.transparent,
        child: Image.asset(assetIcon),
      ),
    );
  }

  Container buttonWidget(text) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
      child: RaisedButton(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(22.0)),
        padding: EdgeInsets.all(size.getWidthPx(2)),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: 'Exo2', color: Colors.white, fontSize: 14.0),
        ),
        color: colorCurve,
        onPressed: () async {
          if (myAcc.id == acc.id) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Sorry!'),
                  content: Text(
                      "You are the owner of this advertisement. Yo cannot chat yourself."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
          } else {
            int id = await UserRepository().checkDialog(acc.id);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPageScreen(
                          reciever: acc,
                          user: myAcc,
                          chatDialogId: id,
                        )));
          }
        },
      ),
    );
  }

  Align profileWidget(Account account) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: size.getWidthPx(60)),
        child: CircleAvatar(
          foregroundColor: backgroundColor,
          maxRadius: size.getWidthPx(50),
          backgroundColor: Colors.white,
          child: CircleAvatar(
            maxRadius: size.getWidthPx(48),
            foregroundColor: colorCurve,
            backgroundImage: account.profilepic == null
                ? AssetImage("assets/logo_splash.png")
                : NetworkImage('${account.profilepic}'),
          ),
        ),
      ),
    );
  }

  Column nameWidget(Account account) {
    return Column(
      children: <Widget>[
        Text("${account.firstname} ${account.lastname}",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 16.0,
                color: colorCurve,
                fontWeight: FontWeight.w700)),
      ],
    );
  }

  Column followersWidget(List<Product> items) {
    return Column(
      children: <Widget>[
        Text("${items.length}",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 16.0,
                color: textSecondary54,
                fontWeight: FontWeight.w700)),
        SizedBox(height: size.getWidthPx(4)),
        Text("Advertisements",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 14.0,
                color: textSecondary54,
                fontWeight: FontWeight.w500))
      ],
    );
  }

  Column likeWidget(Account account) {
    return Column(
      children: <Widget>[
        account.phone == true
            ? Text("${account.mobileNo}",
                style: TextStyle(
                    fontFamily: "Exo2",
                    fontSize: 16.0,
                    color: textSecondary54,
                    fontWeight: FontWeight.w700))
            : Text("**********",
                style: TextStyle(
                    fontFamily: "Exo2",
                    fontSize: 16.0,
                    color: textSecondary54,
                    fontWeight: FontWeight.w700)),
        SizedBox(height: size.getWidthPx(4)),
        Text("${account.addressLine1}",
            style: TextStyle(
                fontFamily: "Exo2",
                fontSize: 14.0,
                color: textSecondary54,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
