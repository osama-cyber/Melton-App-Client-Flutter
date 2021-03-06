import 'package:melton_app/models/ProfileModel.dart';

class UserModel {
  int id;
  String email;
  String name;
  bool isJuniorFellow;
  String campus;
  String city;
  String country;
  int batch;
  String bio;
  String work;
  PhoneNumber phoneNumber;
  SocialMediaAccounts socialMediaAccounts;
  SDGList SDGs;
  String picture;

  UserModel(
      {this.id,
      this.email,
      this.name,
      this.isJuniorFellow,
      this.campus,
      this.city,
      this.country,
      this.batch,
      this.bio,
      this.work,
      this.phoneNumber,
      this.socialMediaAccounts,
      this.SDGs,
      this.picture});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['user']['email'],
      name: json['name'],
      isJuniorFellow: json['isJuniorFellow'],
      campus: json['campus'],
      city: json['city'],
      country: json['country'],
      batch: json['batch'],
      bio: json['bio'],
      work: json['work'],
      phoneNumber: PhoneNumber.fromJson(json['phoneNumber']),
      socialMediaAccounts: json['socialMediaAccounts'] != null
          ? SocialMediaAccounts.fromJson(
              new List<dynamic>.from(json['socialMediaAccounts']))
          : null,
      SDGs: SDGList.fromJson(new List<int>.from(json['sdgs'])),
      picture: json['picture'],
    );
  }
}
