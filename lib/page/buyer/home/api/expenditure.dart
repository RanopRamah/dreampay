import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

var url = dotenv.env['API_URL'];
Future<List<Pengeluaran>> fetchPengeluaran(String id) async {
  final response = await http.get(
    Uri.parse('$url/buyer/$id}'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_pengeluaran'];
    return jsonResponse.map((e) => Pengeluaran.fromJson(e)).toList();
  } else {
    return [];
  }
}

class Pengeluaran {
  final dynamic id;
  final dynamic nota;
  final dynamic pengirim;
  final dynamic penerima;
  final dynamic nominal;
  final dynamic createdAt;

  const Pengeluaran({
    required this.id,
    required this.nota,
    required this.pengirim,
    required this.penerima,
    required this.nominal,
    required this.createdAt,
  });

  factory Pengeluaran.fromJson(Map<dynamic, dynamic> json) {
    return Pengeluaran(
      id: json['id'],
      nota: json['nota'],
      pengirim: json['pengirim'],
      penerima: json['penerima'],
      nominal: json['nominal'],
      createdAt: json['created_at'],
    );
  }
}