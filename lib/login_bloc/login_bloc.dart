import 'dart:async';

import 'package:Bechneho/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:Bechneho/authentication/authentication.dart';
import 'package:Bechneho/login_bloc/login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final String token = await userRepository.authenticate(
          email: event.username,
          password: event.password,
        );
        if (token != null) {
          authenticationBloc.add(LoggedIn(token: token));
          yield LoginInitial();
          print("object");
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
    if (event is ErrorButton) {
      yield SignUpInitial();
    }
    if (event is FirstEvent) {
      yield SignUpLoading();
    }
    if (event is SignUpButtonPressed) {
      yield SignUpLoading();
      try {
        await userRepository.signUp(
            firstName: event.firstName,
            lastName: event.lastName,
            email: event.email,
            password: event.password,
            mobilephone: event.mobilephone,
            fuuid: event.fuuid,
            image: event.profile,
            fbUserprofile: event.fbUserProfile);

        authenticationBloc.add(SignedUp());
      } catch (error) {
        yield SignUpFailure(error: error.toString());
      }
    }
  }
}
