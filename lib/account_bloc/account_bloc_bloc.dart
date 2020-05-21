import 'dart:async';
import 'package:Bechneho/model/account.dart';
import 'package:Bechneho/model/category.dart';
import 'package:Bechneho/model/product.dart';
import 'package:Bechneho/src/product_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:Bechneho/account_bloc/index.dart';

import '../user_repository.dart';

class AccountBlocBloc extends Bloc<AccountBlocEvent, AccountBlocState> {
  final UserRepository accountRepository;
  AccountBlocBloc({this.accountRepository});

  AccountBlocState get initialState => new LoadingAccountBlocState();

  @override
  Stream<AccountBlocState> mapEventToState(
    AccountBlocEvent event,
  ) async* {
    if (event is LoadAccountBlocEvent) {
      try {
        final Account account = await accountRepository.loadAccount();
        final List<Product> ads = await ProductRepository().getAds();
        yield InAccountBlocState(accountModel: account, myads: ads);
      } catch (e) {
        throw e.toString();
      }
    }
  }
}
