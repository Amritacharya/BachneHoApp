import 'dart:convert';
import 'dart:io';

import 'package:Bechneho/ui/advertisement/advertisement.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/widgets.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

class ThirdPage extends StatefulWidget {
  final ValueChanged<int> changeCurrentTab;
  final ValueChanged<Third> saveThird;
  ThirdPage({Key key, this.changeCurrentTab, this.saveThird}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
  Screen size;
  String _selectedZone;
  var fileData;
  String _selectedDistrict;
  List<List<String>> _condition = ([
    ['Brand New', 'bn'],
    ['Like New(Used Few Times)', 'ln'],
    ['Excellent', 'e'],
    ['Good', 'g'],
    ['Not Working', 'nw']
  ]);
  List<DropdownMenuItem<String>> _conditionMenuItems;
  List<DropdownMenuItem<String>> _zoneMenuItems;
  List<DropdownMenuItem<String>> _districtMenuItems;
  String _selectedCondition;
  List<String> districts = [];
  int _selectedIndex = 1;
  @override
  void initState() {
    _zoneMenuItems = buildZoneItems(zones);

    _conditionMenuItems = buildConditionMenuItems(_condition);
    _selectedZone = _zoneMenuItems[0].value;
    loadDistrict().then((value) => setState(() {
          fileData = value;

          getDistricts(_selectedZone);
          _districtMenuItems = buildDistrictItems();
          _selectedDistrict = _districtMenuItems[0].value;
        }));
    _selectedCondition = _conditionMenuItems[0].value;

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

  onChangeConditionItem(String selectedString) {
    setState(() {
      _selectedCondition = selectedString;
      _conditionController.text = selectedString;
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

  TextEditingController _adValidityController = TextEditingController();
  TextEditingController _conditionController = TextEditingController();
  TextEditingController _usedForController = TextEditingController();

  String negotiable = "No";
  String homeDelivery = "Available";
  FocusNode _usedForFocusNode = FocusNode();
  Widget _validityWidget() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 400),
            padding: EdgeInsets.all(size.getWidthPx(0)),
            alignment: Alignment.center,
            height: size.getWidthPx(60),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade400, width: 1.0),
                borderRadius: BorderRadius.circular(8.0)),
            child: DateTimeField(
              format: DateFormat("yyyy-MM-dd"),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.today,
                    color: Colors.red,
                    size: size.getWidthPx(22),
                  ),
                  hintText: "Advertisement Validity"),
              onSaved: (DateTime date) {
                print(date.toString());
                setState(() {
                  _adValidityController.text =
                      "${date.year.toString()}-${date.month.toString()}-${date.day.toString()}";
                  print(_adValidityController.text);
                });
              },
              onChanged: (DateTime date) {
                print(date.toString());
                setState(() {
                  _adValidityController.text =
                      "${date.year.toString()}-${date.month.toString()}-${date.day.toString()}";
                  print(_adValidityController.text);
                });
              },
              validator: (DateTime value) {
                if (value.toString().isEmpty) {
                  return 'Please enter a valid date';
                }
              },
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
            ),
          )),
        ],
      ),
      padding: EdgeInsets.only(bottom: size.getWidthPx(8)),
      margin: EdgeInsets.only(
          top: size.getWidthPx(8),
          right: size.getWidthPx(8),
          left: size.getWidthPx(8)),
    );
  }

  BoxField _usedForWidget() {
    return BoxField(
        controller: _usedForController,
        focusNode: _usedForFocusNode,
        hintText: "Enter Used for Time Period",
        lableText: "Used For",
        icon: Icons.timer,
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
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: colorCurve,
                          ),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        SizedBox(width: size.getWidthPx(10)),
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
                    SizedBox(height: size.getWidthPx(30)),
                    Container(
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Location:",
                                style: TextStyle(
                                    fontFamily: 'Exo2',
                                    color: Colors.black,
                                    fontSize: 16.0),
                              ),
                              Card(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                              Card(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                              _usedForWidget(),
                              _termsSection(),
                            ],
                          )),
                    ),
                  ]),
            ),
          ),
        )
      ]),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        FloatingActionButton.extended(
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }
            print(_adValidityController.text);
            Third third = new Third(
                neg: negotiable,
                cond: _selectedCondition,
                use: _usedForController.text,
                delivery: homeDelivery,
                zon: _selectedZone,
                dis: _selectedDistrict,
                validity: _adValidityController.text);
            setState(() {
              widget.changeCurrentTab(3);
              widget.saveThird(third);
            });
          },
          label: Text('Next'),
          icon: Icon(Icons.navigate_next),
          backgroundColor: Colors.green,
        ),
      ]),
    );
  }

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
}
