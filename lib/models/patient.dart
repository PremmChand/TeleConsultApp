import 'dart:convert';

class Patient {
  final String id;
  final String name;
  final int age;
  final String? phone;
  final String? symptoms;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    this.phone,
    this.symptoms,
  });

  Patient copyWith({String? id, String? name, int? age, String? phone, String? symptoms}) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      symptoms: symptoms ?? this.symptoms,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age, 'phone': phone, 'symptoms': symptoms};
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      age: (map['age'] is int) ? map['age'] : int.tryParse(map['age']?.toString() ?? '0') ?? 0,
      phone: map['phone']?.toString(),
      symptoms: map['symptoms']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());
  factory Patient.fromJson(String source) => Patient.fromMap(json.decode(source));
}
