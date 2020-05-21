import 'dart:convert';
import 'dart:io';

import 'package:Bechneho/model/account.dart';
import 'package:Bechneho/model/category.dart';
import 'package:Bechneho/model/product.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http_parser/http_parser.dart';

class ProductRepository {
  List<Product> _featuredList = [];
  List<Product> _popularList = [];

  List<Product> _recentList = [];
  List<Product> _allList = [];
  List<Product> _myads = [];

  List<Product> _otherads = [];
  List<Product> _subCategoriesList = [];
  List<Category> _categories = [];
  List<Category> _subCategories = [];
  List<Category> _allSubCategories = [];

  Future<List<Product>> getFeatured() async {
    await http.get("https://bechneho.com/api/market/featured/", headers: {
      'Content-Type': 'application/json'
    }).then((http.Response response) {
      var jsonData = json.decode(response.body);

      jsonData['results'].forEach((data) {
        Product p = Product.fromJson(data);
        _featuredList.add(p);
        print(p);
      });
    });
    return _featuredList;
  }

  Future<List<Product>> getRecent() async {
    await http.get("https://bechneho.com/api/market/recent/", headers: {
      'Content-Type': 'application/json'
    }).then((http.Response response) {
      var jsonData = json.decode(response.body);

      jsonData['results'].forEach((data) {
        Product p = Product.fromJson(data);
        _recentList.add(p);
        print(p);
      });
    });
    return _recentList;
  }

  Future<List<Category>> getCategories() async {
    await http.get("https://bechneho.com/api/market/categories/", headers: {
      'Content-Type': 'application/json'
    }).then((http.Response response) {
      var jsonData = json.decode(response.body);

      jsonData['results'].forEach((data) {
        Category p = Category(name: data['category'], slug: data['slug']);
        _categories.add(p);
      });
    });
    return _categories;
  }

  Future<List<Category>> getSubCategories(String slug) async {
    await http.get("https://bechneho.com/api/market/subcategories/?slug=$slug",
        headers: {
          'Content-Type': 'application/json'
        }).then((http.Response response) {
      var jsonData = json.decode(response.body);

      jsonData['results'].forEach((data) {
        Category p = Category(
            name: data['Sub_Category'],
            image: data['image'],
            slug: data['slug']);
        _subCategories.add(p);
      });
    });
    return _subCategories;
  }

  Future<List<Category>> getAllSubCategories() async {
    await http.get("https://bechneho.com/api/market/allsubcategories/",
        headers: {
          'Content-Type': 'application/json'
        }).then((http.Response response) {
      var jsonData = json.decode(response.body);

      jsonData['results'].forEach((data) {
        Category p = Category(
            name: data['Sub_Category'],
            image: data['image'],
            slug: data['slug']);
        _allSubCategories.add(p);
      });
    });
    return _allSubCategories;
  }

  Future<List<Product>> getSubCategoriesLists(String slug) async {
    await http.get(
        "https://bechneho.com/api/market/postlist/?subcategory_slug=$slug",
        headers: {
          'Content-Type': 'application/json'
        }).then((http.Response response) {
      var jsonData = json.decode(response.body);

      jsonData['results'].forEach((data) {
        Product p = Product.fromJson(data);
        _subCategoriesList.add(p);
      });
    });
    return _subCategoriesList;
  }

  Future<List<Product>> getAds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    await http.get("https://bechneho.com/api/market/myads/", headers: {
      'Authorization': 'Token $token'
    }).then((http.Response response) {
      var jsonData = json.decode(response.body);
      print(jsonData['results']);
      jsonData['results'].forEach((data) {
        Product p = Product.fromJson(data);
        _myads.add(p);
        print(p);
      });
    });
    return _myads;
  }

  Future<List<Product>> getOtherAds(int id) async {
    await http.get("https://bechneho.com/api/market/listuserads/?id=$id",
        headers: {
          'Content-Type': 'application/json'
        }).then((http.Response response) {
      var jsonData = json.decode(response.body);

      jsonData['results'].forEach((data) {
        Product p = Product.fromJson(data);
        _otherads.add(p);
      });
    });
    return _otherads;
  }

  Future<List<Product>> getPopular() async {
    await http.get("https://bechneho.com/api/market/popular", headers: {
      'Content-Type': 'application/json'
    }).then((http.Response response) {
      var jsonData = json.decode(response.body);

      jsonData['results'].forEach((data) {
        Product p = Product.fromJson(data);
        _popularList.add(p);
      });
    });
    return _popularList;
  }

  Future<List<Product>> getAll() async {
    await http.get("https://bechneho.com/api/market/advertisements", headers: {
      'Content-Type': 'application/json'
    }).then((http.Response response) {
      var jsonData = json.decode(response.body);
      print(jsonData);
      jsonData['results'].forEach((data) {
        Product p = Product.fromJson(data);
        _allList.add(p);
      });
    });
    return _allList;
  }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse('https://bechneho.com/api/fileupload/'));
    var result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      image.path,
      quality: 40,
    );

    print(image.lengthSync());
    print(result.lengthSync());

    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['image'] = Uri.encodeComponent(imagePath);
    }

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<dynamic> createAd(
      {File image1,
      File image2,
      File image3,
      File image4,
      File image5,
      File image6,
      File image7,
      File image8,
      File image9,
      File image10,
      String subcategory,
      String ad_title,
      String description,
      String ads_validity,
      String price,
      String negotiable,
      String condition,
      String used_for,
      String home_delivery,
      String delivery_areas,
      String delivery_charges,
      String warranty_type,
      String warranty_period,
      String warranty_includes,
      String zone,
      String district}) async {
    bool hasError = true;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    try {
      final uploadedData = await uploadImage(image1);
      Map<String, dynamic> uploadedData2,
          uploadedData3,
          uploadedData4,
          uploadedData5,
          uploadedData6,
          uploadedData7,
          uploadedData8,
          uploadedData9,
          uploadedData10;
      image2 == null ? print("object") : print(image2.path);
      image2 == null
          ? uploadedData2 = uploadedData
          : uploadedData2 = await uploadImage(image2);
      image3 == null
          ? uploadedData3 = uploadedData
          : uploadedData3 = await uploadImage(image3);
      image4 == null
          ? uploadedData4 = uploadedData
          : uploadedData4 = await uploadImage(image4);
      image5 == null
          ? uploadedData5 = uploadedData
          : uploadedData5 = await uploadImage(image5);
      image6 == null
          ? uploadedData6 = uploadedData
          : uploadedData6 = await uploadImage(image6);
      image7 == null
          ? uploadedData7 = uploadedData
          : uploadedData7 = await uploadImage(image7);
      image8 == null
          ? uploadedData8 = uploadedData
          : uploadedData8 = await uploadImage(image8);
      image9 == null
          ? uploadedData9 = uploadedData
          : uploadedData9 = await uploadImage(image9);
      image10 == null
          ? uploadedData10 = uploadedData
          : uploadedData10 = await uploadImage(image10);

      final Map<String, dynamic> authData = {
        "image1": "http://bechneho.com${uploadedData['image']}",
        "image2": "http://bechneho.com${uploadedData2['image']}",
        "image3": "http://bechneho.com${uploadedData3['image']}",
        "image4": "http://bechneho.com${uploadedData4['image']}",
        "image5": "http://bechneho.com${uploadedData5['image']}",
        "image6": "http://bechneho.com${uploadedData6['image']}",
        "image7": "http://bechneho.com${uploadedData7['image']}",
        "image8": "http://bechneho.com${uploadedData8['image']}",
        "image9": "http://bechneho.com${uploadedData9['image']}",
        "image10": "http://bechneho.com${uploadedData10['image']}",
        "subcategory": "$subcategory",
        "ad_title": "$ad_title",
        "description": description,
        "ads_validity": ads_validity,
        "price": price,
        "negotiable": negotiable,
        "condition": condition,
        "used_for": used_for,
        "home_delivery": home_delivery,
        "delivery_areas": delivery_areas,
        "delivery_charges": delivery_charges,
        "warranty_type": warranty_type,
        "warranty_period": warranty_period,
        "warranty_includes": warranty_includes,
        "location": {"zone": zone, "district": district}
      };
      print(authData);
      await http.post(
        'https://bechneho.com/api/market/createpost/',
        body: json.encode(authData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token'
        },
      ).then((http.Response response) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        print(response.statusCode);
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw responseData;
        } else {
          hasError = false;
        }
      });
      print(!hasError);
      return !hasError;
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }
}
