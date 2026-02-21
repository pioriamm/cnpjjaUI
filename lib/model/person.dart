class Person {
  final String? id;
  final String? name;
  final String? age;

  Person({this.id, this.name, this.age});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(id: json['id'], name: json['name'], age: json['age']);
  }
}