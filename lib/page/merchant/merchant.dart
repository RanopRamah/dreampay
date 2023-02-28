import 'package:dreampay/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:badges/badges.dart' as badges;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';

import 'package:signed_spacing_flex/signed_spacing_flex.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
var url = dotenv.env['API_URL'];

Future<Seller> fetchSeller(String id_seller) async {
  print(id_seller);
  final response = await http.get(
    Uri.parse('${url}seller/$id_seller'),
  );

  if (response.statusCode == 200) {
    return Seller.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Fetch');
  }
}
Future<List<Detail>> fetchDetail(String id) async {
  final response = await http.get(
    Uri.parse('${url}seller/$id'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_pemasukan'];
    return jsonResponse.map((e) => Detail.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load');
  }
}

class Seller {
  final dynamic qrcode;
  final dynamic saldo;
  final dynamic pemasukan;
  final dynamic penarikan;

  const Seller({
    required this.qrcode,
    required this.saldo,
    required this.pemasukan,
    required this.penarikan,
  });

  factory Seller.fromJson(Map<dynamic, dynamic> json) {
    return Seller(
      qrcode: json['qrcode'],
      saldo: json['saldo'],
      pemasukan: json['pemasukan'],
      penarikan: json['pemasukan'],
    );
  }
}
class Detail {
  final dynamic pengirim;
  final dynamic created_at;
  final dynamic nominal;

  const Detail({
    required this.pengirim,
    required this.created_at,
    required this.nominal,
  });

  factory Detail.fromJson(Map<dynamic, dynamic> json) {
    return Detail(
      pengirim: json['pengirim'],
      created_at: json['created_at'],
      nominal: json['nominal'],
    );
  }
}

class MerchantPage extends StatefulWidget {
  const MerchantPage({Key? key}) : super(key: key);

  @override
  State<MerchantPage> createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  PanelController _panelController = PanelController();
  bool showPull = false;
  bool showTopup = true;

  String? phone;
  String? name;
  String? id;

  late Future<Seller> _seller;
  late Future<List<Detail>> _detail;
  late SharedPreferences prefs;

  Future<void> setValue() async {
    prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone_customer') ?? '111';
    name = prefs.getString('name_customer') ?? 'id';
    id = prefs.getString('id_customer') ?? '';

    _seller = fetchSeller(id.toString());
    _detail = fetchDetail(id.toString());
  }

  @override
  void initState() {
    setValue();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
      controller: _panelController,
      maxHeight: 450,
      minHeight: 80,
      padding: EdgeInsets.only(left: 30, right: 30),
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      body: SingleChildScrollView(
    child:Container(
    height: 900,
        decoration: const BoxDecoration(color: Color(0xFFFBFBFB)),
        padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 47,
                        height: 47,
                        decoration: BoxDecoration(
                            color: Color(0xfff6f6f6),
                            borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.all(10),
                        child: Image.asset('assets/image/shop.png'),
                      ),
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
                            width: 200,
                            height: 40,
                            child: Text(
                              name.toString(),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                                color: Color(0xff222222),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(children: <Widget>[
                    Container(
                      width: 52,
                      height: 54,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border:
                              Border.all(width: 1, color: Color(0xffD2D2D2))),
                      child: TextButton(
                        child: Image.asset('assets/image/logout.png'),
                        onPressed: () {
                          setState(() {
                            prefs.remove('id_customer');
                            prefs.remove('phone_customer');
                            prefs.remove('name_customer');
                            prefs.remove('pin_customer');
                            prefs.remove('type_customer');
                            prefs.remove('is_login');
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => LoginPage()), (route) => false);
                          });
                        },
                      ),
                    ),
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
                height: 20,
              ),
             FutureBuilder(
               future: _seller,
               builder: (context, snapshot) {
                 if (snapshot.hasData) {
                   return SignedSpacingColumn(
                       spacing: -70.0,
                       stackingOrder: StackingOrder.lastOnTop,
                       children: <Widget>[
                         Container(
                           padding: EdgeInsets.only(top: 20, left: 45, right: 45),
                           width: double.infinity,
                           height: 417,
                           decoration: BoxDecoration(
                               color: Color(0xff5258D4),
                               borderRadius: BorderRadius.circular(14)),
                           child: Column(
                             children: <Widget>[
                               Text(
                                 name.toString(),
                                 style: TextStyle(
                                     fontSize: 24,
                                     fontFamily: 'Euclid Circular B',
                                     fontWeight: FontWeight.w600,
                                     color: Colors.white),
                               ),
                               SizedBox(
                                 height: 5,
                               ),
                               Text(
                                 'DPID: ${phone.toString()}',
                                 style: TextStyle(
                                     fontSize: 16,
                                     fontFamily: 'SF Pro Display',
                                     fontWeight: FontWeight.w500,
                                     color: Colors.white),
                               ),
                               SizedBox(
                                 height: 15,
                               ),
                               Container(
                                 width: double.infinity,
                                 height: 241,
                                 decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(36)),
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: QrImage(
                                     data: snapshot.data!.qrcode.toString(),
                                     version: QrVersions.auto,
                                     size: 170,
                                   ),
                                 )
                               )
                             ],
                           ),
                         ),
                         Container(
                           padding: EdgeInsets.only(top: 20, left: 13, right: 13),
                           width: double.infinity,
                           height: 244,
                           decoration: BoxDecoration(
                             color: Color(0xffD7D0FF),
                             borderRadius: BorderRadius.circular(35),
                           ),
                           child: Column(
                             children: <Widget>[
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Row(
                                     children: <Widget>[
                                       Text(
                                         'Saldo',
                                         style: TextStyle(
                                             fontWeight: FontWeight.w600,
                                             fontSize: 24,
                                             fontFamily: 'Euclid Circular B',
                                             color: Color(0xff172437)),
                                       ),
                                       SizedBox(
                                         width: 5,
                                       ),
                                       Text(
                                         'Toko',
                                         style: TextStyle(
                                             fontWeight: FontWeight.w500,
                                             fontSize: 24,
                                             fontFamily: 'Euclid Circular B',
                                             color: Color(0xff172437)),
                                       ),
                                     ],
                                   ),
                                   badges.Badge(
                                     position: badges.BadgePosition.topStart(
                                       top: -15,
                                     ),
                                     badgeContent: Image.asset(
                                       'assets/image/shop.png',
                                       width: 16,
                                       height: 16,
                                     ),
                                     badgeStyle: badges.BadgeStyle(
                                         padding: EdgeInsets.all(5),
                                         badgeColor: Colors.white),
                                     child: Container(
                                       padding: EdgeInsets.only(left: 12, top: 5),
                                       width: 124,
                                       height: 48,
                                       decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(15),
                                           image: DecorationImage(
                                               image: AssetImage(
                                                   'assets/image/back_money2.png'))),
                                       child: Row(
                                         children: <Widget>[
                                           Padding(
                                             padding: EdgeInsets.only(bottom: 20),
                                             child: Text(
                                               'Rp',
                                               style: TextStyle(
                                                   fontFamily: 'SF Pro Display',
                                                   fontSize: 9,
                                                   fontWeight: FontWeight.w400,
                                                   color: Colors.white),
                                             ),
                                           ),
                                           Text(
                                             snapshot.data!.saldo.toString(),
                                             style: TextStyle(
                                                 fontFamily: 'SF Pro Display',
                                                 fontSize: 21,
                                                 fontWeight: FontWeight.w700,
                                                 color: Colors.white),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(
                                 height: 10,
                               ),
                               Container(
                                   height: 141,
                                   child: ListView(
                                     scrollDirection: Axis.horizontal,
                                     children: <Widget>[
                                       Container(
                                         padding: EdgeInsets.only(
                                             top: 10, right: 10, left: 10),
                                         width: 147,
                                         height: 140,
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(22),
                                           color: Color(0xffB3B9F0),
                                         ),
                                         child: Column(
                                           children: <Widget>[
                                             Row(
                                               mainAxisAlignment:
                                               MainAxisAlignment.spaceBetween,
                                               children: <Widget>[
                                                 Container(
                                                   padding: EdgeInsets.all(5),
                                                   decoration: BoxDecoration(
                                                       color: Color(0xffF4F0F0),
                                                       borderRadius:
                                                       BorderRadius.circular(12)),
                                                   width: 31,
                                                   height: 33,
                                                   child: Image.asset(
                                                       'assets/image/trans.png'),
                                                 ),
                                                 Text(
                                                   'Pemasukan',
                                                   style: TextStyle(
                                                       fontFamily: 'Euclid Circular B',
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 15,
                                                       color: Color(0xff222222)),
                                                 )
                                               ],
                                             ),
                                             SizedBox(
                                               height: 5,
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
                                                         fontSize: 10,
                                                         fontWeight: FontWeight.w400,
                                                         color: Color(0xff606060)),
                                                   ),
                                                 ),
                                                 Text(
                                                   snapshot.data!.pemasukan.toString(),
                                                   style: TextStyle(
                                                       fontFamily: 'SF Pro Display',
                                                       fontSize: 26,
                                                       fontWeight: FontWeight.w700,
                                                       color: Color(0xff222222)),
                                                 ),
                                               ],
                                             ),
                                             SizedBox(
                                               height: 5,
                                             ),
                                             GestureDetector(
                                                 onTap: () {
                                                   setState(() {
                                                     showPull = true;
                                                     showTopup = false;
                                                   });
                                                 },
                                                 child: Container(
                                                     padding: EdgeInsets.only(
                                                         left: 49, top: 5),
                                                     width: double.infinity,
                                                     height: 28,
                                                     decoration: BoxDecoration(
                                                         borderRadius:
                                                         BorderRadius.circular(27),
                                                         border: Border.all(
                                                             width: 1,
                                                             color: Color(0xffDBDDF0))),
                                                     child: Text(
                                                       'Detail',
                                                       style: TextStyle(
                                                           fontFamily:
                                                           'Euclid Circular B',
                                                           fontSize: 15,
                                                           fontWeight: FontWeight.w400,
                                                           color: Color(0xff606169)),
                                                     )))
                                           ],
                                         ),
                                       ),
                                       SizedBox(
                                         width: 8,
                                       ),
                                       Container(
                                         padding: EdgeInsets.only(
                                             top: 10, right: 10, left: 10),
                                         width: 147,
                                         height: 140,
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(22),
                                           color: Color(0xffF17996),
                                         ),
                                         child: Column(
                                           children: <Widget>[
                                             Row(
                                               mainAxisAlignment:
                                               MainAxisAlignment.spaceBetween,
                                               children: <Widget>[
                                                 Container(
                                                   padding: EdgeInsets.all(5),
                                                   decoration: BoxDecoration(
                                                       color: Color(0xffF4F0F0),
                                                       borderRadius:
                                                       BorderRadius.circular(12)),
                                                   width: 31,
                                                   height: 33,
                                                   child: Image.asset(
                                                       'assets/image/trans.png'),
                                                 ),
                                                 Text(
                                                   'Penarikan',
                                                   style: TextStyle(
                                                       fontFamily: 'Euclid Circular B',
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 15,
                                                       color: Color(0xff222222)),
                                                 )
                                               ],
                                             ),
                                             SizedBox(
                                               height: 5,
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
                                                         fontSize: 10,
                                                         fontWeight: FontWeight.w400,
                                                         color: Color(0xff606060)),
                                                   ),
                                                 ),
                                                 Text(
                                                   snapshot.data!.penarikan.toString(),
                                                   style: TextStyle(
                                                       fontFamily: 'SF Pro Display',
                                                       fontSize: 26,
                                                       fontWeight: FontWeight.w700,
                                                       color: Color(0xff222222)),
                                                 ),
                                               ],
                                             ),
                                             SizedBox(
                                               height: 5,
                                             ),
                                             GestureDetector(
                                                 onTap: () {
                                                   setState(() {
                                                     showTopup = true;
                                                     showPull = false;
                                                   });
                                                 },
                                                 child: Container(
                                                     padding: EdgeInsets.only(
                                                         left: 49, top: 5),
                                                     width: double.infinity,
                                                     height: 28,
                                                     decoration: BoxDecoration(
                                                         borderRadius:
                                                         BorderRadius.circular(27),
                                                         border: Border.all(
                                                             width: 1,
                                                             color: Color(0xffDBDDF0))),
                                                     child: Text(
                                                       'Detail',
                                                       style: TextStyle(
                                                           fontFamily:
                                                           'Euclid Circular B',
                                                           fontSize: 15,
                                                           fontWeight: FontWeight.w400,
                                                           color: Color(0xff606169)),
                                                     )))
                                           ],
                                         ),
                                       ),
                                     ],
                                   )
                               )
                             ],

                           ),
                         )
                       ]);
                 } else if (snapshot.hasError) {
                   return Text('${snapshot.error}');
                 }
                 return const Center(child: CircularProgressIndicator());
               },
             )
            ])),
      ),),
      panelBuilder: (controller) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                // onTap: togglePanel,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 5,
                    width: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade300),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Visibility(
                  visible: showTopup,
                  child: Expanded(
                    child: Column(
                        children: [
                      Center(
                          child: Text(
                            'Detail Pemasukan',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                fontFamily: 'Euclid Circular B',
                                color: Color(0xff172437)),
                          )),
                      TextField(
                        // onChanged: (value) => _runFilter(value),
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
                      FutureBuilder(
                        future: _detail,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (ctx, i) {
                                return Container(
                                    height: 50,
                                    margin: const EdgeInsets.only(bottom: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 30,
                                              width: 170,
                                              child: Text(
                                                snapshot.data![i].pengirim,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: 'Euclid Circular B',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Text(
                                              snapshot.data![i].created_at,
                                              style: TextStyle(
                                                  fontFamily: 'Euclid Circular B',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Color(0xffbebebe)),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '-Rp${snapshot.data![i].nominal.toString()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Euclid Circular B',
                                              fontSize: 20,
                                              color: Color(0xff222222)),
                                        )
                                      ],
                                    ));
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ]),
                  )),
              Visibility(
                  visible: showPull,
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
                      // onChanged: (value) => _runFilter(value),
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
    ));
  }
}
