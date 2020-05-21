import 'dart:async';

import 'package:Bechneho/account_bloc/account_bloc_bloc.dart';
import 'package:Bechneho/account_bloc/index.dart';
import 'package:Bechneho/advertisement/advertisement_page.dart';
import 'package:Bechneho/model/account.dart';
import 'package:Bechneho/model/product.dart';
import 'package:Bechneho/screens/screens.dart';
import 'package:Bechneho/src/product_repository.dart';
import 'package:Bechneho/ui/advertisement/advertisement.dart';
import 'package:Bechneho/ui/advertisement/first.dart';
import 'package:Bechneho/ui/chatlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bechneho/ui/photo_list.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/utils_widget.dart';
import 'package:Bechneho/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Screen size;
  List<Product> advertisements;
  Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 15), (_) => loadDetails());
    super.initState();
  }

  loadDetails() async {
    await ProductRepository().getAds().then((onValue) {
      advertisements.clear();
      onValue.forEach((f) {
        setState(() {
          advertisements.add(f);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return BlocBuilder<AccountBlocBloc, AccountBlocState>(
        bloc: BlocProvider.of<AccountBlocBloc>(context),
        builder: (
          BuildContext context,
          currentState,
        ) {
          if (currentState is LoadAccountBlocState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is LoadingAccountBlocState) {
            return Center(
              child: RefreshProgressIndicator(),
            );
          }
          if (currentState is ErrorAccountBlocState) {
            return new Container(
                child: new Center(
              child: new Text(currentState.errorMessage ?? 'Error'),
            ));
          }
          if (currentState is InAccountBlocState) {
            final account = currentState.accountModel;
            final items = currentState.myads;

            advertisements = items;

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
                      children: <Widget>[upperPart(account, advertisements)],
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
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
          profileWidget(account),
          Center(
            child: nameWidget(account),
          ),
          SizedBox(height: size.getWidthPx(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              followersWidget(items),
              SizedBox(width: size.getWidthPx(4)),
              likeWidget(account),
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
              buttonWidget(account, "  Add Advertisement  ", 1),
              buttonWidget(account, "Chat", 2),
            ],
          ),
          leftAlignText(
              text: "My advertisements",
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

  Container buttonWidget(Account account, text, int no) {
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
        onPressed: () {
          switch (no) {
            case 1:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdvertisementHomePage()));
              break;
            case 2:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatHomeScreen(account)));
              break;
            default:
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
        Text("${account.mobileNo}",
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
