import 'package:Bechneho/model/account.dart';

class Message {
  final int sender;
  final String time;
  final String text;
  Message({
    this.sender,
    this.time,
    this.text,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        sender: json['sender'],
        text: json['message'],
        time: json['timestamp'].contains(", ")
            ? json['timestamp']
                    .substring(0, json['timestamp'].indexOf(", "))
                    .replaceAll("Â", "") +
                " ago"
            : json['timestamp'].replaceAll("Â", "") + " ago");
  }
}
