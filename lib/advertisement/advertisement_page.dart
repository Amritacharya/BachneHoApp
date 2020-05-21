import 'package:flutter/material.dart';
import 'package:Bechneho/advertisement/index.dart';

class AdvertisementPage extends StatelessWidget {
  static const String routeName = "/advertisement";

  @override
  Widget build(BuildContext context) {
    var _advertisementBloc = AdvertisementBloc();
    return Scaffold(
      body: AdvertisementScreen(advertisementBloc: _advertisementBloc),
    );
  }
}
