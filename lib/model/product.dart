import 'dart:io';

import 'package:Bechneho/model/account.dart';

class Product {
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final String image5;
  final String image6;
  final String image7;
  final String image8;
  final String image9;
  final String image10;
  final String featured;
  final String ad_status;
  final String views;
  final String subcategory;
  final String published_at;
  final String ad_title;
  final String description;
  final String ads_validity;
  final String price;
  final String negotiable;
  final String condition;
  final String used_for;
  final String home_delivery;
  final String delivery_areas;
  final String delivery_charges;
  final String warranty_type;
  final String warranty_period;
  final String warranty_includes;
  final Account account;

  final String zone;
  final String district;
  Product(
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
      this.featured,
      this.ad_status,
      this.views,
      this.subcategory,
      this.published_at,
      this.ad_title,
      this.description,
      this.ads_validity,
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
      this.account,
      this.district,
      this.zone});
  factory Product.fromJson(Map<String, dynamic> json) {
    Account acc = Account.fromJson(json);
    return new Product(
        image1: json['image1'],
        image2: json['image2'],
        image3: json['image2'],
        image4: json['image2'],
        image5: json['image2'],
        image6: json['image2'],
        image7: json['image2'],
        image8: json['image2'],
        image9: json['image2'],
        image10: json['image2'],
        featured: json['featured'],
        ad_status: json['ad_status'],
        views: json['views'].toString(),
        subcategory: json['subcategory'],
        published_at: json['published_at'],
        ad_title: json['ad_title'],
        description: json['description'],
        ads_validity: json['ads_validity'],
        price: json['price'].toString(),
        negotiable: json['negotiable'],
        condition: json['condition'],
        used_for: json['used_for'],
        home_delivery: json['home_delivery'],
        delivery_areas: json['delivery_areas'],
        delivery_charges: json['delivery_charges'],
        warranty_type: json['warranty_type'],
        warranty_period: json['warranty_period'],
        warranty_includes: json['warranty_includes'],
        zone: json['location']['zone'],
        district: json['location']['district'],
        account: acc);
  }
}

class Advertisement {
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
  final String featured;
  final String ad_status;
  final String views;
  final String subcategory;
  final String published_at;
  final String ad_title;
  final String description;
  final String ads_validity;
  final String price;
  final String negotiable;
  final String condition;
  final String used_for;
  final String home_delivery;
  final String delivery_areas;
  final String delivery_charges;
  final String warranty_type;
  final String warranty_period;
  final String warranty_includes;
  final String ad_validity;
  final String zone;
  final String district;

  Advertisement(
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
      this.featured,
      this.ad_status,
      this.views,
      this.subcategory,
      this.published_at,
      this.ad_title,
      this.description,
      this.ads_validity,
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
      this.ad_validity,
      this.zone,
      this.district});
}

class Page {
  final String next;
  final String previous;
  Page({this.next, this.previous});
}
