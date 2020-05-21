import 'dart:io';

import 'package:Bechneho/ui/advertisement/advertisement.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class SecondPage extends StatefulWidget {
  final ValueChanged<int> changeCurrentTab;
  final ValueChanged<Second> saveSecond;
  SecondPage({Key key, this.changeCurrentTab, this.saveSecond})
      : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with TickerProviderStateMixin {
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _adTitleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  FocusNode _adTitleFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();
  Future<void> loadAssets(int no) async {
    setState(() {
      switch (no) {
        case 1:
          image1 = null;
          break;
        case 2:
          image2 = null;
          break;
        case 3:
          image3 = null;
          break;
        case 4:
          image4 = null;
          break;
        case 5:
          image5 = null;
          break;
        case 6:
          image6 = null;
          break;
        case 7:
          image7 = null;
          break;
        case 8:
          image8 = null;
          break;
        case 9:
          image9 = null;
          break;
        case 10:
          image10 = null;
          break;
        default:
      }
    });

    File resultList;
    String error;

    try {
      resultList = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 70);
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      switch (no) {
        case 1:
          image1 = resultList;
          resultList = null;
          break;
        case 2:
          image2 = resultList;
          resultList = null;
          break;
        case 3:
          image3 = resultList;
          resultList = null;
          break;
        case 4:
          image4 = resultList;
          resultList = null;
          break;
        case 5:
          image5 = resultList;
          resultList = null;
          break;
        case 6:
          image6 = resultList;
          resultList = null;
          break;
        case 7:
          image7 = resultList;
          resultList = null;
          break;
        case 8:
          image8 = resultList;
          resultList = null;
          break;
        case 9:
          image9 = resultList;
          resultList = null;
          break;
        case 10:
          image10 = resultList;
          resultList = null;
          break;
        default:
      }

      if (error == null) var _error = 'No Error Dectected';
    });
  }

  Screen size;
  _imageWidget(File image, int no) {
    return Stack(
      children: <Widget>[
        image == null
            ? Image.asset("assets/logo_splash.png")
            : Image.file(image),
        Container(
          alignment: Alignment.topRight,
          child: _buttonImage(no),
        )
      ],
    );
  }

  Widget _profileWidget() {
    TabController imagesController = TabController(length: 10, vsync: this);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 250.0,
        child: Center(
          child: DefaultTabController(
            length: 10,
            child: Stack(
              children: <Widget>[
                TabBarView(
                  controller: imagesController,
                  children: <Widget>[
                    _imageWidget(image1, 1),
                    _imageWidget(image2, 2),
                    _imageWidget(image3, 3),
                    _imageWidget(image4, 4),
                    _imageWidget(image5, 5),
                    _imageWidget(image6, 6),
                    _imageWidget(image7, 7),
                    _imageWidget(image8, 8),
                    _imageWidget(image9, 9),
                    _imageWidget(image10, 10)
                  ],
                ),
                Container(
                  alignment: FractionalOffset(0.5, 0.95),
                  child: TabPageSelector(
                    controller: imagesController,
                    selectedColor: Colors.grey,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buttonImage(int no) {
    return RaisedButton(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      padding: EdgeInsets.all(size.getWidthPx(5)),
      child: Text(
        "Add image",
        style:
            TextStyle(fontFamily: 'Exo2', color: Colors.white, fontSize: 16.0),
      ),
      color: colorCurve,
      onPressed: () => loadAssets(no),
    );
  }

  BoxField _nameWidget() {
    return BoxField(
        controller: _adTitleController,
        focusNode: _adTitleFocusNode,
        hintText: "Enter Ad Title",
        lableText: "Ad Title",
        obscureText: false,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter a valid Ad Title';
          }
        },
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(_adTitleFocusNode);
        },
        icon: Icons.title,
        iconColor: colorCurve);
  }

  BoxField _descriptionWidget() {
    return BoxField(
        controller: _descriptionController,
        focusNode: _descriptionFocusNode,
        hintText: "Enter description",
        lableText: "description",
        maxLines: 3,
        containerHeight: 150,
        icon: Icons.description,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter a valid description';
          }
        },
        iconColor: colorCurve);
  }

  BoxField _priceWidget() {
    return BoxField(
        controller: _priceController,
        focusNode: _priceFocusNode,
        hintText: "Enter Price",
        lableText: "Price",
        keyboardType: TextInputType.number,
        obscureText: false,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter a valid price';
          }
        },
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(_priceFocusNode);
        },
        icon: Icons.monetization_on,
        iconColor: colorCurve);
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    return Scaffold(
      body: Stack(children: <Widget>[
        SingleChildScrollView(
          child: SafeArea(
            top: true,
            bottom: false,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: size.getWidthPx(20),
                  vertical: size.getWidthPx(20)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GradientText('Product Detail',
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(255, 0, 0, 1.0),
                              Color.fromRGBO(255, 99, 71, 1.0)
                            ]),
                            style: TextStyle(
                                fontFamily: 'Exo2',
                                fontSize: 26,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: size.getWidthPx(15)),
                    Container(
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _profileWidget(),
                              _nameWidget(),
                              _descriptionWidget(),
                              _priceWidget(),
                            ],
                          )),
                    ),
                    SizedBox(height: size.getWidthPx(15)),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton.extended(
                            onPressed: () {
                              if (image1 == null) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Text("Error Occured"),
                                          content: Text(
                                              "Upload a advertisement photo."),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Okay"))
                                          ]);
                                    });
                              }
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              Second second = new Second(
                                  img1: image1,
                                  img2: image2,
                                  img3: image3,
                                  img4: image4,
                                  img5: image5,
                                  img6: image6,
                                  img7: image7,
                                  img8: image8,
                                  img9: image9,
                                  img10: image10,
                                  name: _adTitleController.text,
                                  description: _descriptionController.text,
                                  price: _priceController.text);
                              setState(() {
                                widget.changeCurrentTab(2);
                                widget.saveSecond(second);
                              });
                            },
                            label: Text('Next'),
                            icon: Icon(Icons.navigate_next),
                            backgroundColor: Colors.green,
                          ),
                        ]),
                  ]),
            ),
          ),
        )
      ]),
    );
  }
}
