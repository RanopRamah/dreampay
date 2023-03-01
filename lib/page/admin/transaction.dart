import 'dart:convert';

import 'package:dreampay/page/admin/make_account.dart';
import 'package:dreampay/page/admin/topup.dart';
import 'package:dreampay/page/admin/transaction.dart';
import 'package:dreampay/page/admin/withdraw.dart';
import 'package:dreampay/page/buyer/buyer_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var url = dotenv.env['API_URL'];
Future<List<Transactions>> fetchTransactions() async {
  final response = await http.get(
    Uri.parse('${url}admin/list-transaction'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_transaksi'];
    print(jsonResponse);
    return jsonResponse.map((e) => Transactions.fromJson(e)).toList();
  } else {
    throw Exception('Failed to Load');
  }
}
class Transactions {
  final dynamic id;
  final dynamic nota;
  final dynamic pengirim;
  final dynamic penerima;
  final dynamic nominal;
  final dynamic created_at;

  const Transactions({
    required this.id,
    required this.nota,
    required this.pengirim,
    required this.penerima,
    required this.nominal,
    required this.created_at,
  });

  factory Transactions.fromJson(Map<dynamic, dynamic> json) {
    return Transactions(
      id: json['id'],
      nota: json['nota'],
      pengirim: json['pengirim'],
      penerima: json['penerima'],
      nominal: json['nominal'],
      created_at: json['created_at'],
    );
  }
}

class AdminTransactionPage extends StatefulWidget {
  AdminTransactionPage({Key? key}) : super(key: key);

  @override
  State<AdminTransactionPage> createState() => _AdminTransactionPageState();
}

class _AdminTransactionPageState extends State<AdminTransactionPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PanelController _panelController = PanelController();

  final List<Map<String, dynamic>> _allUsers = [
    {
      "id": 1,
      "buyer": "Abi Royyan",
      "seller": "HEFTIVE",
      "uc": "62876545678",
      "amount": "Rp25,000"
    },
    {"id": 2,
      "buyer": "Abi Royyan",
      "seller": "PASTRIP",
      "uc": "62234567758",
      "amount": "Rp25,000"
    },
    {
      "id": 3,
      "buyer": "Abi Royyan",
      "seller": "DreamBoba",
      "uc": "62876587683",
      "amount": "Rp25,000"
    },
    {
      "id": 4,
      "buyer": "Abi Royyan",
      "seller": "Aksesoris STFQ",
      "uc": "628765123478",
      "amount": "Rp25,000"
    },
    {"id": 5, "buyer": "Abi Royyan", "seller": "Akae", "uc": "628765123478",
      "amount": "Rp25,000"},
    {
      "id": 6,
      "buyer": "Abi Royyan",
      "seller": "Kopi 3B",
      "uc": "628765123478",
      "amount": "Rp25,000"
    },
    {
      "id": 7,
      "buyer": "Abi Royyan",
      "seller": "WINDOA",
      "uc": "628765123478",
    "amount": "Rp25,000"
    },
  ];
  late Future<List<Transactions>> transactionsList;

  @override
  initState() {
   transactionsList = fetchTransactions();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: Container(
            padding: EdgeInsets.all(20),
            color: Color(0xff45499D),
            child: ListView(
              children: <Widget>[
                Container(
                  width: 170,
                  height: 42,
                  child: Image.asset('assets/image/logo.png'),
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => MakeAccountPage()));
                    },
                    title: Container(
                      padding: EdgeInsets.only(right: 30, left: 40),
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
                          SizedBox(
                            width: 10,
                          ),
                          Text(

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
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => AdminTransactionPage()));
                    },
                    title: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff8A8EF9),
                          borderRadius: BorderRadius.circular(13)),
                      padding: EdgeInsets.only(right: 25, left: 25),
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
                          Text(
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
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) => AdminTopupPage()));
                    },
                    title: Container(
                      padding: EdgeInsets.only(right: 45, left: 25),
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
                          Text(
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
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => AdminWithdrawPage()));
                    },
                    title: Container(
                      padding: EdgeInsets.only(right: 25, left: 27),
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
                          Text(
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
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  width: double.infinity,
                  height: 98,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff292B5A)),
                  child: Column(
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
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  width: double.infinity,
                  height: 98,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff3A2C62)),
                  child: Column(
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
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  width: double.infinity,
                  height: 98,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff2E3346)),
                  child: Column(
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
                SizedBox(
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: Image.asset(
                'assets/image/hamburger.png',
                width: 35,
                height: 27,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(top: 20,left: 15,right: 15),
                width: double.infinity,
                height: 900,
                decoration: BoxDecoration(
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
                    Text(
                      'Transaksi',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Euclid Circular B',
                          color: Color(0xff222222)),
                    ),
FutureBuilder(
  future: transactionsList,
    builder: (context, snapshot) {
  return Container(
      height: 650,
      child: ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (BuildContext context, i) => Container(
          height: 174,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xfff3f3f3),
              borderRadius: BorderRadius.circular(18)),
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.only(
              top: 25, bottom: 10, left: 30, right: 20),

          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Buyer',style: TextStyle(
                      fontFamily: 'Euclid Circular B',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffa7a3a3)
                  ),),
                  Text('Merchant', style: TextStyle(
                      fontFamily: 'Euclid Circular B',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffa7a3a3)
                  ),)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 120,
                    child:
                  Text(snapshot.data![i].pengirim.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Euclid Circular B',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff222222 )
                  ),),),
                  Image.asset('assets/image/trade.png',width: 26,height: 26,),
                  Container(
                      width :100,
                      child:Text(snapshot.data![i].penerima.toString(),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Euclid Circular B',
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff222222)
                        ),))
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount',style: TextStyle(
                      fontFamily: 'Euclid Circular B',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff9B9B9B )
                  ),),


                  Text('Rp${snapshot.data![i].nominal}',

                    style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff454649)
                    ),)
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Unique Code',style: TextStyle(
                      fontFamily: 'Euclid Circular B',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff9B9B9B )
                  ),),


                  Text(snapshot.data![i].nota.toString(),

                    style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff454649)
                    ),)
                ],
              )
            ],
          ),
        ),
      ));
}),



              ]),
       )])
    )
    )
    );
  }
}
