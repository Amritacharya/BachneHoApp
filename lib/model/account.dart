class Account {
  final String firstname;
  final String lastname;
  final String email;
  final String profilepic;
  final String telephone;
  final String mobileNo;
  final String addressLine1;
  final String addressLine2;
  final String username;
  final bool phone;
  final int id;
  final String lastMsg;

  final int chatDialog;

  Account(
      {this.firstname,
      this.username,
      this.id,
      this.lastname,
      this.email,
      this.phone,
      this.profilepic,
      this.telephone,
      this.mobileNo,
      this.addressLine1,
      this.addressLine2,
      this.chatDialog,
      this.lastMsg});

  factory Account.fromJson(Map<String, dynamic> json) {
    return new Account(
      id: json['user']['pk'],
      firstname: json['user']['first_name'],
      lastname: json['user']['last_name'],
      //  username: json['user']['username'],
      email: json['user']['email'],
      profilepic: json['user']['profile_pic'],
      //  telephone: json['user']['userprofile']['Telephone'],
      mobileNo: json['user']['mobile'],
      // phone: json['user']['userprofile']['display_phone'],
      // addressLine1: json['user']['userprofile']['Address_line_1'],
      // addressLine2: json['user']['userprofile']['Address_line_2'],
    );
  }
}

class Profile {
  final String firstname;
  final String lastname;
  final String email;
  final String profilepic;
  final String telephone;
  final String mobileNo;
  final String addressLine1;
  final String addressLine2;
  final String username;
  final bool phone;

  Profile(
      {this.firstname,
      this.username,
      this.lastname,
      this.email,
      this.profilepic,
      this.telephone,
      this.mobileNo,
      this.addressLine1,
      this.addressLine2,
      this.phone});
}
