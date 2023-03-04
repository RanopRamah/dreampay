import 'dart:async';
import 'dart:convert';

import 'package:dreampay/page/admin/make_account.dart';
import 'package:dreampay/page/buyer/buyer_home.dart';
import 'package:dreampay/page/cashier/cashier_page.dart';
import 'package:dreampay/page/merchant/merchant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

var url = dotenv.env['API_URL'];

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences _pref;
  late SharedPreferences preferences;
  final TextEditingController _controller = TextEditingController();
  bool isChecked = false;
  bool isError = false;
  bool isSubmit = false;

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
            color: Color(0xFFFDFDFD),
          ),
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/image/bg-login.png',
                    width: 370, height: 511),
                const SizedBox(height: 36),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Nomor Handphone',
                      labelStyle: const TextStyle(
                        color: Color(0xFF8D8989),
                        fontFamily: 'Euclid Circular B',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/image/Indonesia.png',
                            width: 37, height: 28),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF222222),
                      fontFamily: 'SF Pro Display',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: isError,
                  child: Image.asset('assets/image/failed_login.png'),
                  // child: const Text(
                  //   'No HP tidak ditemukan',
                  //   style: TextStyle(
                  //       fontSize: 18,
                  //       fontFamily: 'Euclid Circular B',
                  //       color: Colors.redAccent,
                  //       fontWeight: FontWeight.w600),
                  // ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 341,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        validator(_controller.text);
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF5258D4)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(49))),
                      ),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Euclid Circular B',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
               const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: isSubmit,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validator(String? control) {
    if (control == null) {
      return;
    } else {
      setState(() {
        isSubmit = true;
      });
      sendPhone(control)
          .catchError((e) => null)
          .whenComplete(() => setState(() {
                isSubmit = false;
              }));
    }
  }

  Future<void> sendPhone(String no) async {
    final response = await http.post(
      Uri.parse('$url/authenticate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'no_hp': no,
      }),
    );

    if (response.statusCode == 200) {
      var output = jsonDecode(response.body);

      saveSession(
        output['id'],
        output['no_hp'],
        output['nama'],
        output['pin'],
        output['tipe'],
      );
    } else {
      setState(() {
        isError = true;
      });
      throw Exception(response.body);
    }
  }

  void saveSession(id, number, name, pin, type) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString('id_customer', id.toString());
    preferences.setString('phone_customer', number);
    preferences.setString('name_customer', name);
    preferences.setString('pin_customer', pin);
    preferences.setString('type_customer', type);
    preferences.setBool('is_login', true);

    if (type == 'B') {
     Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const BuyerHomePage()),
          (route) => false);
    } else if (type == 'C') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const CashierPage()),
          (route) => false);
    } else if (type == 'S') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const MerchantPage()),
          (route) => false);
    } else if (type == 'A') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const MakeAccountPage()),
          (route) => false);
    } else {
      null;
    }
  }

  void checkLogin() async {
    _pref = await SharedPreferences.getInstance();
    var isLogin = _pref.getBool('is_login');
    var type = _pref.getString('type_customer');

    if (isLogin != null && isLogin) {
      if (type == 'B') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => BuyerHomePage()),
            (route) => false);
      } else if (type == 'C') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => const CashierPage()),
            (route) => false);
      } else if (type == 'S') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => const MerchantPage()),
            (route) => false);
      } else if (type == 'A') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => MakeAccountPage()),
            (route) => false);
      } else {
        null;
      }
    }
  }
}
