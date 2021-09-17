import 'package:intl/intl.dart';

class MyContact {
  String? name;
  String? phone;
  DateTime? checkInDate;

  MyContact({this.name, this.phone, this.checkInDate});

  String? getName() {
    return name;
  }

  String? getPhone() {
    return phone;
  }

  DateTime? getCheckInDate() {
    return checkInDate;
  }

  factory MyContact.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    return MyContact(
      name: json['user'] as String,
      phone: json['phone'] as String,
      checkInDate: format.parse(json['checkIn']),
    );
  }
}
