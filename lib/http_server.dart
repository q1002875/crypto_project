
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class httpService {

  final String baseUrl;

  httpService({required this.baseUrl});

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

Future<dynamic> getJson() async {
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

  Future<dynamic> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
}

////以下用法
// class User {
//   final int id;
//   final String name;
//   final String email;

//   User({required this.id, required this.name, required this.email});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//     );
//   }
// }

// final httpService = HttpService(baseUrl: 'https://example.com/api');

// final response = await httpService.get('users');
// final usersJson = response['data'] as List<dynamic>;
// final users = usersJson.map((userJson) => User.fromJson(userJson)).toList();


