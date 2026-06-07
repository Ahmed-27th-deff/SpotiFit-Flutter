import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? password;
  final String? gender;
  final DateTime? dateOfBirth;
  final double? height;
  final double? weight;
  final String? fitnessLevel;
  final List<String>? fitnessGoals;

  const UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    this.gender,
    this.dateOfBirth,
    this.height,
    this.weight,
    this.fitnessLevel,
    this.fitnessGoals,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      fitnessLevel: json['fitness_level'] as String?,
      fitnessGoals: (json['fitness_goals'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      if (password != null) 'password': password,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null)
        'date_of_birth': dateOfBirth!.toIso8601String().split('T')[0],
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (fitnessLevel != null) 'fitness_level': fitnessLevel,
      if (fitnessGoals != null) 'fitness_goals': fitnessGoals,
    };
  }

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? gender,
    DateTime? dateOfBirth,
    double? height,
    double? weight,
    String? fitnessLevel,
    List<String>? fitnessGoals,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        firstName,
        lastName,
        email,
        password,
        gender,
        dateOfBirth,
        height,
        weight,
        fitnessLevel,
        fitnessGoals,
      ];
}
