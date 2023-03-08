import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

var url = dotenv.env['API_URL'];

Future<List> fetchUsers(idSeller) async {
  final response = await http.get(
    Uri.parse('$url/cashier/$idSeller'),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['list_buyer'];
  } else {
    throw Exception(response.body);
  }
}

class Users {
  final dynamic id;
  final dynamic nama;
  final dynamic no_hp;

  const Users({required this.id, required this.nama, required this.no_hp});

  Users.init()
      : id = 0,
        nama = '-',
        no_hp = '-';

  Users.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        nama = map['nama'],
        no_hp = map['no_hp'];

  factory Users.fromJson(Map<dynamic, dynamic> json) {
    return Users(
      id: json['id'],
      nama: json['nama'],
      no_hp: json['no_hp'],
    );
  }
}