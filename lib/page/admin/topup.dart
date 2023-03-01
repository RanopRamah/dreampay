import 'dart:convert';
import 'dart:async';

import 'package:dreampay/page/admin/make_account.dart';
import 'package:dreampay/page/admin/transaction.dart';
import 'package:dreampay/page/admin/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchfield/searchfield.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var url = dotenv.env['API_URL'];
Future<List> fetchUsers() async {
  final response = await http.get(
    Uri.parse('${url}admin/list-topup'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['list_buyer'];
  } else {
    throw Exception('Failed to Load');
  }
}

Future<List<TopUp>> fetchTopUp() async {
  final response = await http.get(
    Uri.parse('${url}admin/list-topup'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_topup'];
    return jsonResponse.map((e) => TopUp.fromJson(e)).toList();
  } else {
    throw Exception('Failed to Load');
  }
}

class Users {
  final dynamic id;
  final dynamic nama;
  final dynamic noHp;

  const Users({required this.id, required this.nama, required this.noHp});

  Users.init()
      : id = 0,
        nama = 'somebody',
        noHp = '00000000000';

  Users.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'] as int,
        nama = map['nama'] as String,
        noHp = map['noHp'] as String;

  factory Users.fromJson(Map<dynamic, dynamic> json) {
    return Users(
      id: json['id'],
      nama: json['nama'],
      noHp: json['noHp'],
    );
  }
}

class TopUp {
  final dynamic id;
  final dynamic pengirim;
  final dynamic penerima;
  final dynamic nominal;
  final dynamic createdAt;

  const TopUp({
    required this.id,
    required this.pengirim,
    required this.penerima,
    required this.nominal,
    required this.createdAt,
  });

  factory TopUp.fromJson(Map<dynamic, dynamic> json) {
    return TopUp(
      id: json['id'],
      pengirim: json['pengirim'],
      penerima: json['penerima'],
      nominal: json['nominal'],
      createdAt: json['createdAt'],
    );
  }
}

class AdminTopupPage extends StatefulWidget {
  const AdminTopupPage({Key? key}) : super(key: key);

  @override
  State<AdminTopupPage> createState() => _AdminTopupPageState();
}

class _AdminTopupPageState extends State<AdminTopupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();

  TextEditingController _topupcontrol = TextEditingController();

  List<Users> user = [];
  Users _selectedUsers = Users.init();

  bool showPull = false;
  bool showTopup = true;
  bool visible = false;
  bool isSuccessful = false;

  final PanelController _controller = PanelController();
  late Future<List<TopUp>> topup;

  @override
  void initState() {
    super.initState();
    dvs();
    topup = fetchTopUp();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void togglePanel() {
    _controller.isPanelOpen ? _controller.close() : _controller.open();
  }

  void dvs() async {
    List<dynamic> data = await fetchUsers();
    user = data.map((e) => Users.fromJson(e)).toList();
    //
    // var h = user.map((e) => e.nama);
    // print(h);
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
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (c) => MakeAccountPage()));
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
                    decoration: BoxDecoration(
                        color: const Color(0xff8A8EF9),
                        borderRadius: BorderRadius.circular(13)),
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
        controller: _controller,
        maxHeight: 590,
        minHeight: 150,
        padding: const EdgeInsets.only(left: 30, right: 30),
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFDFDFD),
          ),
          padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Image.asset(
                      'assets/image/hamburger.png',
                      width: 35,
                      height: 27,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 55),
              Center(
                child: Container(
                  width: 345,
                  height: 485,
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
                        child: SearchField(
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
                              .map((e) => SearchFieldListItem(e.nama, item: e))
                              .toList(),
                          suggestionState: Suggestion.hidden,
                          controller: searchController,
                          inputType: TextInputType.text,
                          itemHeight: 40,
                          validator: (x) {
                            if (x!.isEmpty || !containsUser(x)) {
                              return 'Please enter valid name';
                            } else {
                              return null;
                            }
                          },
                          onSuggestionTap: (SearchFieldListItem<Users> x) {
                            setState(() {
                              _selectedUsers = x.item!;
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(18.6053))),
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
                              'DPID: ${_selectedUsers.noHp ?? '000000000000'}',
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
                          controller: _topupcontrol,
                          style: TextStyle(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.38596)),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.912281,
                                color: Color(0xFFC8BDBD),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.38596)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.912281,
                                color: Color(0xFFC8BDBD),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.38596)),
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
                              createTopup();
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF5258D4)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(6.59649))),
                            ),
                          ),
                          child: const Text(
                            'Top-Up',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'Euclid Circular B',
                              fontSize: 19.7895,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Visibility(
                          visible: visible,
                          child: Image.asset(
                            (isSuccessful)
                                ? 'assets/image/success-topup.png'
                                : 'assets/image/failed-topup.png',
                            width: 153,
                            height: 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        panelBuilder: (controller) {
          return Column(
            children: [
              GestureDetector(
                onTap: togglePanel,
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
                  'Riwayat Top-Up',
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
                  controller: _topupcontrol,
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
                    hintText: 'Cari Top-Up',
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
    );
  }

  Widget scrollingList(ScrollController sc) {
    return Container(
      height: 450,
      margin: const EdgeInsets.only(top: 1),
      child: FutureBuilder(
        future: topup,
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
                          snapshot.data![i].createdAt,
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
                        'Rp${snapshot.data![i].nominal.toString()}',
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

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> createTopup() async {
    final response = await http.post(
      Uri.parse('${url}admin/add-topup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'admin_id': '1',
        'buyer_id': '${_selectedUsers.id}',
        'nominal': _topupcontrol.text.toString(),
      }),
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const AdminTopupPage()),
          (route) => false);
    } else {
      throw Exception(response.body);
    }
  }
}
