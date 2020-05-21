import 'package:Bechneho/model/category.dart';
import 'package:Bechneho/model/product.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeState {}

class LoadHomeBlocState extends HomeState {}

class LoadingHomeBlocState extends HomeState {}

class InHomeBlocState extends HomeState {
  final List<Product> popular, featured, recent;
  final List<Category> categoryList;

  InHomeBlocState(
      {this.popular, this.featured, this.categoryList, this.recent});
}

class ErrorHomeBlocState extends HomeState {
  final String errorMessage;

  ErrorHomeBlocState(this.errorMessage);

  @override
  String toString() => 'ErrorHomeState';
}
