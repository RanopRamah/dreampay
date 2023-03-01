import 'dart:convert';

import 'package:dreampay/page/admin/topup.dart';
import 'package:dreampay/page/admin/transaction.dart';
import 'package:dreampay/page/admin/withdraw.dart';
import 'package:dreampay/page/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

var url = dotenv.env['API_URL'];

class Users {
  final dynamic id;
  final dynamic nama;
  final dynamic no_hp;

  const Users({required this.id, required this.nama, required this.no_hp});

  factory Users.fromJson(Map<dynamic, dynamic> json) {
    return Users(
      id: json['id'],
      nama: json['nama'],
      no_hp: json['no_hp'],
    );
  }
}

enum SingingCharacter { C, B, S }

class MakeAccountPage extends StatefulWidget {
  const MakeAccountPage({Key? key}) : super(key: key);

  @override
  State<MakeAccountPage> createState() => _MakeAccountPageState();
}

String _selectedType = 'B';

class _MakeAccountPageState extends State<MakeAccountPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PanelController _panelController = PanelController();

  final TextEditingController _nama = TextEditingController();
  final TextEditingController _no_hp = TextEditingController();
  final TextEditingController _pin = TextEditingController();

  String? phone;
  String? name;
  String? id;
  late SharedPreferences prefs;

  Future<void> setValue() async {
    prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone_customer');
    name = prefs.getString('name_customer');
    id = prefs.getString('id_customer');
  }

  Future<List<Users>> fetchUsers() async {
    final response = await http.get(
      Uri.parse('$url/admin/list-user'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)['list_user'];
      return jsonResponse.map((e) => Users.fromJson(e)).toList();
    } else {
      throw Exception(response.body);
    }
  }

  List<Users> user = [];

  late Future<List<Users>> _listuser;
  @override
  initState() {
    setValue();
    _listuser = fetchUsers();
    super.initState();
  }

  void togglePanel() => _panelController.isPanelOpen
      ? _panelController.close()
      : _panelController.open();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: const Color(0xff45499D),
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 170,
                height: 42,
                child: Image.asset('assets/image/logo.png'),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: ListTile(
                  title: Container(
                    padding: const EdgeInsets.only(right: 30, left: 40),
                    width: double.infinity,
                    height: 51,
                    decoration: BoxDecoration(
                        color: const Color(0xff8A8EF9),
                        borderRadius: BorderRadius.circular(13)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset(
                          'assets/image/account.png',
                          width: 21,
                          height: 21,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Akun Baru',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w500,
                              fontSize: 24),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => AdminTransactionPage()));
                  },
                  title: Container(
                    padding: const EdgeInsets.only(right: 25, left: 25),
                    width: 275,
                    height: 51,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset(
                          'assets/image/transaction.png',
                          width: 21,
                          height: 21,
                        ),
                        // SizedBox(
                        //   width: 13,
                        // ),
                        const Text(
                          'Transaksi',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w500,
                              fontSize: 24),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => const AdminTopupPage()));
                  },
                  title: Container(
                    padding: const EdgeInsets.only(right: 45, left: 25),
                    width: 275,
                    height: 51,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset(
                          'assets/image/topup.png',
                          width: 21,
                          height: 21,
                        ),
                        // SizedBox(
                        //   width: 13,
                        // ),
                        const Text(
                          'Top-Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w500,
                              fontSize: 24),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => const AdminWithdrawPage()));
                  },
                  title: Container(
                    padding: const EdgeInsets.only(right: 25, left: 27),
                    width: 275,
                    height: 51,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset(
                          'assets/image/withdraw.png',
                          width: 21,
                          height: 21,
                        ),
                        // SizedBox(
                        //   width: 13,
                        // ),
                        const Text(
                          'Withdraw',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w500,
                              fontSize: 24),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                width: double.infinity,
                height: 98,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff292B5A)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Saldo A',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Euclid Circular B',
                          fontSize: 14,
                          color: Color(0xffbebebe)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 35),
                          child: Text(
                            'Rp',
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          '560,000',
                          style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                width: double.infinity,
                height: 98,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff3A2C62)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Saldo A',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Euclid Circular B',
                          fontSize: 14,
                          color: Color(0xffbebebe)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 35),
                          child: Text(
                            'Rp',
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          '560,000',
                          style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                width: double.infinity,
                height: 98,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff2E3346)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Saldo A',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Euclid Circular B',
                          fontSize: 14,
                          color: Color(0xffbebebe)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 35),
                          child: Text(
                            'Rp',
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          '560,000',
                          style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      key: _scaffoldKey,
      body: SlidingUpPanel(
        minHeight: 70,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        body: Container(
          padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
          decoration: const BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Image.asset(
                      'assets/image/hamburger.png',
                      width: 35,
                      height: 27,
                    ),
                  ),
                  logoutButton(context),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 345,
                height: 600,
                padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    const BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 3,
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(0, 1),
                      blurStyle: BlurStyle.normal,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Akun Baru',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Euclid Circular B',
                          color: Color(0xff222222)),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: _nama,
                      style: const TextStyle(fontFamily: 'Euclid Circular B'),
                      decoration: InputDecoration(
                        labelText: 'Nama Akun',
                        labelStyle:
                            const TextStyle(fontFamily: 'Euclid Circular B'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                width: 0.91,
                                color: Color(
                                  0xffC8BDBD,
                                ))),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: _no_hp,
                      style: const TextStyle(fontFamily: 'Euclid Circular B'),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Nomor Akun',
                        labelStyle:
                            const TextStyle(fontFamily: 'Euclid Circular B'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                width: 0.91,
                                color: Color(
                                  0xffC8BDBD,
                                ))),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextField(
                      controller: _pin,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontFamily: 'Euclid Circular B'),
                      decoration: InputDecoration(
                        labelText: 'PIN Akun',
                        labelStyle:
                            const TextStyle(fontFamily: 'Euclid Circular B'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                width: 0.91,
                                color: Color(
                                  0xffC8BDBD,
                                ))),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Row(
                      children: <Widget>[
                        Text(
                          'Tipe',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w600,
                              color: Color(0xff8D8989)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Akun',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w400,
                              color: Color(0xff8D8989)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
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
                                }),
                            const Expanded(
                                child: Text(
                              'User',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 13,
                                  color: Color(0xff8D8989)),
                            ))
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
                                }),
                            const Text(
                              'Cashier',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 13,
                                  color: Color(0xff8D8989)),
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
                                }),
                            const Text(
                              'Seller',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 13,
                                  color: Color(0xff8D8989)),
                            )
                          ],
                        ),
                      ),
                    ]),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            createUsers();
                          });
                        },
                        child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                                color: const Color(0xff5258D4),
                                borderRadius: BorderRadius.circular(6)),
                            child: const Center(
                              child: Text(
                                'Buat Akun',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Euclid Circular B',
                                    fontSize: 19,
                                    color: Colors.white),
                              ),
                            )))
                  ],
                ),
              )
            ],
          ),
        ),
        panelBuilder: (ScrollController sc) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  // onTap: togglePanel,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 5,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Akun Terdaftar',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Euclid Circular B',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff222222)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: const TextField(
                    style: TextStyle(fontFamily: 'Euclid Circular B'),
                    // onChanged: (value) => _runFilter(value),
                    decoration: InputDecoration(
                        labelText: 'Cari Transaksi',
                        labelStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Euclid Circular B',
                            color: Color(0xffbdbdbd)),
                        prefixIcon: Icon(Icons.search)),
                  ),
                ),
                _scrollingList(sc)
              ]);
        },
      ),
    );
  }

  Column logoutButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 52,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(13)),
              border: Border.all(color: const Color(0xFFD2D2D2), width: 1),
            ),
            child: TextButton(
              child: Image.asset('assets/image/logout.png',
                  width: 27.03, height: 27.05),
              onPressed: () {
                setState(() {
                  prefs.remove('id_customer');
                  prefs.remove('phone_customer');
                  prefs.remove('name_customer');
                  prefs.remove('pin_customer');
                  prefs.remove('type_customer');
                  prefs.remove('is_login');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => const LoginPage()),
                      (route) => false);
                });
              },
            )),
        const Text(
          'Keluar',
          style: TextStyle(
            color: Color(0xFFADADAD),
            fontFamily: 'Euclid Circular B',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _scrollingList(ScrollController sc) {
    return FutureBuilder(
      future: _listuser,
      builder: (context, snapshot) {
        return SizedBox(
            height: 300,
            child: ListView.builder(
              controller: sc,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, i) => Container(
                  padding: const EdgeInsets.only(
                      top: 25, bottom: 25, left: 30, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data![i].nama,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Euclid Circular B',
                                      fontSize: 20,
                                      color: Color(0xff172437))),
                              Text(snapshot.data![i].no_hp,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Euclid Circular B',
                                      fontSize: 16,
                                      color: Color(0xffbebebe))),
                            ]),
                        TextButton(
                            onPressed: () {},
                            child: Container(
                                width: 101,
                                height: 36,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(49),
                                    border: Border.all(
                                        width: 0.5,
                                        color: const Color(0xffe6e6e6))),
                                child: const Center(
                                  child: Text(
                                    'Detail',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Euclid Circular B',
                                        fontSize: 16,
                                        color: Color(0xff222222)),
                                  ),
                                )))
                      ])),
            ));
      },
    );
  }

  Future<void> createUsers() async {
    final response = await http.post(
      Uri.parse('${url}admin/add-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'no_hp': _no_hp.text,
        'nama': _nama.text,
        'pin': _pin.text,
        'tipe': _selectedType.toString(),
      }),
    );
    if (response.statusCode == 200) {
      var output = jsonDecode(response.body);
      if (output['pin'] != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => const MakeAccountPage()),
            (route) => false);
      } else {
        throw Exception('error');
      }
    } else {
      throw Exception(response.body);
    }
  }
}
