import 'package:Bechneho/home/index.dart';
import 'package:Bechneho/ui/page_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (
      BuildContext context,
      currentState,
    ) {
      if (currentState is LoadHomeBlocState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (currentState is LoadingHomeBlocState) {
        return Center(
          child: RefreshProgressIndicator(),
        );
      }
      if (currentState is ErrorHomeBlocState) {
        return new Container(
            child: new Center(
          child: new Text(currentState.errorMessage ?? 'Error'),
        ));
      }
      if (currentState is InHomeBlocState) {
        final popular = currentState.popular;
        final featured = currentState.featured;
        final category = currentState.categoryList;
        final recent = currentState.recent;

        return SearchPage(
            premium: popular,
            featured: featured,
            category: category,
            recent: recent);
      }
    });
  }
}
