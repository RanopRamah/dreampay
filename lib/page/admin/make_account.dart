import 'dart:convert';

import 'package:dreampay/page/admin/topup.dart';
import 'package:dreampay/page/admin/transaction.dart';
import 'package:dreampay/page/admin/withdraw.dart';
import 'package:dreampay/page/login_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

var url = dotenv.env['API_URL'];

class Users {
  final dynamic id;
  final dynamic nama;
  final dynamic noHp;
  final dynamic pin;
  final dynamic tipe;

  const Users({
    required this.id,
    required this.nama,
    required this.noHp,
    required this.pin,
    required this.tipe,
  });

  factory Users.fromJson(Map<dynamic, dynamic> json) {
    return Users(
      id: json['id'],
      nama: json['nama'],
      noHp: json['no_hp'],
      pin: json['pin'],
      tipe: json['tipe'],
    );
  }
}

class Uang {
  final dynamic totalSaldo;
  final dynamic totalBuyer;
  final dynamic totalSeller;
  final dynamic totalWithdraw;

  const Uang(
      {required this.totalSaldo,
      required this.totalSeller,
      required this.totalBuyer,
      required this.totalWithdraw});

  factory Uang.fromJson(Map<dynamic, dynamic> json) {
    return Uang(
      totalSaldo: json['total_saldo'],
      totalBuyer: json['total_buyer'],
      totalSeller: json['total_seller'],
      totalWithdraw: json['total_withdraw'],
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

  final TextEditingController _nama = TextEditingController();
  final TextEditingController _noHp = TextEditingController();
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

  List<Users> _filteredAkun = [];

  Future<Uang> fetchUang() async {
    final response = await http.get(
      Uri.parse('$url/admin'),
    );

    if (response.statusCode == 200) {
      return Uang.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  late Future<List<Users>> _listuser;
  Future<Uang>? _uang;

  Future<void> _refreshPage() async {
    fetchUsers();
    fetchUang();
  }

  @override
  initState() {
    setValue();
    _listuser = fetchUsers();
    _uang = fetchUang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: sideBar(context),
      key: _scaffoldKey,
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SlidingUpPanel(
                maxHeight: 590,
                minHeight: 150,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                body: Column(
                  children: [topBar(context), form()],
                ),
                panelBuilder: (ScrollController sc) {
                  return Column(
                    children: <Widget>[
                      GestureDetector(
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
                        child: TextField(
                          style:
                              const TextStyle(fontFamily: 'Euclid Circular B'),
                          onChanged: (value) async {
                            final data = await fetchUsers();
                            setState(() {
                              _filteredAkun = data
                                  .where((item) => item.nama
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          },
                          decoration: const InputDecoration(
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
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Image.asset(
              'assets/image/hamburger.png',
              width: 35,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 52,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: const BorderRadius.all(Radius.circular(13)),
                    border:
                        Border.all(color: const Color(0xFFD2D2D2), width: 1),
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
                            MaterialPageRoute(
                                builder: (ctx) => const LoginPage()),
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
          ),
        ],
      ),
    );
  }

  Container form() {
    return Container(
      width: 345,
      height: 600,
      padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
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
              labelStyle: const TextStyle(fontFamily: 'Euclid Circular B'),
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
            controller: _noHp,
            style: const TextStyle(fontFamily: 'Euclid Circular B'),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nomor Akun',
              labelStyle: const TextStyle(fontFamily: 'Euclid Circular B'),
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
            ],
            controller: _pin,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontFamily: 'Euclid Circular B'),
            decoration: InputDecoration(
              labelText: 'PIN Akun',
              labelStyle: const TextStyle(fontFamily: 'Euclid Circular B'),
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
    );
  }

  Drawer sideBar(BuildContext context) {
    return Drawer(
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
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) => const MakeAccountPage()));
                },
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
                      builder: (c) => const AdminTransactionPage()));
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
            FutureBuilder(
              future: _uang,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      width: double.infinity,
                      height: 98,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff292B5A)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Total Saldo',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Euclid Circular B',
                                fontSize: 14,
                                color: Color(0xffbebebe)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
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
                                snapshot.data!.totalSaldo,
                                style: const TextStyle(
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
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      width: double.infinity,
                      height: 98,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 59, 46, 70)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Total Withdraw',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Euclid Circular B',
                                fontSize: 14,
                                color: Color(0xffbebebe)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
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
                                snapshot.data!.totalWithdraw,
                                style: const TextStyle(
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
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      width: double.infinity,
                      height: 98,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff3A2C62)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Saldo Buyer',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Euclid Circular B',
                                fontSize: 14,
                                color: Color(0xffbebebe)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
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
                                snapshot.data!.totalBuyer,
                                style: const TextStyle(
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
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      width: double.infinity,
                      height: 98,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff2E3346)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Saldo Seller',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Euclid Circular B',
                                fontSize: 14,
                                color: Color(0xffbebebe)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
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
                                snapshot.data!.totalSeller,
                                style: const TextStyle(
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
                  ]);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 40,
                      ))
                    ]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _scrollingList(ScrollController sc) {
    return SizedBox(
      height: 450,
      child: FutureBuilder(
        future: _listuser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 300,
              child: ListView.builder(
                controller: sc,
                itemCount: _filteredAkun.isNotEmpty
                    ? _filteredAkun.length
                    : snapshot.data!.length,
                itemBuilder: (BuildContext context, i) => Container(
                  padding: const EdgeInsets.only(top: 25, left: 30, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                  _filteredAkun.isNotEmpty
                                      ? _filteredAkun[i].nama
                                      : snapshot.data![i].nama,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Euclid Circular B',
                                      fontSize: 20,
                                      color: Color(0xff172437))),
                            ),
                            Text(
                                _filteredAkun.isNotEmpty
                                    ? _filteredAkun[i].noHp
                                    : snapshot.data![i].noHp,
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
                                  width: 0.5, color: const Color(0xffe6e6e6))),
                          child: const Center(
                            child: Text(
                              'Detail',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 16,
                                  color: Color(0xff222222)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.black,
            size: 40,
          );
        },
      ),
    );
  }

  Future<void> createUsers() async {
    final response = await http.post(
      Uri.parse('$url/admin/add-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'no_hp': _noHp.text,
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
