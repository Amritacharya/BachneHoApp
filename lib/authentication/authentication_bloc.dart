import 'dart:async';

import 'package:Bechneho/login_bloc/login_state.dart';
import 'package:Bechneho/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:Bechneho/authentication/authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final String token = await userRepository.hasToken();
      if (token != null) {
        yield AuthenticationAuthenticate();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }
    if (event is SignedUp) {
      yield AuthenticationLoading();
      yield AuthenticationUnauthenticated();
    }
    if (event is SignUp) {
      yield AuthenticationLoading();
      yield AuthenticationSignUp();
    }
    if (event is LoggedIn) {
      yield AuthenticationLoading();
      yield AuthenticationAuthenticate();
    }
    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
