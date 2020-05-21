import 'package:Bechneho/model/account.dart';
import 'package:Bechneho/model/category.dart';
import 'package:Bechneho/model/product.dart';
import 'package:equatable/equatable.dart';
import 'package:Bechneho/account_bloc/account_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AccountBlocState {}

/// UnInitialized
class LoadAccountBlocState extends AccountBlocState {}

class LoadingAccountBlocState extends AccountBlocState {}

/// Initialized
class InAccountBlocState extends AccountBlocState {
  final Account accountModel;
  final List<Product> myads;
  InAccountBlocState({@required this.accountModel, this.myads})
      : assert(accountModel != null);
}

class ErrorAccountBlocState extends AccountBlocState {
  final String errorMessage;

  ErrorAccountBlocState(this.errorMessage);

  @override
  String toString() => 'ErrorAccountBlocState';
}
