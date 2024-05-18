import 'dart:convert';

class UserProfile {
  late  String? imagesURL;
  final String? fullName;
  final String? userName;
  final String? contact;
  final String? email;
  final String? role;
  //final String? password;
  UserProfile({
    this.imagesURL,
    this.fullName,
    this.userName,
    this.contact,
    this.email,
    this.role,
    //this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imagesURL': imagesURL,
      'fullName': fullName,
      'userName': userName,
      'contact': contact,
      'email':email,
      'role':role,
      //'password':password,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      imagesURL: map['imagesURL'] != null
          ?map['imagesURL'] as String:null,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      contact:
      map['contact'] != null ? map['contact'] as String : null,
      email:
      map['email'] != null ? map['email'] as String : null,
      role:
      map['role'] != null ? map['role'] as String : null,

    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);
}
