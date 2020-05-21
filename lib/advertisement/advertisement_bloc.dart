import 'dart:async';
import 'package:Bechneho/src/product_repository.dart';
import 'package:Bechneho/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:Bechneho/advertisement/index.dart';
import 'dart:developer' as developer;

class AdvertisementBloc extends Bloc<AdvertisementEvent, AdvertisementState> {
  static final AdvertisementBloc _advertisementBlocSingleton =
      AdvertisementBloc._internal();
  factory AdvertisementBloc() {
    return _advertisementBlocSingleton;
  }
  AdvertisementBloc._internal();

  @override
  dispose() {
    _advertisementBlocSingleton.dispose();
    super.close();
  }

  ProductRepository productRepository = ProductRepository();
  AdvertisementState get initialState => UnAdvertisementState();

  @override
  Stream<AdvertisementState> mapEventToState(
    AdvertisementEvent event,
  ) async* {
    if (event is ButtonPressed) {
      print("called");
      yield InAdvertisementState();
      print("called");

      try {
        final result = await productRepository.createAd(
            image1: event.image1,
            image2: event.image2,
            image3: event.image3,
            image4: event.image4,
            image5: event.image5,
            image6: event.image6,
            image7: event.image7,
            image8: event.image8,
            image9: event.image9,
            image10: event.image10,
            subcategory: event.subcategory,
            ad_title: event.ad_title,
            description: event.description,
            price: event.price,
            ads_validity: event.ad_validity,
            negotiable: event.negotiable,
            condition: event.condition,
            used_for: event.used_for,
            home_delivery: event.home_delivery,
            delivery_areas: event.delivery_areas,
            delivery_charges: event.delivery_charges,
            warranty_type: event.warranty_type,
            warranty_period: event.warranty_period,
            warranty_includes: event.warranty_includes,
            district: event.district,
            zone: event.zone);
        print(result);
        yield CreateAdFinished();
      } catch (error) {
        yield CreateFailure(error: error.toString());
      }
    }
  }
}
