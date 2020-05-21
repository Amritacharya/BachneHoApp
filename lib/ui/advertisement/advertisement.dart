import 'dart:io';

import 'package:Bechneho/advertisement/advertisement_bloc.dart';
import 'package:Bechneho/model/product.dart';
import 'package:Bechneho/ui/advertisement/first.dart';
import 'package:Bechneho/ui/advertisement/fourth.dart';
import 'package:Bechneho/ui/advertisement/review.dart';
import 'package:Bechneho/ui/advertisement/second.dart';
import 'package:Bechneho/ui/advertisement/third.dart';
import 'package:Bechneho/ui/search_bloc_page.dart';
import 'package:flutter/material.dart';
import 'package:Bechneho/widgets/bottom_navigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvertisementHomePage extends StatefulWidget {
  @override
  _AdvertisementHomePageState createState() => _AdvertisementHomePageState();
}

class _AdvertisementHomePageState extends State<AdvertisementHomePage>
    with TickerProviderStateMixin {
  File image1;
  File image2;
  File image3;
  File image4;
  File image5;
  File image6;
  File image7;
  File image8;
  File image9;
  File image10;
  String subcategory;
  String ad_title;
  String description;
  String price;
  String negotiable;
  String condition;
  String used_for;
  String home_delivery;
  String zone;
  String district;
  String ad_validity;
  String delivery_areas;
  String delivery_charges;
  String warranty_type;
  String warranty_period;
  String warranty_includes;
  Advertisement advertisement;
  int currentTab = 0;
  PageController pageController;
  AdvertisementBloc _advertisementBloc = new AdvertisementBloc();
  _changeCurrentTab(int tab) {
    setState(() {
      currentTab = tab;
      pageController.jumpToPage(0);
    });
  }

  _saveSubCategory(String sub) {
    setState(() {
      subcategory = sub;
    });
  }

  _saveSecond(Second second) {
    setState(() {
      image1 = second.img1;
      image2 = second.img2;
      image3 = second.img3;
      image4 = second.img4;
      image5 = second.img5;
      image6 = second.img6;
      image7 = second.img7;
      image8 = second.img8;
      image9 = second.img9;
      image10 = second.img10;
      ad_title = second.name;
      description = second.description;
      price = second.price;
    });
  }

  _saveThird(Third third) {
    setState(() {
      negotiable = third.neg;
      condition = third.cond;
      used_for = third.use;
      home_delivery = third.delivery;
      zone = third.zon;
      district = third.dis;
      ad_validity = third.validity;
    });
  }

  _saveFourth(Fourth fourth) {
    setState(() {
      delivery_areas = fourth.areas;
      delivery_charges = fourth.charges;
      warranty_type = fourth.type;
      warranty_period = fourth.period;
      warranty_includes = fourth.includes;
      advertisement = Advertisement(
        image1: image1,
        image2: image2,
        image3: image3,
        image4: image4,
        image5: image5,
        image6: image6,
        image7: image7,
        image8: image8,
        image9: image9,
        image10: image10,
        subcategory: subcategory,
        ad_title: ad_title,
        description: description,
        price: price,
        negotiable: negotiable,
        condition: condition,
        used_for: used_for,
        home_delivery: home_delivery,
        zone: zone,
        district: district,
        ad_validity: ad_validity,
        delivery_areas: delivery_areas,
        delivery_charges: delivery_charges,
        warranty_type: warranty_type,
        warranty_period: warranty_period,
        warranty_includes: warranty_includes,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocProvider<AdvertisementBloc>(
          create: (BuildContext context) => _advertisementBloc,
          child: Scaffold(
            body: bodyView(currentTab),
          ),
        ));
  }

  bodyView(currentTab) {
    List<Widget> tabView = [];

    switch (currentTab) {
      case 0:
        tabView = [
          CategoryForm(
            changeCurrentTab: _changeCurrentTab,
            saveSubCategory: _saveSubCategory,
          )
        ];
        break;
      case 1:
        tabView = [
          SecondPage(
            changeCurrentTab: _changeCurrentTab,
            saveSecond: _saveSecond,
          )
        ];
        break;
      case 2:
        tabView = [
          ThirdPage(
            changeCurrentTab: _changeCurrentTab,
            saveThird: _saveThird,
          )
        ];
        break;
      case 3:
        tabView = [
          FourthPage(
              changeCurrentTab: _changeCurrentTab, saveFourth: _saveFourth)
        ];
        break;
      case 4:
        tabView = [
          AdvertisementReviewPage(
            product: advertisement,
            advertisementBloc: _advertisementBloc,
          )
        ];
    }
    return PageView(controller: pageController, children: tabView);
  }
}

class Second {
  final File img1;
  final File img2;
  final File img3;
  final File img4;
  final File img5;
  final File img6;
  final File img7;
  final File img8;
  final File img9;
  final File img10;
  final String name;
  final String description;
  final String price;
  Second(
      {this.img1,
      this.img2,
      this.img3,
      this.img4,
      this.img5,
      this.img6,
      this.img7,
      this.img8,
      this.img9,
      this.img10,
      this.name,
      this.description,
      this.price});
}

class Third {
  final String neg;
  final String cond;
  final String use;
  final String delivery;
  final String zon;
  final String dis;
  final String validity;
  Third(
      {this.neg,
      this.cond,
      this.use,
      this.delivery,
      this.zon,
      this.dis,
      this.validity});
}

class Fourth {
  final String areas;
  final String charges;
  final String type;
  final String period;
  final String includes;
  Fourth({this.areas, this.charges, this.type, this.period, this.includes});
}
