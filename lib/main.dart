import 'package:dreampay/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_strategy/url_strategy.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'DreamPay',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
