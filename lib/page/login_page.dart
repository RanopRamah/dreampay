import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dreampay/page/buyer/buyer_home.dart';
import 'package:dreampay/page/cashier/cashier_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences _pref;
  final TextEditingController _controller = TextEditingController();
  bool isChecked = false;

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
        child: Container(
          padding: const EdgeInsets.only(top: 46),
          decoration: const BoxDecoration(
            color: Color(0xFFFDFDFD),
          ),
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/image/bg-login.png', width: 370, height: 511),
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
                      border: const OutlineInputBorder (
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/image/Indonesia.png', width: 37, height: 28),
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
                const SizedBox(height: 26),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: Checkbox(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            side: BorderSide(width: 1.0, color: Color(0xFFC8BDBD)),
                          ),
                          value: isChecked,
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.all<Color>(Colors.blue),
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Ingat Saya',
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontFamily: 'Euclid Circular B',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
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
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF5258D4)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(49))
                        ),
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
      sendPhone(control);
    }
  }

  Future<void> sendPhone(String no) async {
    final response = await http.post(
      Uri.parse('http://server.sekolahimpian.com:3000/authenticate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'no_hp': no,
      }),
    );

    if (response.statusCode == 200) {
      var output = jsonDecode(response.body);
      saveSession(output['id'], output['no_hp'], output['nama'], output['pin'], output['tipe']);
    } else {
      throw Exception('Failed to Create');
    }
  }

  void saveSession(id, number, name, pin, type) {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((pref) {
      pref.setString('id_customer', id);
      pref.setString('phone_customer', number);
      pref.setString('name_customer', name);
      pref.setString('pin_customer', pin);
      pref.setString('type_customer', type);
      pref.setBool('is_login', true);
    });

    if (type == 'B') {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => BuyerHomePage()), (route) => false);
    } else if (type == 'C') {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => const CashierPage()), (route) => false);
    } else {
      null;
    }
  }

  void checkLogin() async {
    _pref = await SharedPreferences.getInstance();
    var name = _pref.getString('name_customer');
    var isLogin = _pref.getBool('is_login');
    var type = _pref.getString('type_customer');

    if (isLogin != null && isLogin) {
      if (type == 'B') {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => BuyerHomePage()), (route) => false);
      } else if (type == 'C') {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => const CashierPage()), (route) => false);
      } else {
        null;
      }
    }
  }
}