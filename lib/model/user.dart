import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String token;
  final String firstName;
  final String lastName;

  User({
    //  @required this.id,
    @required this.email,
    @required this.token,
    this.id,
    this.firstName,
    this.lastName,
  });
}
