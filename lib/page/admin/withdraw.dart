import 'dart:convert';
import 'dart:async';

import 'package:dreampay/page/admin/make_account.dart';
import 'package:dreampay/page/admin/topup.dart';
import 'package:dreampay/page/admin/transaction.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:searchfield/searchfield.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../login_page.dart';

var url = dotenv.env['API_URL'];

Future<Admin> fetchAdmin(String id) async {
  final response = await http.get(
    Uri.parse('$url/admin'),
  );

  if (response.statusCode == 200) {
    return Admin.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}

class Admin {
  final dynamic totalSaldo;
  final dynamic totalSeller;
  final dynamic totalWithdraw;

  const Admin({
    required this.totalSaldo,
    required this.totalSeller,
    required this.totalWithdraw,
  });

  factory Admin.fromJson(Map<dynamic, dynamic> json) {
    return Admin(
      totalSaldo: json['total_saldo'],
      totalSeller: json['total_seller'],
      totalWithdraw: json['total_withdraw'],
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

Future<List> fetchUsers() async {
  final response = await http.get(
    Uri.parse('$url/admin/list-withdraw'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['list_seller'];
  } else {
    throw Exception('Failed to Load');
  }
}

Future<List<Withdraw>> fetchWithdraw() async {
  final response = await http.get(
    Uri.parse('$url/admin/list-withdraw'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_withdraw'];
    return jsonResponse.map((e) => Withdraw.fromJson(e)).toList();
  } else {
    throw Exception('Failed to Load');
  }
}

class Users {
  final dynamic id;
  final dynamic nama;
  final dynamic no_hp;

  const Users({required this.id, required this.nama, required this.no_hp});

  Users.init()
      : id = 0,
        nama = '-',
        no_hp = '-';

  Users.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'] as int,
        nama = map['nama'] as String,
        no_hp = map['no_hp'] as String;

  factory Users.fromJson(Map<dynamic, dynamic> json) {
    return Users(
      id: json['id'],
      nama: json['nama'],
      no_hp: json['no_hp'],
    );
  }
}

class Withdraw {
  final dynamic id;
  final dynamic pengirim;
  final dynamic penerima;
  final dynamic nominal;
  final dynamic created_at;

  const Withdraw({
    required this.id,
    required this.pengirim,
    required this.penerima,
    required this.nominal,
    required this.created_at,
  });

  factory Withdraw.fromJson(Map<dynamic, dynamic> json) {
    return Withdraw(
      id: json['id'],
      pengirim: json['pengirim'],
      penerima: json['penerima'],
      nominal: json['nominal'],
      created_at: json['created_at'],
    );
  }
}

class AdminWithdrawPage extends StatefulWidget {
  const AdminWithdrawPage({Key? key}) : super(key: key);

  @override
  State<AdminWithdrawPage> createState() => _AdminWithdrawPageState();
}

class _AdminWithdrawPageState extends State<AdminWithdrawPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();

  TextEditingController _withdrawcontrol = TextEditingController();

  List<Users> user = [];
  Users _selectedUsers = Users.init();

  bool successWithdraw = false;
  bool failedWithdraw = false;

  final PanelController _controller = PanelController();
  late Future<List<Withdraw>> withdraw;

  String? phone;
  String? name;
  String? id;
  Future<Uang>? _uang;
  late SharedPreferences prefs;

  Future<Admin>? _admin;

  Future<void> setValue() async {
    prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone_customer');
    name = prefs.getString('name_customer');
    id = prefs.getString('id_customer');

    _admin = fetchAdmin(id.toString());
  }

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

  @override
  void initState() {
    setValue();
    listToUser();
    super.initState();
    _uang = fetchUang();
    withdraw = fetchWithdraw();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void listToUser() async {
    List<dynamic> data = await fetchUsers();

    setState(() {
      user = data.map((e) => Users.fromMap(e)).toList();
    });
  }

  bool containsUser(String text) {
    final Users result = user.firstWhere(
        (Users u) => u.nama.toLowerCase() == text.toLowerCase(),
        orElse: () => Users.init());

    if (result.nama.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: sideBar(context),
      key: _scaffoldKey,
      body: RefreshIndicator(
        onRefresh: setValue,
        child: SlidingUpPanel(
          controller: _controller,
          maxHeight: 590,
          minHeight: 150,
          padding: const EdgeInsets.only(left: 30, right: 30),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  topBar(context),
                  body(context),
                ],
              ),
            ),
          ),
          panelBuilder: (controller) {
            return Column(
              children: [
                GestureDetector(
                  child: Center(
                    child: Container(
                      width: 85,
                      height: 4,
                      margin: const EdgeInsets.only(top: 7),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEBEBEB),
                        borderRadius: BorderRadius.all(Radius.circular(29)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Riwayat Penarikan',
                    style: TextStyle(
                      color: Color(0xFF172437),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Euclid Circular B',
                    ),
                  ),
                ),
                Container(
                  width: 342,
                  height: 30,
                  margin: const EdgeInsets.only(top: 29),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                      ),
                      hintText: 'Cari Withdraw',
                      hintStyle: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontFamily: 'Euclid Circular B',
                        fontWeight: FontWeight.w400,
                        fontSize: 18.8304,
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(0.01),
                        margin: const EdgeInsets.only(bottom: 15.0),
                        child: Image.asset('assets/image/search-all.png'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                scrollingList(controller),
              ],
            );
          },
        ),
      ),
    );
  }

  Center body(BuildContext context) {
    return Center(
      child: Container(
        width: 345,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                blurRadius: 6.0,
                spreadRadius: 2.0,
                offset: Offset(0.0, 0.0),
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 322,
              height: 62,
              margin: const EdgeInsets.only(top: 26.88),
              child: SearchField<dynamic>(
                searchStyle: const TextStyle(
                    fontFamily: 'Euclid Circular B',
                    fontWeight: FontWeight.w600),
                searchInputDecoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                  ),
                  hintText: 'Cari Pengguna',
                  hintStyle: const TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontFamily: 'Euclid Circular B',
                    fontWeight: FontWeight.w400,
                    fontSize: 18.8304,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(0.01),
                    margin: const EdgeInsets.only(bottom: 15.0),
                    child: Image.asset('assets/image/search-all.png'),
                  ),
                ),
                suggestions: user
                    .map(
                      (e) => SearchFieldListItem(
                        e.nama,

                        item: e,
                        // Use child to show Custom Widgets in the suggestions
                        // defaults to Text widget
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.nama,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff222222),
                                          fontSize: 20,
                                          fontFamily: 'Euclid Circular B'),
                                    ),
                                    Text(
                                      e.no_hp,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xffbebebe),
                                          fontSize: 15,
                                          fontFamily: 'Euclid Circular B'),
                                    ),
                                  ])
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                controller: searchController,
                inputType: TextInputType.text,
                itemHeight: 80,
                validator: (x) {
                  if (x!.isEmpty || !containsUser(x)) {
                    return 'Please enter valid name';
                  } else {
                    return null;
                  }
                },
                onSuggestionTap: (SearchFieldListItem v) {
                  setState(() {
                    _selectedUsers = v.item!;
                  });
                },
              ),
            ),
            Container(
              width: 325,
              height: 81.51,
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.only(top: 18.58, left: 15.2),
              decoration: const BoxDecoration(
                  color: Color(0xFF7C81DF),
                  borderRadius: BorderRadius.all(Radius.circular(18.6053))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedUsers.nama ?? 'Nama',
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 17.7193,
                      fontFamily: 'Euclid Circular B',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3.82),
                  Text(
                    'DPID: ${_selectedUsers.no_hp ?? '000000000000'}',
                    style: const TextStyle(
                      color: Color(0xFFC5C7F1),
                      fontSize: 13.0526,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 312,
              height: 67.51,
              margin: const EdgeInsets.only(top: 38.61),
              child: TextField(
                controller: _withdrawcontrol,
                style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SF Pro Display',
                    color: Color(0xff222222)),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0.912281,
                      color: Color(0xFFC8BDBD),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(6.38596)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0.912281,
                      color: Color(0xFFC8BDBD),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(6.38596)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0.912281,
                      color: Color(0xFFC8BDBD),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(6.38596)),
                  ),
                  labelText: 'Nominal Top Up',
                  hintText: 'Rp0',
                  hintStyle: TextStyle(
                    color: Color(0xFFCAC5C5),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Display',
                    fontSize: 21.8947,
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFF8D8989),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Euclid Circular B',
                    fontSize: 17,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              width: 310,
              height: 60,
              margin: const EdgeInsets.only(top: 48),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    createWithdraw();
                    _withdrawcontrol.clear();
                  });
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF5258D4)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(6.59649))),
                  ),
                ),
                child: const Text(
                  'Withdraw',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'Euclid Circular B',
                    fontSize: 19.7895,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Visibility(
                visible: successWithdraw,
                child: Container(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/image/greensmile.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Withdraw Berhasil!',
                          style: TextStyle(
                              fontFamily: 'Euclid Circular B',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff52D47E)),
                        )
                      ],
                    ))),
            const SizedBox(
              height: 10,
            ),
            Visibility(
                visible: failedWithdraw,
                child: Container(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/image/failed.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Withdraw Gagal!',
                          style: TextStyle(
                              fontFamily: 'Euclid Circular B',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffEF3434)),
                        )
                      ],
                    )))
          ],
        ),
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
                  decoration: BoxDecoration(
                      color: const Color(0xff8A8EF9),
                      borderRadius: BorderRadius.circular(13)),
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

  Padding topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
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

  Widget scrollingList(ScrollController sc) {
    return Container(
      height: 450,
      margin: const EdgeInsets.only(top: 1),
      child: FutureBuilder(
        future: withdraw,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 200,
                          child: Text(
                            snapshot.data![i].penerima.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF172437),
                              fontFamily: 'Euclid Circular B',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          snapshot.data![i].created_at.toString(),
                          style: const TextStyle(
                            color: Color(0xFFBEBEBE),
                            fontFamily: 'Euclid Circular B',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 19.84),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        '-Rp${snapshot.data![i].nominal.toString()}',
                        style: const TextStyle(
                            color: Color(0xFF222222),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            fontFamily: 'SF Pro Display'),
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 40,
            ),
          );
        },
      ),
    );
  }

  Future<void> createWithdraw() async {
    final response = await http.post(
      Uri.parse('$url/admin/add-withdraw'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'admin_id': '1',
        'seller_id': '${_selectedUsers.id}',
        'nominal': _withdrawcontrol.text.toString(),
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        successWithdraw = true;
        failedWithdraw = false;
      });
    } else {
      successWithdraw = false;
      failedWithdraw = true;
    }
  }
}
