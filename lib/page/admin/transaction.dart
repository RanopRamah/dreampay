import 'dart:convert';

import 'package:dreampay/page/admin/make_account.dart';
import 'package:dreampay/page/admin/topup.dart';
import 'package:dreampay/page/admin/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var url = dotenv.env['API_URL'];

Future<List<Transactions>> fetchTransactions() async {
  final response = await http.get(
    Uri.parse('${url}admin/list-transaction'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_transaksi'];
    return jsonResponse.map((e) => Transactions.fromJson(e)).toList();
  } else {
    throw Exception(response.body);
  }
}

class Transactions {
  final dynamic id;
  final dynamic nota;
  final dynamic pengirim;
  final dynamic penerima;
  final dynamic nominal;
  final dynamic createdAt;

  const Transactions({
    required this.id,
    required this.nota,
    required this.pengirim,
    required this.penerima,
    required this.nominal,
    required this.createdAt,
  });

  factory Transactions.fromJson(Map<dynamic, dynamic> json) {
    return Transactions(
      id: json['id'],
      nota: json['nota'],
      pengirim: json['pengirim'],
      penerima: json['penerima'],
      nominal: json['nominal'],
      createdAt: json['created_at'],
    );
  }
}

class AdminTransactionPage extends StatefulWidget {
  const AdminTransactionPage({Key? key}) : super(key: key);

  @override
  State<AdminTransactionPage> createState() => _AdminTransactionPageState();
}

class _AdminTransactionPageState extends State<AdminTransactionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<Transactions>>? _transactionsList;

  String? phone;
  String? name;
  String? id;
  late SharedPreferences prefs;

  Future<void> setValue() async {
    _transactionsList = fetchTransactions();

    prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone_customer');
    name = prefs.getString('name_customer');
    id = prefs.getString('id_customer');
  }

  @override
  initState() {
    setValue();
    super.initState();
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
                      decoration: BoxDecoration(
                          color: const Color(0xff8A8EF9),
                          borderRadius: BorderRadius.circular(13)),
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
        body: SingleChildScrollView(
            child: Container(
                height: 1200,
                padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
                decoration: const BoxDecoration(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState?.openDrawer(),
                        child: Image.asset(
                          'assets/image/hamburger.png',
                          width: 35,
                          height: 27,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(top: 20, left: 15, right: 15),
                        width: double.infinity,
                        height: 900,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24)),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 4,
                              blurRadius: 4,
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              offset: Offset(0, 1),
                              blurStyle: BlurStyle.normal,
                            )
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Transaksi',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Euclid Circular B',
                                    color: Color(0xff222222)),
                              ),
                              FutureBuilder(
                                  future: _transactionsList,
                                  builder: (context, snapshot) {
                                    return SizedBox(
                                        height: 650,
                                        child: ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder:
                                              (BuildContext context, i) =>
                                                  Container(
                                            height: 174,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: const Color(0xfff3f3f3),
                                                borderRadius:
                                                    BorderRadius.circular(18)),
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            padding: const EdgeInsets.only(
                                                top: 25,
                                                bottom: 10,
                                                left: 30,
                                                right: 20),
                                            child: Column(
                                              children: <Widget>[
                                                const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Buyer',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Euclid Circular B',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color(
                                                              0xffa7a3a3)),
                                                    ),
                                                    Text(
                                                      'Merchant',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Euclid Circular B',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color(
                                                              0xffa7a3a3)),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 120,
                                                      child: Text(
                                                        snapshot
                                                            .data![i].pengirim
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'Euclid Circular B',
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xff222222)),
                                                      ),
                                                    ),
                                                    Image.asset(
                                                      'assets/image/trade.png',
                                                      width: 26,
                                                      height: 26,
                                                    ),
                                                    SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                          snapshot
                                                              .data![i].penerima
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.end,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Euclid Circular B',
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xff222222)),
                                                        ))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Amount',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Euclid Circular B',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                              0xff9B9B9B)),
                                                    ),
                                                    Text(
                                                      'Rp${snapshot.data![i].nominal}',
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'SF Pro Display',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Color(
                                                              0xff454649)),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Unique Code',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Euclid Circular B',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                              0xff9B9B9B)),
                                                    ),
                                                    Text(
                                                      snapshot.data![i].nota
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'SF Pro Display',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Color(
                                                              0xff454649)),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                  }),
                            ]),
                      )
                    ]))));
  }
}
