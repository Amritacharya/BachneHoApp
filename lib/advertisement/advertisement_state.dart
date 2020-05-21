import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AdvertisementState extends Equatable {
  AdvertisementState();

  @override
  List<Object> get props => ([]);
}

/// UnInitialized
class UnAdvertisementState extends AdvertisementState {}

/// Initialized
class InAdvertisementState extends AdvertisementState {}

/// Initialized
class CreateAdFinished extends AdvertisementState {}

/// Initialized
class CreateFailure extends AdvertisementState {
  final String error;

  CreateFailure({@required this.error});
}

class ErrorAdvertisementState extends AdvertisementState {
  final String errorMessage;

  ErrorAdvertisementState(version, this.errorMessage);
}
