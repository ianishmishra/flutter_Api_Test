
import 'dart:convert';
import 'package:flutter_api_test/models/image_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_api_test/models/user_name.dart';

import '../models/user.dart';

class UserApi{
  static Future<List<User>?> fetchUsers() async{
    print("Fetch Users Function Call");
    const url = "https://randomuser.me/api/?results=5000";
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri);
      final json = jsonDecode(response.body);
      final results = json['results'] as List<dynamic>;
      final users = results.map((user) {
        final name = UserName(
          title: user['name']['title'],
          first: user['name']['first'],
          last: user['name']['last'],
        );

        final image = UserImage(
            large: user['picture']['large'],
            medium: user['picture']['medium'],
            thumbnail:user['picture']['thumbnail'],
        );

        return User(
          cell: user['cell'],
          email: user['email'],
          phone: user['phone'],
          gender: user['gender'],
          nationality: user['nat'],
          name: name,
          image: image,
        );
      }).toList();
      print('fetching users completed');
      return users;
    } catch (e) {
      print('Error fetching users: $e');
    }
    return null;
  }



}