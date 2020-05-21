import 'dart:async';
import 'dart:convert';

import 'package:Bechneho/account_bloc/index.dart';
import 'package:Bechneho/home/index.dart';
import 'package:Bechneho/model/account.dart';
import 'package:Bechneho/model/category.dart';
import 'package:Bechneho/model/product.dart';
import 'package:Bechneho/screens/screens.dart';
import 'package:Bechneho/src/product_repository.dart';
import 'package:Bechneho/src/user_repository.dart';
import 'package:Bechneho/ui/search_bloc_page.dart';
import 'package:flutter/material.dart';
import 'package:Bechneho/widgets/bottom_navigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'search_page.dart';
import 'page_profile.dart';
import 'page_settings.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentTab = 0;
  PageController pageController;
  Profile account;
  AccountBlocBloc accountBlocBloc;
  HomeBloc homeBloc;
  List<Product> premiumList = List();
  List<Product> featuredList = List();
  List<Product> allList = List();

  List<Category> categories = List();
  _changeCurrentTab(int tab) {
    setState(() {
      currentTab = tab;
      pageController.jumpToPage(0);
    });
  }

  @override
  void initState() {
    accountBlocBloc = AccountBlocBloc(accountRepository: UserRepository());
    homeBloc = HomeBloc();
    homeBloc.add(LoadHomeBlocEvent());
    accountBlocBloc.add(LoadAccountBlocEvent());

    ProductRepository().getAll().then((onValue) {
      onValue.forEach((f) {
        this.setState(() {
          allList.add(f);
        });
      });
    });
    super.initState();
    pageController = new PageController();
    registerNotification();
    configLocalNotification();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      _navigateToItemDetail(message);
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      _navigateToItemDetail(message);
      return;
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'com.bechne.bechneho',
      'Bechneho',
      'Dream it By it',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'].toString(),
        message['notification']['body'].toString(),
        platformChannelSpecifics,
        payload: json.encode(message));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MultiBlocProvider(
            child: Scaffold(
                body: bodyView(currentTab),
                bottomNavigationBar:
                    BottomNavBar(changeCurrentTab: _changeCurrentTab)),
            providers: [
              BlocProvider<AccountBlocBloc>(
                create: (BuildContext context) => accountBlocBloc,
              ),
              BlocProvider<HomeBloc>(
                create: (BuildContext context) => homeBloc,
              )
            ]));
  }

  bodyView(currentTab) {
    List<Widget> tabView = [];

    switch (currentTab) {
      case 0:
        tabView = [PageHome()];
        break;
      case 1:
        //Search Page
        tabView = [
          PageSearch(
            all: allList,
          )
        ];
        break;
      case 2:
        //Profile Page
        tabView = [ProfilePage()];
        break;
      case 3:
        //Setting Page
        tabView = [SettingPage()];
        break;
    }
    return PageView(controller: pageController, children: tabView);
  }

  //PRIVATE METHOD TO HANDLE NAVIGATION TO SPECIFIC PAGE
  void _navigateToItemDetail(Map<String, dynamic> message) async {
    final MessageBean item = _itemForMessage(message);

    final Account acc = await UserRepository().getAccount();
    if (item.itemId.contains('msg')) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatHomeScreen(
                acc,
              )));
    }
  }
}

final Map<String, MessageBean> _items = <String, MessageBean>{};
MessageBean _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['type'];

  final MessageBean item =
      _items.putIfAbsent(itemId, () => MessageBean(itemId: itemId));

  return item;
}

//Model class to represent the message return by FCM
class MessageBean {
  MessageBean({this.itemId});
  final String itemId;

  StreamController<MessageBean> _controller =
      StreamController<MessageBean>.broadcast();
  Stream<MessageBean> get onChanged => _controller.stream;
}
