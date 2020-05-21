import 'dart:async';
import 'package:Bechneho/home/index.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

@immutable
abstract class HomeEvent {}

class LoadHomeBlocEvent extends HomeEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
