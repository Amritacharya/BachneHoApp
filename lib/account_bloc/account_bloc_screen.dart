import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Bechneho/account_bloc/index.dart';

class AccountBlocScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBlocBloc, AccountBlocState>(
        bloc: BlocProvider.of<AccountBlocBloc>(context),
        builder: (
          BuildContext context,
          currentState,
        ) {
          if (currentState is LoadAccountBlocState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is LoadingAccountBlocState) {
            return Center(
              child: RefreshProgressIndicator(),
            );
          }
          if (currentState is ErrorAccountBlocState) {
            return new Container(
                child: new Center(
              child: new Text(currentState.errorMessage ?? 'Error'),
            ));
          }
          if (currentState is InAccountBlocState) {
            final account = currentState.accountModel;
            return Container(
                child: new Center(
              child: new Text(account.firstname),
            ));
          }
        });
  }
}
