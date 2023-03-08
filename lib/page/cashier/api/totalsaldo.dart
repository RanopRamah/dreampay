import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

var url = dotenv.env['API_URL'];

class TotalSaldo {
  final String totalSaldo;

  TotalSaldo({required this.totalSaldo});

  factory TotalSaldo.fromJson(Map<String, dynamic> json) {
    return TotalSaldo(
      totalSaldo: json['total_masuk'],
    );
  }
}

Future<TotalSaldo> fetchTotalSaldo(idSeller) async {
  final response = await http.get(Uri.parse('$url/cashier/total/$idSeller'));
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return TotalSaldo.fromJson(jsonResponse);
  } else {
    throw Exception(response.body);
  }
}
