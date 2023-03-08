import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


var url = dotenv.env['API_URL'];
Future<Seller> fetchUser(String idSeller) async {
  final response = await http.get(
    Uri.parse('$url/seller/$idSeller'),
  );

  if (response.statusCode == 200) {
    return Seller.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}

class Seller {
  final dynamic qrcode;
  final dynamic saldo;
  final dynamic pemasukan;
  final dynamic penarikan;

  const Seller({
    required this.qrcode,
    required this.saldo,
    required this.pemasukan,
    required this.penarikan,
  });

  factory Seller.fromJson(Map<dynamic, dynamic> json) {
    return Seller(
      qrcode: json['qrcode'],
      saldo: json['saldo'],
      pemasukan: json['pemasukan'],
      penarikan: json['penarikan'],
    );
  }
}