import 'package:intl/intl.dart';

class MyContact {
  String? name;
  String? phone;
  String? checkInDate;

  MyContact({this.name, this.phone, this.checkInDate});

  String? getName() {
    return name;
  }

  String? getPhone() {
    return phone;
  }

  String? getCheckInDate() {
    return checkInDate;
  }

  factory MyContact.fromJson(Map<String, dynamic> json) {
    //DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    return MyContact(
      name: json['user'] as String,
      phone: json['phone'] as String,
      checkInDate: json['checkIn'] as String,
    );
  }

  // Map<String, dynamic> toJson() =>
  //     {'name': name, 'phone': phone, 'checkIn': checkInDate};

  Map<String, dynamic> toJson() {
    return {
      'user': this.name,
      "phone": this.phone,
      "checkIn": this.checkInDate
    };
  }
}
