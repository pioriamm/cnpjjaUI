
class Email {
  final String? address;
  final String? domain;
  final String? ownership;

  Email({this.address, this.domain, this.ownership});

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(address: json['address'], domain: json['domain'], ownership: json['ownership']);
  }
}