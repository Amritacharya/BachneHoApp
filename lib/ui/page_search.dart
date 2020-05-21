import 'dart:async';

import 'package:Bechneho/account_bloc/index.dart';
import 'package:Bechneho/model/category.dart';
import 'package:Bechneho/model/product.dart';
import 'package:Bechneho/src/product_repository.dart';
import 'package:Bechneho/ui/photo_list.dart';
import 'package:Bechneho/ui/product_detail.dart';
import 'package:Bechneho/ui/subcategori_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/widgets.dart';

import '../user_repository.dart';

class SearchPage extends StatefulWidget {
  final List<Product> premium, featured, recent;
  final List<Category> category;

  const SearchPage(
      {Key key, this.premium, this.featured, this.recent, this.category})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Screen size;
  int _selectedIndex = 0;

  List<Product> featuredList = List();

  List<Product> recentList = List();
  List<Category> categories = List();

  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<Category>();
  var items = List<Category>();
  Timer _timer;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  void filterSearchResults(String query) {
    List<Category> dummySearchList = List<Category>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<Category> dummyListData = List<Category>();
      dummySearchList.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  void initState() {
    widget.featured.forEach((f) {
      this.setState(() {
        featuredList.add(f);
      });
    });

    widget.category.forEach((f) {
      this.setState(() {
        categories.add(f);
        duplicateItems.add(f);
        items.add(f);
      });
    });

    _timer = Timer.periodic(Duration(seconds: 15), (_) => loadDetails());
    super.initState();
  }

  loadDetails() async {
    await ProductRepository().getFeatured().then((onValue) {
      featuredList.clear();
      onValue.forEach((f) {
        setState(() {
          featuredList.add(f);
        });
      });
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);

    ProductRepository().getFeatured().then((onValue) {
      featuredList.clear();
      onValue.forEach((f) {
        setState(() {
          featuredList.add(f);
        });
      });
    });
    ProductRepository().getCategories().then((onValue) {
      categories.clear();
      duplicateItems.clear();
      items.clear();
      onValue.forEach((f) {
        setState(() {
          categories.add(f);
          duplicateItems.add(f);
          items.add(f);
        });
      });
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    return Scaffold(
        backgroundColor: backgroundColor,
        body: RefreshIndicator(
          child: AnnotatedRegion(
            value: SystemUiOverlayStyle(
                statusBarColor: backgroundColor,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: backgroundColor),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[upperPart()],
                ),
              ),
            ),
          ),
          onRefresh: refreshList,
        ));
  }

  Widget upperPart() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: UpperClipper(),
          child: Container(
            height: size.getWidthPx(240),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorCurve, colorCurveSecondary],
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: size.getWidthPx(36)),
              child: Column(
                children: <Widget>[
                  titleWidget(),
                  SizedBox(height: size.getWidthPx(10)),
                  upperBoxCard(),
                ],
              ),
            ),

            leftAlignText(
                text: "Featured products",
                leftPadding: size.getWidthPx(16),
                textColor: textPrimaryColor,
                fontSize: 16.0),
            PhotosList(allList: featuredList),
            // HorizontalList(
            //   children: <Widget>[
            //     for (int i = 0; i < featuredList.length; i++)
            //       productCard(featuredList[i])
            //   ],
            // ),
          ],
        ),
      ],
    );
  }

  Text titleWidget() {
    return Text("Dream It\nBuy It",
        style: TextStyle(
            fontFamily: 'Exo2',
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: Colors.white));
  }

  Card upperBoxCard() {
    return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(
            horizontal: size.getWidthPx(20), vertical: size.getWidthPx(16)),
        borderOnForeground: true,
        child: Container(
          height: size.getWidthPx(155),
          child: Column(
            children: <Widget>[
              _searchWidget(),
              leftAlignText(
                  text: "Categories :",
                  leftPadding: size.getWidthPx(16),
                  textColor: textPrimaryColor,
                  fontSize: 16.0),
              HorizontalList(
                children: <Widget>[
                  for (int i = 0; i < items.length; i++)
                    buildChoiceChip(i, items[i].name, items[i].slug)
                ],
              ),
            ],
          ),
        ));
  }

  BoxField _searchWidget() {
    return BoxField(
        focusNode: FocusNode(),
        hintText: "Select by category name",
        lableText: "Search...",
        obscureText: false,
        onChanged: (value) {
          filterSearchResults(value);
        },
        controller: editingController,
        icon: Icons.search,
        iconColor: colorCurve);
  }

  Padding leftAlignText({text, leftPadding, textColor, fontSize, fontWeight}) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text ?? "",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Exo2',
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w500,
                color: textColor)),
      ),
    );
  }

  InkWell productCard(Product prod) {
    return InkWell(
      child: Card(
          elevation: 4.0,
          margin: EdgeInsets.all(8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          borderOnForeground: true,
          child: Container(
              height: size.getWidthPx(180),
              width: size.getWidthPx(170),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)),
                      child: prod.image1.length < 5
                          ? Image.asset('assets/feature_1.jpg')
                          : Image.network('${prod.image1}',
                              width: size.getWidthPx(170),
                              height: size.getWidthPx(100),
                              fit: BoxFit.contain)),
                  SizedBox(height: size.getWidthPx(8)),
                  Expanded(
                      child: leftAlignText(
                          text: prod.ad_title,
                          leftPadding: size.getWidthPx(8),
                          textColor: colorCurve,
                          fontSize: 14.0)),
                  leftAlignText(
                      text: prod.views + " Views",
                      leftPadding: size.getWidthPx(8),
                      textColor: Colors.black54,
                      fontSize: 12.0),
                  SizedBox(height: size.getWidthPx(4)),
                  leftAlignText(
                      text: prod.ads_validity,
                      leftPadding: size.getWidthPx(8),
                      textColor: Colors.black54,
                      fontSize: 12.0),
                  SizedBox(height: size.getWidthPx(4)),
                  leftAlignText(
                      text: "Rs. " + prod.price,
                      leftPadding: size.getWidthPx(8),
                      textColor: colorCurve,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800),
                ],
              ))),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProductDetailPage(prod))),
    );
  }

  Padding buildChoiceChip(index, chipName, chipSlug) {
    return Padding(
      padding: EdgeInsets.only(left: size.getWidthPx(8)),
      child: ChoiceChip(
        backgroundColor: backgroundColor,
        selectedColor: colorCurve,
        labelStyle: TextStyle(
            fontFamily: 'Exo2',
            color:
                (_selectedIndex == index) ? backgroundColor : textPrimaryColor),
        elevation: 4.0,
        padding: EdgeInsets.symmetric(
            vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
        selected: (_selectedIndex == index) ? true : false,
        label: Text(chipName),
        onSelected: (selected) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SubCategoryPage(chipSlug)));
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }
}
