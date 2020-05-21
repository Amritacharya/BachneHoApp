import 'package:Bechneho/model/category.dart';
import 'package:Bechneho/src/product_repository.dart';
import 'package:Bechneho/ui/advertisement/second.dart';
import 'package:Bechneho/ui/subcategori_page.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoryForm extends StatefulWidget {
  final ValueChanged<int> changeCurrentTab;
  final ValueChanged<String> saveSubCategory;
  CategoryForm({this.changeCurrentTab, this.saveSubCategory});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CategoryForm();
  }
}

class _CategoryForm extends State<CategoryForm> {
  String _selectedCategory;
  int _selectedIndex = 0;
  String _selectedSubCategory;
  TextEditingController editingController;
  Screen size;
  List<Category> categories = List();
  List<Category> subCategories = List();
  final duplicateItems = List<Category>();
  var items = List<Category>();
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
    ProductRepository().getCategories().then((value) {
      value.forEach((f) {
        setState(() {
          categories.add(f);
          duplicateItems.add(f);
          items.add(f);
        });
      });

      print(categories);
      ProductRepository()
          .getSubCategories(items[0].slug)
          .then((value) => value.forEach((element) {
                setState(() {
                  subCategories.add(element);
                });
              }));
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
            child: Column(
              children: <Widget>[upperPart()],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _selectedSubCategory == null
              ? showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text("Error Occured"),
                        content: Text(
                            "Please select a valid sub-category to proceed."),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Okay"))
                        ]);
                  })
              : setState(() {
                  widget.changeCurrentTab(1);
                  widget.saveSubCategory(_selectedSubCategory);
                });
        },
        label: Text('Next'),
        icon: Icon(Icons.navigate_next),
        backgroundColor: Colors.red,
      ),
    );
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
                  SizedBox(height: size.getWidthPx(10)),
                  leftAlignText(
                      text: "Sub Categories :",
                      leftPadding: size.getWidthPx(16),
                      textColor: textPrimaryColor,
                      fontSize: 16.0),
                  Container(
                    height: 300,
                    child: Card(
                        elevation: 5,
                        margin: EdgeInsets.all(20),
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: subCategories.length,
                          itemBuilder: (BuildContext context, int index) =>
                              buildSubChip(index, subCategories[index].name,
                                  subCategories[index].slug),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(1, .25),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Text titleWidget() {
    return Text("Add a advertisement",
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
          setState(() {
            _selectedIndex = index;
            _selectedCategory = chipSlug;
          });
          ProductRepository().getSubCategories(chipSlug).then((value) {
            subCategories.clear();
            value.forEach((element) {
              setState(() {
                subCategories.add(element);
              });
            });
          });
        },
      ),
    );
  }

  Padding buildSubChip(index, chipName, chipSlug) {
    return Padding(
      padding: EdgeInsets.only(left: size.getWidthPx(8)),
      child: ChoiceChip(
        backgroundColor: backgroundColor,
        selectedColor: colorCurve,
        labelStyle: TextStyle(
            fontFamily: 'Exo2',
            color: (_selectedSubCategory == chipSlug)
                ? backgroundColor
                : textPrimaryColor),
        elevation: 4.0,
        padding: EdgeInsets.symmetric(
            vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
        selected: (_selectedSubCategory == chipName) ? true : false,
        label: Text(chipName),
        onSelected: (selected) => setState(() {
          _selectedSubCategory = chipName;
        }),
      ),
    );
  }
}
