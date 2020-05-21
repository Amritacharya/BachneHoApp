import 'package:Bechneho/model/category.dart';
import 'package:Bechneho/model/product.dart';
import 'package:Bechneho/src/product_repository.dart';
import 'package:Bechneho/ui/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SubCategoryDetailPage extends StatefulWidget {
  final Category category;
  SubCategoryDetailPage(this.category);
  @override
  _SubCategoryDetailPageState createState() => _SubCategoryDetailPageState();
}

class _SubCategoryDetailPageState extends State<SubCategoryDetailPage> {
  Screen size;
  int _selectedIndex = 1;

  List<Product> featuredList = List();

  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<Product>();
  var items = List<Product>();

  @override
  void initState() {
    ProductRepository()
        .getSubCategoriesLists(widget.category.slug)
        .then((onValue) {
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
    List<Product> dummySearchList = List<Product>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      print(query);
      List<Product> dummyListData = List<Product>();
      dummySearchList.forEach((item) {
        if (item.ad_title.toLowerCase().contains(query.toLowerCase())) {
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
                text: "All products",
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
                  StaggeredTile.count(1, index.isEven ? 1.4 : 1.2),
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
          height: size.getWidthPx(60),
          child: Column(
            children: <Widget>[
              _searchWidget(),
            ],
          ),
        ));
  }

  TextField _searchWidget() {
    return TextField(
      onChanged: (value) {
        filterSearchResults(value);
      },
      controller: editingController,
      decoration: InputDecoration(
        labelText: "Search",
        hintText: "Select by product name",
        prefixIcon: Icon(
          Icons.search,
          color: colorCurve,
        ),
        focusColor: Colors.white,
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(25.0))),
      ),
    );
    //  BoxField(
    //     hintText: "Select by product name",
    //     lableText: "Search...",
    //     obscureText: false,
    //     onChanged: (value) {
    //       print("object");
    //       filterSearchResults(value);
    //     },
    //     controller: editingController,
    //     icon: Icons.search,
    //     iconColor: colorCurve);
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

  InkWell propertyCard(Product property, int heightsize) {
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
                      child: property.image1.length < 5
                          ? Image.asset('assets/feature_1.jpg')
                          : Image.network('${property.image1}',
                              width: size.getWidthPx(170),
                              height: size.getWidthPx(heightsize),
                              fit: BoxFit.contain)),
                  SizedBox(height: size.getWidthPx(8)),
                  leftAlignText(
                      text: property.ad_title,
                      leftPadding: size.getWidthPx(8),
                      textColor: colorCurve,
                      fontSize: 14.0),
                  leftAlignText(
                      text: property.views + " Views",
                      leftPadding: size.getWidthPx(8),
                      textColor: Colors.black54,
                      fontSize: 12.0),
                  SizedBox(height: size.getWidthPx(4)),
                  leftAlignText(
                      text: property.ads_validity,
                      leftPadding: size.getWidthPx(8),
                      textColor: Colors.black54,
                      fontSize: 12.0),
                  SizedBox(height: size.getWidthPx(4)),
                  leftAlignText(
                      text: "Rs. " + property.price,
                      leftPadding: size.getWidthPx(8),
                      textColor: colorCurve,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800),
                ],
              ))),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProductDetailPage(property))),
    );
  }
}
