import 'package:cloud_firestore/cloud_firestore.dart';

class VendorUser {
  VendorUser({
    this.aprroved,
    this.bussinessName,
    this.city,
    this.country,
    this.date,
    this.email,
    this.landMark,
    this.mobile,
    this.state,
    this.storeImage,
    this.taxRegistered,
    this.tinNumber,
    this.vendorId,
  });

  VendorUser.fromJson(Map<String, Object?> json)
      : this(
          aprroved: json['aprroved']! as bool,
          bussinessName: json['bussinessName']! as String,
          city: json['city']! as String,
          country: json['country']! as String,
          date: json['date']! as Timestamp,
          email: json['email']! as String,
          landMark: json['landMark']! as String,
          mobile: json['mobile']! as String,
          state: json['state']! as String,
          storeImage: json['storeImage']! as String,
          taxRegistered: json['taxRegistered']! as String,
          tinNumber: json['tinNumber']! as String,
          vendorId: json['vendorId']! as String,
        );

  final bool? aprroved;
  final String? bussinessName;
  final String? city;
  final String? country;
  final Timestamp? date;
  final String? email;
  final String? landMark;
  final String? mobile;

  final String? state;
  final String? storeImage;
  final String? taxRegistered;
  final String? tinNumber;
  final String? vendorId;

  Map<String, Object?> toJson() {
    return {
      'aprroved': 'aprroved',
      'bussinessName': 'bussinessName',
      'city': city,
      'country': 'country',
      'date': date,
      'email': email,
      'landMark': landMark,
      'mobile': mobile,
      'state': state,
      'storeImage': storeImage,
      'taxRegistered': taxRegistered,
      'tinNumber': tinNumber,
      'vendorId': vendorId,
    };
  }
}
