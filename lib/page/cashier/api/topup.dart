import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

var url = dotenv.env['API_URL'];


// LIST TOPUP
Future<List<TopUp>> fetchTopUp(idSeller) async {
  final response = await http.get(
    Uri.parse('$url/cashier/$idSeller'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_topup'];
    return jsonResponse.map((e) => TopUp.fromJson(e)).toList();
  } else {
    throw Exception(response.body);
  }
}



class TopUp {
  final dynamic id;
  final dynamic penerima;
  final dynamic nominal;
  final dynamic createdAt;

  const TopUp({
    required this.id,
    required this.penerima,
    required this.nominal,
    required this.createdAt,
  });

  factory TopUp.fromJson(Map<dynamic, dynamic> json) {
    return TopUp(
      id: json['id'],
      penerima: json['penerima'],
      nominal: json['nominal'],
      createdAt: json['created_at'],
    );
  }
}

