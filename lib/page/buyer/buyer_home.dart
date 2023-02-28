import 'dart:convert';
import 'dart:core';
import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:dreampay/page/buyer/qr_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

var url = dotenv.env['API_URL'];

Future<Saldo> fetchSaldo(String id) async {
  final response = await http.get(
    Uri.parse('${url}buyer/19'),
  );

  if (response.statusCode == 200) {
    return Saldo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Load');
  }
}

class Saldo {
  final dynamic saldo;
  final dynamic total_topup;
  final dynamic total_pengeluaran;

  const Saldo({
    required this.saldo,
    required this.total_topup,
    required this.total_pengeluaran,
  });

  factory Saldo.fromJson(Map<dynamic, dynamic> json) {
    return Saldo(
      saldo: json['saldo'],
      total_topup: json['total_topup'],
      total_pengeluaran: json['total_pengeluaran'],
    );
  }
}

Future<List<TopUp>> fetchTopUp(String id) async {
  final response = await http.get(
    Uri.parse('${url}buyer/19'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_topup'];
    return jsonResponse.map((e) => TopUp.fromJson(e)).toList();
  } else {
    throw Exception('Failed to Load');
  }
}

class TopUp {
  final dynamic id;
  final dynamic nota;
  final dynamic pengirim;
  final dynamic penerima;
  final dynamic nominal;
  final dynamic created_at;

  const TopUp({
    required this.id,
    required this.nota,
    required this.pengirim,
    required this.penerima,
    required this.nominal,
    required this.created_at,
  });

  factory TopUp.fromJson(Map<dynamic, dynamic> json) {
    return TopUp(
      id: json['id'],
      nota: json['nota'],
      pengirim: json['pengirim'],
      penerima: json['penerima'],
      nominal: json['nominal'],
      created_at: json['created_at'],
    );
  }
}

Future<List<Pengeluaran>> fetchPengeluaran(String id) async {
  final response = await http.get(
    Uri.parse('${url}/buyer/19'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_pengeluaran'];
    return jsonResponse.map((e) => Pengeluaran.fromJson(e)).toList();
  } else {
    throw Exception('Failed to Load');
  }
}
class Pengeluaran {
  final dynamic id;
  final dynamic nota;
  final dynamic pengirim;
  final dynamic penerima;
  final dynamic nominal;
  final dynamic created_at;

  const Pengeluaran({
    required this.id,
    required this.nota,
    required this.pengirim,
    required this.penerima,
    required this.nominal,
    required this.created_at,
  });

  factory Pengeluaran.fromJson(Map<dynamic, dynamic> json) {
    return Pengeluaran(
      id: json['id'],
      nota: json['nota'],
      pengirim: json['pengirim'],
      penerima: json['penerima'],
      nominal: json['nominal'],
      created_at: json['created_at'],
    );
  }}



class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({Key? key}) : super(key: key);


  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  bool showPull = false;
  bool showTopup = true;

  final List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "HEFTIVE"},
    {"id": 2, "name": "PASTRIP"},
    {"id": 3, "name": "DreamBoba"},
    {"id": 4, "name": "Aksesoris STFQ"},
  ];
  List<Map<String, dynamic>> _foundUsers = [];
   late Future<Saldo> _saldo;
   late Future<List<Pengeluaran>> _pengeluaran;
   late Future<List<TopUp>> _topup;

  @override
  initState() {
    hah();
    _foundUsers = _allUsers;
    _saldo = fetchSaldo('19');
    _topup = fetchTopUp('19');
    _pengeluaran = fetchPengeluaran('19');
    super.initState();
  }

  void hah() async {
    var dnsv;
    Future<SharedPreferences> preferences =  SharedPreferences.getInstance();
    preferences.then((value) {
      dnsv = value.getString('pin_customer');
    });

  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      _foundUsers = results;
    });
  }

  PanelController _panelController = PanelController();





  @override
  void togglePanel() => _panelController.isPanelOpen
      ? _panelController.close()
      : _panelController.open();

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      SlidingUpPanel(
        controller: _panelController,
        maxHeight: 450,
        minHeight: 200,
        padding: EdgeInsets.only(left: 30, right: 30),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        body: FutureBuilder(
          future: _saldo,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  height: 800,
                  decoration: const BoxDecoration(color: Color(0xFFFBFBFB)),
                  padding: const EdgeInsets.only(
                      right: 25, left: 25, top: 80, bottom: 74),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Assalamualaikum 👋',
                                style: TextStyle(
                                  fontFamily: 'Euclid Circular B',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xff777777),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 250,
                                child:Text(
                                  'Abi Ranop',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Euclid Circular B',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30,
                                    color: Color(0xff222222),
                                  ),
                                ),),
                            ],
                          ),
                          Column(children: <Widget>[
                            GestureDetector(
                              onTap : (){

                              },
                              child:Container(
                                width: 52,
                                height: 54,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    border:
                                    Border.all(width: 1, color: Color(0xffD2D2D2))),
                                child: TextButton(
                                  child: Image.asset('assets/image/logout.png'),
                                  onPressed: () {},
                                ),
                              ),),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Keluar',
                              style: TextStyle(
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffadadad)),
                            )
                          ])
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                          height: 172,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xffD7D0FF),
                              borderRadius: BorderRadius.circular(22)),
                          child: Column(children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Saldo Anda',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Euclid Circular B'),
                                ),
                                Image.asset('assets/image/wallet.png')
                              ],
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 17, top: 20),
                                width: 253,
                                height: 90,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                        AssetImage('assets/image/back_money.png'))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 45, left: 10),
                                          child: Text(
                                            'Rp',
                                            style: TextStyle(
                                                fontFamily: 'SF Pro Display',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.saldo.toString(),
                                          style: TextStyle(
                                              fontFamily: 'SF Pro Display',
                                              fontSize: 44,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ])),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Text(
                          'Riwayat',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              fontFamily: 'Euclid Circular B',
                              color: Color(0xff172437)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Saldo',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              fontFamily: 'Euclid Circular B',
                              color: Color(0xff172437)),
                        ),
                      ]),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          height: 165,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children:[
                                Container(
                                  padding: EdgeInsets.only(top: 15, right: 10, left: 10),
                                  width: 163,
                                  height: 164,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: Color(0xfffeedbb),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xffF4F0F0),
                                                borderRadius: BorderRadius.circular(12)),
                                            width: 33,
                                            height: 35,
                                            padding: EdgeInsets.all(5),
                                            child: Image.asset('assets/image/trans.png'),
                                          ),
                                          Text(
                                            'Pengeluaran',
                                            style: TextStyle(
                                                fontFamily: 'Euclid Circular B',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Color(0xff222222)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 35,
                                            ),
                                            child: Text(
                                              'Rp',
                                              style: TextStyle(
                                                  fontFamily: 'SF Pro Display',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff606060)),
                                            ),
                                          ),
                                          Text(
                                            '150,000',
                                            style: TextStyle(
                                                fontFamily: 'SF Pro Display',
                                                fontSize: 30,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xff222222)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showTopup = true;
                                              showPull = false;
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.only(left: 49, top: 5),
                                              width: double.infinity,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(27),
                                                  border: Border.all(
                                                      width: 1, color: Color(0xffBCBDC7))),
                                              child: Text(
                                                'Detail',
                                                style: TextStyle(
                                                    fontFamily: 'Euclid Circular B',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff606169)),
                                              )))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 15, right: 10, left: 10),
                                  width: 163,
                                  height: 164,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: Color(0xffB3B9F0),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(

                                            decoration: BoxDecoration(
                                                color: Color(0xffF4F0F0),
                                                borderRadius: BorderRadius.circular(12)),
                                            width: 33,
                                            height: 35,
                                            padding: EdgeInsets.all(5),
                                            child: Image.asset('assets/image/trans.png'),
                                          ),
                                          Text(
                                            'Isi Ulang',
                                            style: TextStyle(
                                                fontFamily: 'Euclid Circular B',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Color(0xff222222)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 35,
                                            ),
                                            child: Text(
                                              'Rp',
                                              style: TextStyle(
                                                  fontFamily: 'SF Pro Display',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff606060)),
                                            ),
                                          ),
                                          Text(
                                            '150,000',
                                            style: TextStyle(
                                                fontFamily: 'SF Pro Display',
                                                fontSize: 30,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xff222222)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showPull = true;
                                              showTopup = false;
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.only(left: 49, top: 5),
                                              width: double.infinity,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(27),
                                                  border: Border.all(
                                                      width: 1, color: Color(0xffDBDDF0))),
                                              child: Text(
                                                'Detail',
                                                style: TextStyle(
                                                    fontFamily: 'Euclid Circular B',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff606169)),
                                              )))
                                    ],
                                  ),
                                ),
                              ]))
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const Center(child: CircularProgressIndicator());
          },

        ) ,
        panelBuilder: (controller) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: togglePanel,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      height: 5,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade300),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                    visible: showTopup,
                    child: Column(children: [
                      Center(
                          child: Text(
                        'Detail Pengeluaran',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            fontFamily: 'Euclid Circular B',
                            color: Color(0xff172437)),
                      )),
                      TextField(
                        onChanged: (value) => _runFilter(value),
                        decoration: const InputDecoration(
                            labelText: 'Cari Transaksi',
                            labelStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Euclid Circular B',
                                color: Color(0xffbdbdbd)),
                            prefixIcon: Icon(Icons.search)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: SingleChildScrollView(
                              child: Container(
                        height: 290,
                        child: Column(children: [
                          Container(
                              height: 280,
                              child:FutureBuilder(
          future: _topup,
    builder: (context,snapshot){
            if (snapshot.hasData)
              {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, i) {
                      return Container(
                          height: 50,
                          child: Column(
                          children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data![i].pengirim,
                                    style: TextStyle(
                                        fontFamily:
                                        'Euclid Circular B',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    snapshot.data![i].created_at,
                                    style: TextStyle(
                                        fontFamily:
                                        'Euclid Circular B',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Color(0xffbebebe)),
                                  )
                                ],
                              ),
                              Text('+Rp ${snapshot.data![i].nominal}', style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 20,
                                  color: Color(0xff222222)
                              ),)
                            ],
                          ),
                          ])
                      );
                    }
              );

          }
          else if (snapshot.hasError) {
          return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },


          )

                        ),]
                      ))
                      )
                    )
          ]
          ),),
                Visibility(
                    visible: showPull,
                    child: Column(children: [
                      Center(
                          child: Text(
                        'Detail Isi Ulang',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            fontFamily: 'Euclid Circular B',
                            color: Color(0xff172437)),
                      )),
                      TextField(
                        onChanged: (value) => _runFilter(value),
                        decoration: const InputDecoration(
                            labelText: 'Cari Transaksi',
                            labelStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Euclid Circular B',
                                color: Color(0xffbdbdbd)),
                            prefixIcon: Icon(Icons.search)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: SingleChildScrollView(
                              child: Container(
                        height: 290,
                        child: Column(children: [
                          Container(
                              height: 280,
                              child: ListView(children: [
                                Container(
                                  height: 100,
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'HEFTIVE',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Euclid Circular B',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20),
                                              ),
                                              Text(
                                                'Produk',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Euclid Circular B',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    color: Color(0xffbebebe)),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ])),
                        ]),
                      )))
                    ]))
              ]);
        },
      ),

      Align(
        alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (c)=> QRPage()));
            },
              child:Container(
        margin: EdgeInsets.only(
       bottom: 20
        ),
        padding: EdgeInsets.only(left: 15),
        height: 70,
        width: 189,
        decoration: BoxDecoration(
          color: Color(0xffc1c1c1).withOpacity(0.6),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: <Widget>[

            Container(
              padding: EdgeInsets.all(10),
              width: 51,
              height: 51,
              decoration: BoxDecoration(
                  color: Color(0xffFCFAFA),
                  borderRadius: BorderRadius.circular(14)),
              child: Image.asset('assets/image/scan.png'),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Scan QR',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Euclid Circular B',
                  color: Color(0xff172437)),
            )
          ],
        ),
      ),
          ),
    )
    ]));
  }

}
