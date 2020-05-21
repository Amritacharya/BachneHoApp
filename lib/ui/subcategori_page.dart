import 'package:Bechneho/model/category.dart';
import 'package:Bechneho/model/product.dart';
import 'package:Bechneho/src/product_repository.dart';
import 'package:Bechneho/ui/product_detail.dart';
import 'package:Bechneho/ui/subcategory_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SubCategoryPage extends StatefulWidget {
  final String slug;
  SubCategoryPage(this.slug);
  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  Screen size;
  int _selectedIndex;
  List<Category> featuredList = List();
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<Category>();
  List<Category> items = [];

  @override
  void initState() {
    ProductRepository().getSubCategories(widget.slug).then((onValue) {
      onValue.forEach((f) {
        this.setState(() {
          featuredList.add(f);
          duplicateItems.add(f);
        });
      });
    }).then((value) {
      this.setState(() {
        items.addAll(duplicateItems);
      });
    });

    super.initState();
  }

  void filterSearchResults(String query) {
    List<Category> dummySearchList = List<Category>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      print(query);
      List<Category> dummyListData = List<Category>();
      dummySearchList.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
        print(items);
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
            child: Column(
              children: <Widget>[upperPart()],
            ),
          ),
        ),
      ),
    );
  }

  Widget upperPart() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: UpperClipper(),
          child: Container(
            height: size.getWidthPx(200),
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
            SizedBox(height: size.getWidthPx(20)),
            leftAlignText(
                text: "All Categories",
                leftPadding: size.getWidthPx(16),
                textColor: textPrimaryColor,
                fontSize: 16.0),
            StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) => index.isEven
                  ? propertyCard(items[index], 130)
                  : propertyCard(items[index], 100),
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.count(1, index.isEven ? 1 : 0.8),
              mainAxisSpacing: size.getWidthPx(4),
              crossAxisSpacing: size.getWidthPx(4),
            ),
          ],
        ),
      ],
    );
  }

  Text titleWidget() {
    return Text("Search for what you want",
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
          height: size.getWidthPx(80),
          child: Column(
            children: <Widget>[
              _searchWidget(),
            ],
          ),
        ));
  }

  BoxField _searchWidget() {
    return BoxField(
        hintText: "Select by sub-category name",
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

  InkWell propertyCard(Category property, int heightsize) {
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
                      child: property.image == null
                          ? Image.asset('assets/feature_1.jpg')
                          : Image.network('${property.image}',
                              width: size.getWidthPx(170),
                              height: size.getWidthPx(heightsize),
                              fit: BoxFit.contain)),
                  SizedBox(height: size.getWidthPx(8)),
                  leftAlignText(
                      text: property.name,
                      leftPadding: size.getWidthPx(8),
                      textColor: colorCurve,
                      fontSize: 14.0),
                ],
              ))),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubCategoryDetailPage(property))),
    );
  }
}
