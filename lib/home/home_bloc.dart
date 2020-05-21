import 'dart:async';
import 'package:Bechneho/model/category.dart';
import 'package:Bechneho/model/product.dart';
import 'package:Bechneho/src/product_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:Bechneho/home/index.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeState get initialState => LoadingHomeBlocState();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is LoadHomeBlocEvent) {
      try {
        final List<Product> popular = await ProductRepository().getPopular();
        final List<Product> featured = await ProductRepository().getFeatured();
        final List<Product> recent = await ProductRepository().getRecent();
        final List<Category> category =
            await ProductRepository().getCategories();
        yield InHomeBlocState(
            categoryList: category,
            featured: featured,
            popular: popular,
            recent: recent);
      } catch (e) {
        throw e.toString();
      }
    }
  }
}
