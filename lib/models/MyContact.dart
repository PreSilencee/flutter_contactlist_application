class MyContact {
  String? name;
  String? phone;
  String? checkInDate;

  MyContact(String name, String phone, String checkInDate) {
    this.name = name;
    this.phone = phone;
    this.checkInDate = checkInDate;
  }

  String? getName() {
    return name;
  }

  String? getPhone() {
    return phone;
  }

  String? getCheckInDate() {
    return checkInDate;
  }
}
