import 'dart:convert';
import 'dart:async';

import 'package:dreampay/page/admin/make_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

var url = dotenv.env['API_URL'];

class DetailAccount extends StatefulWidget {
  const DetailAccount(this.id_account, this.name_account, this.phone_account,
      this.pin_account, this.tipe_account,
      {super.key})
      : super();

  final id_account;
  final name_account;
  final phone_account;
  final pin_account;
  final tipe_account;

  @override
  State<DetailAccount> createState() => _DetailAccountState();
}

class _DetailAccountState extends State<DetailAccount> {
  late final _controllerName = TextEditingController();
  late final _controllerPhone = TextEditingController();
  late final _controllerPIN = TextEditingController();

  bool isSuccess = false;
  bool isFailed = false;

  late String _selectedType;

  @override
  void initState() {
    _selectedType = widget.tipe_account;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 42),
        decoration: const BoxDecoration(color: Color(0xFFFDFDFD)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (ctx) => const MakeAccountPage()),
                          (route) => false);
                    });
                  },
                  child: Container(
                    width: 52,
                    height: 54,
                    margin: const EdgeInsets.only(left: 25),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFFD2D2D2), width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(13)),
                    ),
                    child: Center(
                      child: Image.asset('assets/image/cross.png',
                          width: 19, height: 19),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 82),
            Center(
              child: Container(
                width: 345,
                height: 580,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 3,
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(0, 1),
                      blurStyle: BlurStyle.normal,
                    )
                  ],
                ),
                padding: const EdgeInsets.only(left: 15, top: 37, right: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Akun',
                      style: TextStyle(
                        fontFamily: 'Euclid Circular B',
                        fontSize: 32.2449,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 200,
                          child: TextField(
                            style: const TextStyle(
                              color: Color(0xFF222222),
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w400,
                              fontSize: 24,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: const TextStyle(
                                color: Color(0xFF8D8989),
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                              ),
                              hintText: widget.name_account,
                            ),
                            controller: _controllerName,
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 47,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFE7E7E7), width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Center(
                            child: Image.asset('assets/image/edit_account.png',
                                width: 19.5, height: 19.99),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 200,
                          child: TextField(
                            style: const TextStyle(
                              color: Color(0xFF222222),
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w400,
                              fontSize: 24,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: const TextStyle(
                                color: Color(0xFF8D8989),
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                              ),
                              hintText: widget.phone_account,
                            ),
                            controller: _controllerPhone,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 47,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFE7E7E7), width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Center(
                            child: Image.asset('assets/image/edit_account.png',
                                width: 19.5, height: 19.99),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 200,
                          child: TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4),
                            ],
                            style: const TextStyle(
                              color: Color(0xFF222222),
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w400,
                              fontSize: 24,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Color(0xFF8D8989),
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                              ),
                              hintText: "****",
                            ),
                            controller: _controllerPIN,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 47,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFE7E7E7), width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Center(
                            child: Image.asset('assets/image/edit_account.png',
                                width: 19.5, height: 19.99),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: const [
                        Text(
                          'Tipe',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.w600,
                            color: Color(0xff8D8989),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Akun',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Euclid Circular B',
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8D8989),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Radio(
                                value: "B",
                                groupValue: _selectedType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value!;
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  'User',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Euclid Circular B',
                                    fontSize: 13,
                                    color: Color(0xff8D8989),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Radio(
                                value: "C",
                                groupValue: _selectedType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value!;
                                  });
                                },
                              ),
                              const Text(
                                'Cashier',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 13,
                                  color: Color(0xff8D8989),
                                ),
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Radio(
                                value: "S",
                                groupValue: _selectedType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value!;
                                  });
                                },
                              ),
                              const Text(
                                'Seller',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 13,
                                  color: Color(0xff8D8989),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          updateAccount();
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xff5258D4),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Text(
                            'Update Akun',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Euclid Circular B',
                              fontSize: 19,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 69, top: 10),
                          child: Visibility(
                            visible: isSuccess,
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Image.asset('assets/image/greensmile.png',
                                      width: 20, height: 20),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Update Berhasil!',
                                    style: TextStyle(
                                      fontFamily: 'Euclid Circular B',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff52D47E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 83, top: 10),
                          child: Visibility(
                            visible: isFailed,
                            child: Container(
                              padding: const EdgeInsets.only(left: 7),
                              child: Row(
                                children: [
                                  Image.asset('assets/image/failed.png',
                                      width: 20, height: 20),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    'Update Gagal!',
                                    style: TextStyle(
                                      fontFamily: 'Euclid Circular B',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffEF3434),
                                    ),
                                  ),
                                ],
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
          ],
        ),
      ),
    ));
  }

  Future<void> updateAccount() async {
    final response = await http.post(
      Uri.parse('$url/admin/edit-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        '_method': 'patch',
        'id': widget.id_account.toString(),
        'no_hp': _controllerPhone.text,
        'nama': _controllerName.text,
        'pin': _controllerPIN.text,
        'tipe': _selectedType.toString(),
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        isSuccess = true;
        isFailed = false;
      });
    } else {
      setState(() {
        isSuccess = false;
        isFailed = true;
      });
    }
  }
}
