import 'dart:async';
import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:dreampay/page/buyer/closing/failed_response.dart';
import 'package:dreampay/page/buyer/closing/success_pay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var url = dotenv.env['API_URL'];

class ArticleMainPage extends StatefulWidget {
  const ArticleMainPage(this.seller_id, this.nominal, {super.key}) : super();

  final seller_id;
  final nominal;

  @override
  State<ArticleMainPage> createState() => _ArticleMainPageState();
}

class _ArticleMainPageState extends State<ArticleMainPage> {
  late SharedPreferences prefs;
  String? _pin;
  String? _id;

  TextEditingController controller = TextEditingController();
  String hashPIN = "";
  int pinLength = 4;
  bool checkPIN = false;
  bool hasError = false;

  Future<void> setPIN() async {
    prefs = await SharedPreferences.getInstance();
    _pin = prefs.getString('pin_customer') ?? '111';
    _id = prefs.getString('id_customer') ?? 'id';
    print(_pin);
  }

  @override
  void initState() {
    setPIN();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Color(0xFFFBFBFB)),
          padding: const EdgeInsets.only(top: 190),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Masukkan PIN',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Euclid Circular B',
                    fontWeight: FontWeight.w600,
                    color: Color(0xff222222),
                  ),
                ),
                const Text(
                  'Masukkan PIN anda untuk melanjutkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Euclid Circular B',
                      fontWeight: FontWeight.w500,
                      color: Color(0xffa6a6a6)
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: PinCodeTextField(
                    controller: controller,
                    appContext: context,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    length: 4,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    pinTheme: PinTheme(
                      fieldWidth: 55,
                      borderWidth: 4,
                      inactiveColor: Color(0xffd9d9d9),
                    ),
                    onChanged: (value){
                    },
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextButton(
                        onPressed: (){},
                        child: const Text(
                          'Batalkan',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Euclid Circular B',
                            fontSize: 20,
                            color:  Color(0xffDD3960),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      decoration: BoxDecoration(
                          color: const Color(0xff5258D4),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            checkPIN = BCrypt.checkpw(controller.text, _pin.toString());
                            if (checkPIN) {
                              sendPay(_id, widget.seller_id, widget.nominal);
                            }
                          });
                        },
                        child: const Text(
                          'Lanjutkan',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Euclid Circular B',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendPay(buyer_id, seller_no_hp, nominal) async {
    final response = await http.post(
      Uri.parse('${url}buyer/pay'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'buyer_id': buyer_id,
        'seller_no_hp': seller_no_hp,
        'nominal': nominal,
      }),
    );

    if (response.statusCode == 200) {
      var output = jsonDecode(response.body);
      if (output['nota'] != null) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => SuccessPayPage(output['seller'])), (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => FailedResponsePage()), (route) => false);
      }
    } else {
      throw Exception('Failed to Send');
    }
  }
}