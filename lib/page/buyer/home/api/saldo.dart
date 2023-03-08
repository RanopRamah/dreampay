import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

var url = dotenv.env['API_URL'];

Future<Saldo> fetchSaldo(String id) async {
  final response = await http.get(
    Uri.parse('$url/buyer/$id'),
  );

  if (response.statusCode == 200) {
    return Saldo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}

class Saldo {
  final dynamic saldo;
  final dynamic totalTopup;
  final dynamic totalPengeluaran;

  const Saldo({
    required this.saldo,
    required this.totalTopup,
    required this.totalPengeluaran,
  });

  factory Saldo.fromJson(Map<dynamic, dynamic> json) {
    return Saldo(
      saldo: json['saldo'],
      totalTopup: json['total_topup'],
      totalPengeluaran: json['total_pengeluaran'],
    );
  }
}

