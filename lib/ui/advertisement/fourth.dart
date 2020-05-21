import 'package:Bechneho/advertisement/index.dart';
import 'package:Bechneho/ui/advertisement/advertisement.dart';
import 'package:flutter/material.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/widgets.dart';
import 'package:flutter/services.dart';

class FourthPage extends StatefulWidget {
  final ValueChanged<int> changeCurrentTab;
  final ValueChanged<Fourth> saveFourth;
  FourthPage({Key key, this.changeCurrentTab, this.saveFourth})
      : super(key: key);
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  List<List<String>> _warrantyTypes = ([
    ['Manufacturer/Importer', 'm'],
    ['Seller/Shop', 's'],
    ['No Warranty', 'n']
  ]);
  List<List<String>> _homeDelivery = ([
    ['Within My Area', 'wa'],
    ['Within My City', 'wc'],
    ['All over Nepal', 'np']
  ]);

  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<DropdownMenuItem<String>> _areaMenuItems;
  String _selectedString;
  String _selectedArea;
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_warrantyTypes);
    _areaMenuItems = buildAreaMenuItems(_homeDelivery);
    _selectedArea = _areaMenuItems[0].value;
    _selectedString = _dropdownMenuItems[0].value;

    super.initState();
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

  onChangeAreaItem(String selectedString) {
    setState(() {
      _selectedArea = selectedString;
      _deliveryAreasController.text = selectedString;
    });
  }

  TextEditingController _deliveryAreasController = TextEditingController();
  TextEditingController _deliveryChargeController = TextEditingController();
  TextEditingController _warrantyTypeController = TextEditingController();
  TextEditingController _warrantyPeriodController = TextEditingController();
  TextEditingController _warrantyIncludesController = TextEditingController();

  FocusNode _deliveryChargeFocusNode = FocusNode();
  FocusNode _warrantyPeriodFocusNode = FocusNode();
  FocusNode _warrantyIncludesFocusNode = FocusNode();

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Screen size;

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    Widget bodyWidget() {
      return Stack(children: <Widget>[
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
                    registerFields()
                  ]),
            ),
          ),
        )
      ]);
    }

    return Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: true,
        body: bodyWidget());
  }

  GradientText _signUpGradientText() {
    return GradientText('Product Detail',
        gradient: LinearGradient(colors: [
          Color.fromRGBO(255, 0, 0, 1.0),
          Color.fromRGBO(255, 99, 71, 1.0)
        ]),
        style: TextStyle(
            fontFamily: 'Exo2', fontSize: 26, fontWeight: FontWeight.bold));
  }

  BoxField _deliveryChargeWidget() {
    return BoxField(
        controller: _deliveryChargeController,
        focusNode: _deliveryChargeFocusNode,
        hintText: "Enter Delivery Charge",
        lableText: "Delivery Charge",
        icon: Icons.phone_android,
        keyboardType: TextInputType.number,
        iconColor: colorCurve);
  }

  BoxField _warrantyPeriodWidget() {
    return BoxField(
        controller: _warrantyPeriodController,
        focusNode: _warrantyPeriodFocusNode,
        hintText: "Enter Warranty Period",
        lableText: "Warranty Period",
        icon: Icons.location_on,
        iconColor: colorCurve);
  }

  BoxField _warrantyIncludesWidget() {
    return BoxField(
        containerHeight: 100,
        controller: _warrantyIncludesController,
        focusNode: _warrantyIncludesFocusNode,
        hintText: "Enter Warranty Includes",
        lableText: "Warranty Includes",
        icon: Icons.location_on,
        iconColor: colorCurve);
  }

  Container _onCreateButtonWidget() {
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
            "Review Ad",
            style: TextStyle(
                fontFamily: 'Exo2', color: Colors.white, fontSize: 20.0),
          ),
          color: Colors.green,
          onPressed: () {
            Fourth fourth = new Fourth(
                areas: _selectedArea,
                charges: _deliveryChargeController.text,
                type: _selectedString,
                period: _warrantyPeriodController.text,
                includes: _warrantyIncludesController.text);
            setState(() {
              widget.changeCurrentTab(4);
              widget.saveFourth(fourth);
            });
          }),
    );
  }

  registerFields() => Container(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                _warrantyPeriodWidget(),
                _warrantyIncludesWidget(),
                _onCreateButtonWidget(),
              ],
            )),
      );
}
