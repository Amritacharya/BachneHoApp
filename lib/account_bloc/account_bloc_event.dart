import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AccountBlocEvent extends Equatable {
  AccountBlocEvent([List props = const []]) : super();
}

class LoadAccountBlocEvent extends AccountBlocEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
