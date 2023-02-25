import 'package:dreampay/page/buyer/buyer_home.dart';
import 'package:dreampay/page/buyer/closing/failed_response.dart';
import 'package:dreampay/page/buyer/login_page.dart';
import 'package:dreampay/page/buyer/nominal_page.dart';
import 'package:dreampay/page/buyer/qr_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: NominalPage(),
    );
  }
}