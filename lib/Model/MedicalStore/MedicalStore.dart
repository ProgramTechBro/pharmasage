import 'dart:convert';

class  MedicalStore{
  late  String? branchImageURL;
  final String? branchName;
  final String? branchID;
  final String? branchLocation;
  final String? branchManagerName;
  final String? branchOwnerName;
  //final String? password;
  MedicalStore({
    this.branchImageURL,
    this.branchName,
    this.branchID,
    this.branchLocation,
    this.branchManagerName,
    this.branchOwnerName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'branchImageURL': branchImageURL,
      'branchName': branchName,
      'branchID': branchID,
      'branchLocation': branchLocation,
      'branchManagerName':branchManagerName,
      'branchOwnerName':branchOwnerName,
      //'password':password,
    };
  }

  factory MedicalStore.fromMap(Map<String, dynamic> map) {
    return MedicalStore(
      branchImageURL: map['branchImageURL'] != null
          ?map['branchImageURL'] as String:null,
      branchName: map['branchName'] != null ? map['branchName'] as String : null,
      branchID: map['branchID'] != null ? map['branchID'] as String : null,
      branchLocation:
      map['branchLocation'] != null ? map['branchLocation'] as String : null,
      branchManagerName:
      map['branchManagerName'] != null ? map['branchManagerName'] as String : null,
      branchOwnerName:
      map['branchOwnerName'] != null ? map['branchOwnerName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalStore.fromJson(String source) =>
     MedicalStore.fromMap(json.decode(source) as Map<String, dynamic>);

}
