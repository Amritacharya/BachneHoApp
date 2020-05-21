import 'package:Bechneho/src/product_repository.dart';
import 'package:Bechneho/ui/product_detail.dart';
import 'package:flutter/material.dart';
import '../model/product.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PhotosList extends StatefulWidget {
  final List<Product> allList;

  const PhotosList({Key key, this.allList}) : super(key: key);
  @override
  _PhotosListState createState() => _PhotosListState();
}

class _PhotosListState extends State<PhotosList> {
  bool isLoading = true;
  bool internetCheck = true;
  Screen size;
  List<Product> items = [];
  @override
  void initState() {
    setState(() {
      items = widget.allList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return staggeredBody();
  }

  Padding staggeredBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(8)),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) => index.isEven
            ? propertyCard(items[index], 130)
            : propertyCard(items[index], 100),
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(1, index.isEven ? 1.5 : 1.2),
        mainAxisSpacing: size.getWidthPx(4),
        crossAxisSpacing: size.getWidthPx(4),
      ),
    );
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
              height: size.getWidthPx(160),
              width: size.getWidthPx(150),
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
