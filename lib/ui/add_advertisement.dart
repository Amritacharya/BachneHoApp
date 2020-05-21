import 'dart:convert';
import 'dart:io';

import 'package:Bechneho/account_bloc/account_bloc_bloc.dart';
import 'package:Bechneho/account_bloc/account_bloc_event.dart';
import 'package:Bechneho/advertisement/index.dart';
import 'package:Bechneho/login_bloc/login.dart';
import 'package:Bechneho/model/category.dart';
import 'package:Bechneho/model/product.dart';
import 'package:Bechneho/src/product_repository.dart';
import 'package:Bechneho/ui/page_profile.dart';
import 'package:flutter/material.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:intl/intl.dart';

class CreateAdPage extends StatefulWidget {
  final AdvertisementBloc advertisementBloc;
  final Product product;
  CreateAdPage({
    this.advertisementBloc,
    this.product,
  });
  @override
  _CreateAdPageState createState() => _CreateAdPageState();
}

class _CreateAdPageState extends State<CreateAdPage>
    with TickerProviderStateMixin {
  List<String> zones = [
    "bagmati",
    "bheri",
    "dhawalagiri",
    "gandaki",
    "janakpur",
    "karnali",
    "koshi",
    "lumbini",
    "mahakali",
    "mechi",
    "narayani",
    "rapti",
    "sagarmatha",
    "seti"
  ];
  List<List<String>> _warrantyTypes = ([
    ['Manufacuturer/Importer', 'm'],
    ['Seller/Shop', 's'],
    ['No Warranty', 'n']
  ]);
  List<List<String>> _homeDelivery = ([
    ['Within My Area', 'wa'],
    ['Within My City', 'wc'],
    ['All over Nepal', 'np']
  ]);

  List<List<String>> _condition = ([
    ['Brand New', 'bn'],
    ['Like New(Used few Times)', 'ln'],
    ['Excellent', 'e'],
    ['Good', 'g'],
    ['Not Working', 'nw']
  ]);
  String _selectedZone;
  var fileData;
  String _selectedDistrict;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<DropdownMenuItem<String>> _conditionMenuItems;
  List<DropdownMenuItem<String>> _areaMenuItems;
  List<DropdownMenuItem<String>> _zoneMenuItems;
  List<DropdownMenuItem<String>> _districtMenuItems;
  String _selectedString;
  String _selectedArea;
  String _selectedCondition;
  List<String> districts = [];
  AdvertisementBloc get _advertisementBloc => widget.advertisementBloc;
  int _selectedIndex = 1;
  @override
  void initState() {
    ProductRepository().getAllSubCategories().then((onValue) {
      onValue.forEach((f) {
        this.setState(() {
          categories.add(f);
          duplicateItems.add(f);
          items.add(f);
        });
      });
    });

    _zoneMenuItems = buildZoneItems(zones);
    _selectedZone = widget.product.zone;
    _districtMenuItems = buildDistrictItems();
    _selectedDistrict = widget.product.district;

    _dropdownMenuItems = buildDropdownMenuItems(_warrantyTypes);
    _conditionMenuItems = buildConditionMenuItems(_condition);
    _areaMenuItems = buildAreaMenuItems(_homeDelivery);
    _selectedCondition = widget.product.condition;
    _selectedArea = widget.product.delivery_areas;
    _selectedString = widget.product.warranty_type;

    super.initState();
  }

  Future<String> _loadDistrictAsset() async {
    return await rootBundle.loadString('assets/data.json');
  }

  Future loadDistrict() async {
    String jsonProduct = await _loadDistrictAsset();
    final jsonResponse = json.decode(jsonProduct);
    return jsonResponse;
  }

  void getDistricts(String zone) {
    districts.clear();
    print(fileData);
    fileData.forEach((data) {
      if (data.containsKey(zone)) {
        data["$zone"].forEach((f) {
          print(f);
          setState(() {
            districts.add(f);
          });
        });
      }
      ;
    });
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(
      List<List<String>> warrantyTpes) {
    List<DropdownMenuItem<String>> items = List();
    for (List<String> warranty in warrantyTpes) {
      items.add(
        DropdownMenuItem(
          value: warranty[0],
          child: Text(warranty[0]),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildZoneItems(List<String> zones) {
    List<DropdownMenuItem<String>> items = List();
    for (String zone in zones) {
      items.add(
        DropdownMenuItem(
          value: zone,
          child: Text(zone),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildDistrictItems() {
    List<DropdownMenuItem<String>> items = List();

    for (String zone in districts) {
      items.add(
        DropdownMenuItem(
          value: zone,
          child: Text(zone),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildConditionMenuItems(
      List<List<String>> warrantyTpes) {
    List<DropdownMenuItem<String>> items = List();
    for (List<String> warranty in warrantyTpes) {
      items.add(
        DropdownMenuItem(
          value: warranty[0],
          child: Text(warranty[0]),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildAreaMenuItems(
      List<List<String>> warrantyTpes) {
    List<DropdownMenuItem<String>> items = List();
    for (List<String> warranty in warrantyTpes) {
      items.add(
        DropdownMenuItem(
          value: warranty[0],
          child: Text(warranty[0]),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(String selectedString) {
    setState(() {
      _selectedString = selectedString;
      _warrantyTypeController.text = selectedString;
    });
  }

  onChangeConditionItem(String selectedString) {
    setState(() {
      _selectedCondition = selectedString;
      _conditionController.text = selectedString;
    });
  }

  onChangeAreaItem(String selectedString) {
    setState(() {
      _selectedArea = selectedString;
      _deliveryAreasController.text = selectedString;
    });
  }

  onChangeZoneItem(String selectedString) {
    setState(() {
      _selectedZone = selectedString;
    });
    getDistricts(_selectedZone);
    _districtMenuItems = buildDistrictItems();

    _selectedDistrict = _districtMenuItems[0].value;
  }

  onChangeDistrictItem(String selectedString) {
    setState(() {
      _selectedDistrict = selectedString;
    });
  }

  TextEditingController _adTitleController = TextEditingController();
  TextEditingController _adValidityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _conditionController = TextEditingController();
  TextEditingController _usedForController = TextEditingController();
  TextEditingController _deliveryAreasController = TextEditingController();
  TextEditingController _deliveryChargeController = TextEditingController();
  TextEditingController _warrantyTypeController = TextEditingController();
  TextEditingController _warrantyPeriodController = TextEditingController();
  TextEditingController _warrantyIncludesController = TextEditingController();
  TextEditingController _subCategoryController = TextEditingController();

  String negotiable = "No";
  String homeDelivery = "Available";
  FocusNode _adTitleFocusNode = FocusNode();
  FocusNode _adValidityFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _usedForFocusNode = FocusNode();
  FocusNode _deliveryChargeFocusNode = FocusNode();
  FocusNode _warrantyPeriodFocusNode = FocusNode();
  FocusNode _warrantyIncludesFocusNode = FocusNode();

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
  String _error;
  List<Category> categories = List();

  TextEditingController editingController = TextEditingController();

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
                  text: "Tap to select category:",
                  leftPadding: size.getWidthPx(16),
                  textColor: textPrimaryColor,
                  fontSize: 16.0),
              HorizontalList(
                children: <Widget>[
                  for (int i = 0; i < items.length; i++)
                    buildChoiceChip(i, items[i].name)
                ],
              ),
            ],
          ),
        ));
  }

  BoxField _searchWidget() {
    return BoxField(
        focusNode: FocusNode(),
        hintText: "Select by Sub-Category",
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

  Padding buildChoiceChip(index, chipName) {
    return Padding(
      padding: EdgeInsets.only(left: size.getWidthPx(8)),
      child: ChoiceChip(
        backgroundColor:
            (_selectedIndex == index) ? colorCurve : backgroundColor,
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
            _subCategoryController.text = chipName;
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

      if (error == null) _error = 'No Error Dectected';
    });
  }

  Screen size;

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    Widget bodyWidget(AdvertisementState state) {
      return Stack(children: <Widget>[
        // ClipPath(
        //     clipper: BottomShapeClipper(),
        //     child: Container(
        //       color: colorCurve,
        //     )),
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
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: colorCurve,
                          ),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        SizedBox(width: size.getWidthPx(10)),
                        _signUpGradientText(),
                      ],
                    ),
                    SizedBox(height: size.getWidthPx(30)),
                    registerFields(state)
                  ]),
            ),
          ),
        )
      ]);
    }

    return BlocBuilder<AdvertisementBloc, AdvertisementState>(
        bloc: _advertisementBloc,
        builder: (
          BuildContext context,
          AdvertisementState state,
        ) {
          if (state is CreateFailure) {
            _onWidgetDidBuild(() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('An Error Occurred!'),
                    content: Text("${state.error}"),
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
            });
          }
          if (state is CreateAdFinished) {
            AccountBlocBloc().add(LoadAccountBlocEvent());
            return ProfilePage();
          }
          return Scaffold(
              backgroundColor: backgroundColor,
              resizeToAvoidBottomInset: true,
              body: bodyWidget(state));
        });
  }

  GradientText _signUpGradientText() {
    return GradientText('Create Advertisement',
        gradient: LinearGradient(colors: [
          Color.fromRGBO(255, 0, 0, 1.0),
          Color.fromRGBO(255, 99, 71, 1.0)
        ]),
        style: TextStyle(
            fontFamily: 'Exo2', fontSize: 26, fontWeight: FontWeight.bold));
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
        icon: Icons.add_alert,
        iconColor: colorCurve);
  }

  Widget _validityWidget() {
    return DateTimeField(
      format: DateFormat('yyyy-MM-dd'),
      decoration: InputDecoration(
        labelText: 'Advertisement Validity',
      ),
      onSaved: (dt) {
        setState(() {
          _adValidityController.text =
              "${dt.year.toString()}-${dt.month.toString()}-${dt.day.toString()}";
        });
      },
      validator: (DateTime value) {
        if (value.toString().isEmpty) {
          return 'Please enter a valid date';
        }
      },
      onShowPicker: (BuildContext context, DateTime currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
      },
    );
  }

  BoxField _descriptionWidget() {
    return BoxField(
        controller: _descriptionController,
        focusNode: _descriptionFocusNode,
        hintText: "Enter description",
        lableText: "description",
        maxLines: 3,
        icon: Icons.lock_outline,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter a valid description';
          }
        },
        iconColor: colorCurve);
  }

  BoxField _usedForWidget() {
    return BoxField(
        controller: _usedForController,
        focusNode: _usedForFocusNode,
        hintText: "Enter Used for",
        lableText: "Used For",
        icon: Icons.timer,
        validator: (String value) {
          if (value.isEmpty) {
            return 'description didn\'t match';
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
            return 'Please enter a valid last name';
          }
        },
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(_priceFocusNode);
        },
        icon: Icons.person,
        iconColor: colorCurve);
  }

  BoxField _deliveryChargeWidget() {
    return BoxField(
        controller: _deliveryChargeController,
        focusNode: _deliveryChargeFocusNode,
        hintText: "Enter Delivery Charge",
        lableText: "Delivery Charge",
        icon: Icons.phone_android,
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter a valid Delivery Charge';
          }
        },
        iconColor: colorCurve);
  }

  BoxField _warrantyPeriodWidget() {
    return BoxField(
        controller: _warrantyPeriodController,
        focusNode: _warrantyPeriodFocusNode,
        hintText: "Enter Warranty Period",
        lableText: "Warranty Period",
        icon: Icons.location_on,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter a valid Warranty Period';
          }
        },
        iconColor: colorCurve);
  }

  BoxField _warrantyIncludesWidget() {
    return BoxField(
        controller: _warrantyIncludesController,
        focusNode: _warrantyIncludesFocusNode,
        hintText: "Enter Warranty Includes",
        lableText: "Warranty Includes",
        icon: Icons.location_on,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter a valid Warranty Includes';
          }
        },
        iconColor: colorCurve);
  }

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

  Container _onCreateButtonWidget(AdvertisementState state) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.getWidthPx(20), horizontal: size.getWidthPx(16)),
      width: size.getWidthPx(200),
      child: RaisedButton(
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        padding: EdgeInsets.all(size.getWidthPx(12)),
        child: Text(
          "Create Ad",
          style: TextStyle(
              fontFamily: 'Exo2', color: Colors.white, fontSize: 20.0),
        ),
        color: colorCurve,
        onPressed:
            state is! InAdvertisementState ? _onCreateButtonPresseed : null,
      ),
    );
  }

  GestureDetector socialCircleAvatar(String assetIcon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        maxRadius: size.getWidthPx(20),
        backgroundColor: Colors.white,
        child: Image.asset(assetIcon),
      ),
    );
  }

  registerFields(AdvertisementState state) => Container(
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
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Condition:",
                        style: TextStyle(
                            fontFamily: 'Exo2',
                            color: Colors.black,
                            fontSize: 16.0),
                      ),
                      DropdownButton(
                        value: _selectedCondition,
                        items: _conditionMenuItems,
                        onChanged: onChangeConditionItem,
                      ),
                    ],
                  ),
                  elevation: 4.0,
                ),
                upperBoxCard(),
                _usedForWidget(),
                _termsSection(),
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Delivery Areas:",
                        style: TextStyle(
                            fontFamily: 'Exo2',
                            color: Colors.black,
                            fontSize: 16.0),
                      ),
                      DropdownButton(
                        value: _selectedArea,
                        items: _areaMenuItems,
                        onChanged: onChangeAreaItem,
                      ),
                    ],
                  ),
                  elevation: 4.0,
                ),
                _deliveryChargeWidget(),
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Warranty Type:",
                        style: TextStyle(
                            fontFamily: 'Exo2',
                            color: Colors.black,
                            fontSize: 16.0),
                      ),
                      DropdownButton(
                        value: _selectedString,
                        items: _dropdownMenuItems,
                        onChanged: onChangeDropdownItem,
                      ),
                    ],
                  ),
                  elevation: 4.0,
                ),
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Zone:",
                        style: TextStyle(
                            fontFamily: 'Exo2',
                            color: Colors.black,
                            fontSize: 16.0),
                      ),
                      DropdownButton(
                        value: _selectedZone,
                        items: _zoneMenuItems,
                        onChanged: onChangeZoneItem,
                      ),
                    ],
                  ),
                  elevation: 4.0,
                ),
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "District:",
                        style: TextStyle(
                            fontFamily: 'Exo2',
                            color: Colors.black,
                            fontSize: 16.0),
                      ),
                      DropdownButton(
                        value: _selectedDistrict,
                        items: _districtMenuItems,
                        onChanged: onChangeDistrictItem,
                      ),
                    ],
                  ),
                  elevation: 4.0,
                ),
                _validityWidget(),
                _warrantyPeriodWidget(),
                _warrantyIncludesWidget(),
                _onCreateButtonWidget(state),
              ],
            )),
      );
  SettingSection _termsSection() {
    return SettingSection(
      headerText: "Terms".toUpperCase(),
      headerFontSize: 15.0,
      headerTextColor: Colors.black87,
      backgroundColor: Colors.white,
      disableDivider: false,
      children: <Widget>[
        Container(
          child: SwitchRow(
            label: "Negotiable",
            disableDivider: false,
            value: negotiable == "Yes" ? true : false,
            onSwitchChange: (switchStatus) {
              setState(() {
                switchStatus ? negotiable = "Yes" : negotiable = "No";
              });
            },
            onTap: () {},
          ),
        ),
        Container(
          child: SwitchRow(
            label: "Home Delivery",
            disableDivider: false,
            value: homeDelivery == "Available" ? true : false,
            onSwitchChange: (switchStatus) {
              setState(() {
                switchStatus
                    ? homeDelivery = "Available"
                    : homeDelivery = "Not Available";
              });
            },
            onTap: () {},
          ),
        )
      ],
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onCreateButtonPresseed() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    image3 == null ? print("null") : print(image3.path);
    _advertisementBloc.add(ButtonPressed(
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
        subcategory: _subCategoryController.text,
        ad_title: _adTitleController.text,
        description: _descriptionController.text,
        ad_validity: _adValidityController.text,
        price: _priceController.text,
        negotiable: negotiable.toString(),
        condition: _conditionController.text,
        used_for: _usedForController.text,
        home_delivery: homeDelivery.toString(),
        delivery_areas: _deliveryAreasController.text,
        delivery_charges: _deliveryChargeController.text,
        warranty_type: _warrantyTypeController.text,
        warranty_period: _warrantyPeriodController.text,
        warranty_includes: _warrantyIncludesController.text,
        zone: _selectedZone,
        district: _selectedDistrict));
  }
}

class Location {
  final String zone;
  final String district;
  Location({this.zone, this.district});
}
