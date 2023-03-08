import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


var url = dotenv.env['API_URL'];

Future<List<TopUp>> fetchTopup(String id) async {
  final response = await http.get(
    Uri.parse('$url/buyer/$id}'),
  );
  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_topup'];
    return jsonResponse.map((e) => TopUp.fromJson(e)).toList();
  } else {
    return [];
  }
}

class TopUp {
  final dynamic id;
  final dynamic nota;
  final dynamic pengirim;
  final dynamic penerima;
  final dynamic nominal;
  final dynamic createdAt;

  const TopUp({
    required this.id,
    required this.nota,
    required this.pengirim,
    required this.penerima,
    required this.nominal,
    required this.createdAt,
  });

  factory TopUp.fromJson(Map<dynamic, dynamic> json) {
    return TopUp(
      id: json['id'],
      nota: json['nota'],
      pengirim: json['pengirim'],
      penerima: json['penerima'],
      nominal: json['nominal'],
      createdAt: json['created_at'],
    );
  }
}