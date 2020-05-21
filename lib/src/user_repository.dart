import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Bechneho/model/account.dart';
import 'package:Bechneho/model/message_model.dart';
import 'package:Bechneho/model/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserRepository {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String fcmToken;
  User _authenticatedUser;
  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  User get user {
    return _authenticatedUser;
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  Future<dynamic> authenticate({
    @required String email,
    @required String password,
  }) async {
    Map<String, dynamic> authData = {
      'username': email,
      'password': password,
      // 'returnSecureToken': true
    };
    try {
      http.Response response;

      response = await http.post(
        'https://bechneho.com/api/accounts/api-get-token-auth/',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('token')) {
        _authenticatedUser = User(
          email: email,
          token: responseData['token'],
        );
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        print(_authenticatedUser.token);
        prefs.setString('token', _authenticatedUser.token);
        prefs.setString('userEmail', _authenticatedUser.email);

        return _authenticatedUser.token;
      } else {
        throw responseData['non_field_errors'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteToken() async {
    _authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');

    return;
  }

  Future<String> hasToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      final String userEmail = prefs.getString('userEmail');
      return (token != null) ? token : null;
    }
  }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse('https://bechneho.com/api/fileupload/'));
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

  Future<int> checkDialog(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    http.Response response;
    int dialogId;
    print(id);
    response = await http
        .post('https://bechneho.com/api/chat/checkchatdialog/', headers: {
      'Authorization': 'Token $token',
    }, body: {
      'receiver': id.toString()
    });
    print(response.body);
    final responseData = json.decode(response.body);
    dialogId = int.parse(responseData['chatdialog'].toString());
    return dialogId;
  }

  Future<List<Message>> getMsg(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    http.Response response;
    print(id);
    response = await http.get(
      'https://bechneho.com/api/chat/messagedetail/?chatdialog_id=$id',
      headers: {
        'Authorization': 'Token $token',
      },
    );
    print(response.body);
    final responseData = json.decode(response.body);
    List<Message> msgData = [];
    responseData['results'].forEach((f) {
      Message msg = Message.fromJson(f);
      msgData.add(msg);
    });
    return msgData;
  }

  Future<Account> loadAccount() async {
    Account account;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token;
      print(token); // Print the Token in Console
    });
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
    });
    http.Response response;
    print(token);
    response = await http.get(
      'https://bechneho.com/api/accounts/userprofile/',
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
    );
    print(response.body);
    final jsonData = json.decode(response.body);

    account = Account(
      firstname: jsonData['results'][0]['first_name'],
      lastname: jsonData['results'][0]['last_name'],
      email: jsonData['results'][0]['email'],
      id: jsonData['results'][0]['pk'],
      profilepic: jsonData['results'][0]['profile_pic'],
      mobileNo: jsonData['results'][0]['mobile'],
    );
    await http.post(
      'https://bechneho.com/api/accounts/fcm/?device_id=${jsonData['results'][0]['firebase_id']}',
      body: json.encode({
        "registration_id": fcmToken,
        "device_id": jsonData['results'][0]['firebase_id'],
        "user": jsonData['results'][0]['pk']
      }),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
    ).then((http.Response response) {
      print(response.statusCode);
    });
    return account;
  }

  Future<Account> getAccount() async {
    Account account;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    http.Response response;
    print(token);
    response = await http.get(
      'https://bechneho.com/api/accounts/userprofile/',
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
    );
    print(response.body);
    final jsonData = json.decode(response.body);

    account = Account(
      firstname: jsonData['results'][0]['first_name'],
      lastname: jsonData['results'][0]['last_name'],
      email: jsonData['results'][0]['email'],
      id: jsonData['results'][0]['pk'],
      //  username: json['username'],
      profilepic: jsonData['results'][0]['profile_pic'],
      //  telephone: json['userprofile']['Telephone'],
      mobileNo: jsonData['results'][0]['mobile'],
      // addressLine1: json['userprofile']['Address_line_1'],
      // addressLine2: json['userprofile']['Address_line_2'],
      // phone: json['userprofile']['display_phone'],
    );

    print(account);
    return account;
  }

  Future<Account> getAccountById(int id) async {
    Account account;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    http.Response response;
    print(token);
    response = await http.get(
      'https://bechneho.com/api/accounts/userprofile/$id/',
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
    );
    print(response.body);
    final jsonData = json.decode(response.body);

    account = Account(
      firstname: jsonData['first_name'],
      lastname: jsonData['last_name'],
      email: jsonData['email'],
      id: jsonData['pk'],
      //  username: json['username'],
      profilepic: jsonData['profile_pic'],
      //  telephone: json['userprofile']['Telephone'],
      mobileNo: jsonData['mobile'],
      // addressLine1: json['userprofile']['Address_line_1'],
      // addressLine2: json['userprofile']['Address_line_2'],
      // phone: json['userprofile']['display_phone'],
    );

    print(account);
    return account;
  }

  Future<dynamic> signUp(
      {String firstName,
      String lastName,
      String email,
      String password,
      String mobilephone,
      String address1,
      String fuuid,
      String fbUserprofile,
      File image}) async {
    bool hasError = true;
    try {
      String url;
      if (fbUserprofile.isEmpty) {
        final uploadedData = await uploadImage(image);
        url = "http://bechneho.com" + uploadedData['image'];
      } else {
        url = fbUserprofile;
      }

      print(fuuid);
      final Map<String, dynamic> authData = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        "profile_pic": url,
        'mobile': mobilephone,
        "firebase_id": fuuid,
      };

      await http.post(
        'https://bechneho.com/api/accounts/register/',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      ).then((http.Response response) async {
        final Map<String, dynamic> responseData = json.decode(response.body);

        print(response.statusCode);
        if (response.statusCode != 200 && response.statusCode != 201) {
          await FirebaseAuth.instance
              .currentUser()
              .then((FirebaseUser users) async {
            users.delete();
          });
          throw responseData;
        } else {
          hasError = false;
        }
      });
      return !hasError;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Account>> fetchUsers() async {
    List<Account> _users = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    await http.get("https://bechneho.com/api/chat/listchatdialog/", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token'
    }).then((http.Response response) {
      final jsonData = json.decode(response.body);
      print(jsonData);

      jsonData.forEach((e) {
        _users.add(Account(
            id: e['user']['pk'],
            firstname: e['user']['first_name'],
            lastname: e['user']['last_name'],
            profilepic: e['user']['profile_pic'],
            chatDialog: e['id'],
            lastMsg: e['latest_message']));
      });
    });
    print(_users);
    return _users;
  }
}
