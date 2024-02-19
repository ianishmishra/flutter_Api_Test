import 'package:flutter_api_test/models/user_name.dart';

import 'package:flutter_api_test/models/image_model.dart';

class User{
  final String gender;
  final String email;
  final String phone;
  final String cell;
  final String nationality;
  final UserName name;
  final UserImage image;

  User({
    required this.email,
    required this.gender,
    required this.phone,
    required this.cell,
    required this.nationality,
    required this.name,
    required this.image,
  });

  String get fullname{
    return '${name.title} ${name.first} ${name.last}';
  }

}

