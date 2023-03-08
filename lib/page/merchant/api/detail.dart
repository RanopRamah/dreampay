import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


var url = dotenv.env['API_URL'];

Future<List<Detail>> fetchPemasukan(String id) async {
  final response = await http.get(
    Uri.parse('$url/seller/$id'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_pemasukan'];
    return jsonResponse.map((e) => Detail.fromJson(e)).toList();
  } else {
    throw Exception(response.body);
  }
}

Future<List<Detail>> fetchPenarikan(String id) async {
  final response = await http.get(
    Uri.parse('$url/seller/$id'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_penarikan'];
    return jsonResponse.map((e) => Detail.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load');
  }
}

class Detail {
  final dynamic pengirim;
  final dynamic created_at;
  final dynamic nominal;

  const Detail({
    required this.pengirim,
    required this.created_at,
    required this.nominal,
  });

  factory Detail.fromJson(Map<dynamic, dynamic> json) {
    return Detail(
      pengirim: json['pengirim'],
      created_at: json['created_at'],
      nominal: json['nominal'],
    );
  }
}