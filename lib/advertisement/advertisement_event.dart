import 'dart:io';
import 'package:meta/meta.dart';

@immutable
abstract class AdvertisementEvent {
  const AdvertisementEvent();

  @override
  List<Object> get props => [];
}

class UnAdvertisementEvent extends AdvertisementEvent {}

class ButtonPressed extends AdvertisementEvent {
  final File image1;
  final File image2;
  final File image3;
  final File image4;
  final File image5;
  final File image6;
  final File image7;
  final File image8;
  final File image9;
  final File image10;
  final String subcategory;
  final String ad_title;
  final String description;
  final String price;
  final String negotiable;
  final String condition;
  final String used_for;
  final String home_delivery;
  final String delivery_areas;
  final String delivery_charges;
  final String ad_validity;
  final String warranty_type;
  final String warranty_period;
  final String warranty_includes;
  final String zone;
  final String district;
  ButtonPressed(
      {this.image1,
      this.image2,
      this.image3,
      this.image4,
      this.image5,
      this.image6,
      this.image7,
      this.image8,
      this.image9,
      this.image10,
      this.subcategory,
      this.ad_title,
      this.description,
      this.ad_validity,
      this.price,
      this.negotiable,
      this.condition,
      this.used_for,
      this.home_delivery,
      this.delivery_areas,
      this.delivery_charges,
      this.warranty_type,
      this.warranty_period,
      this.warranty_includes,
      this.district,
      this.zone});
}

class LoadAdvertisementEvent extends AdvertisementEvent {
  final bool isError;

  LoadAdvertisementEvent(this.isError);
}
