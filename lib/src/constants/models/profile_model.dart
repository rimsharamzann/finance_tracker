import 'package:firebase_auth/firebase_auth.dart';

class ProfileModel {
  String? uid;
  String? name;
  String? email;
  String? number;
  String? img;

  ProfileModel(
      {required this.number, this.uid, this.name, this.email, this.img});

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      'email': email,
      'number': number,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
        uid: FirebaseAuth.instance.currentUser?.uid ?? '',
        name: map["name"] ?? '',
        email: map['email'] ?? '',
        number: map['number'] ?? "",
        img: map['img'] ?? '');
  }
}
