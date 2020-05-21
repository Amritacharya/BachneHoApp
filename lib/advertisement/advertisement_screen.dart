import 'package:Bechneho/ui/add_advertisement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Bechneho/advertisement/index.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({
    Key key,
    @required AdvertisementBloc advertisementBloc,
  })  : _advertisementBloc = advertisementBloc,
        super(key: key);

  final AdvertisementBloc _advertisementBloc;

  @override
  AdvertisementScreenState createState() {
    return AdvertisementScreenState(_advertisementBloc);
  }
}

class AdvertisementScreenState extends State<AdvertisementScreen> {
  final AdvertisementBloc _advertisementBloc;
  AdvertisementScreenState(this._advertisementBloc);

  @override
  void initState() {
    super.initState();
    this._load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementBloc, AdvertisementState>(
        bloc: widget._advertisementBloc,
        builder: (
          BuildContext context,
          AdvertisementState currentState,
        ) {
          if (currentState is UnAdvertisementState) {
            return CreateAdPage(advertisementBloc: _advertisementBloc);
          }
          if (currentState is ErrorAdvertisementState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage ?? 'Error'),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text("reload"),
                    onPressed: () => this._load(),
                  ),
                ),
              ],
            ));
          }
          return CreateAdPage(advertisementBloc: _advertisementBloc);
        });
  }

  void _load([bool isError = false]) {
    widget._advertisementBloc.add(UnAdvertisementEvent());
    widget._advertisementBloc.add(LoadAdvertisementEvent(isError));
  }
}
