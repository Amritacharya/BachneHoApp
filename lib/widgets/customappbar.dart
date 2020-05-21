import 'package:Bechneho/utils/colors.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/gradient_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  CustomAppBar({Key key, this.title}) : super(key: key);

  Screen size;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    size = Screen(MediaQuery.of(context).size);
    return Material(
      child: Container(
        height: height / 10,
        width: width,
        padding: EdgeInsets.only(left: 15, top: 35),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange[200], colorCurve]),
        ),
        child: title == null
            ? Text(" ")
            : Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: 36.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white)),
      ),
    );
  }
}
