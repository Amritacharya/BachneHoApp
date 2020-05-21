import 'package:Bechneho/model/message_model.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:flutter/material.dart';

class SentMessageWidget extends StatelessWidget {
  final Message msg;
  const SentMessageWidget({
    Key key,
    this.msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "${msg.time}",
            style: Theme.of(context).textTheme.body2.apply(color: Colors.grey),
          ),
          SizedBox(width: 15),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .5),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: colorCurve,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            child: Text(
              "${msg.text}",
              style: Theme.of(context).textTheme.body2.apply(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
