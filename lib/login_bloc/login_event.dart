import 'dart:io';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({
    @required this.username,
    @required this.password,
  });
}

class ErrorButton extends LoginEvent {}

class FirstEvent extends LoginEvent {}

class SignUpButtonPressed extends LoginEvent {
  final String password;
  final String firstName;
  final String lastName;
  final String email;
  final String mobilephone;
  final String fuuid;
  final String fbUserProfile;
  final File profile;
  SignUpButtonPressed({
    @required this.email,
    @required this.password,
    this.firstName,
    this.lastName,
    this.profile,
    this.fbUserProfile,
    this.mobilephone,
    this.fuuid,
  });
}
