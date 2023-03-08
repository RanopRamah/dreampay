import 'dart:convert';
import 'dart:core';
import 'package:dreampay/page/buyer/home/qr_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'api/saldo.dart';
import 'api/expenditure.dart';
import 'api/topup.dart';
import '../../login_page.dart';



// WIDGET
class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({Key? key}) : super(key: key);

  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  bool showPull = true;
  bool showTopup = false;

  List<dynamic> _filteredPengeluaran = [];
  List<dynamic> _filteredTopup = [];

  Future<Saldo>? _saldo;

  @override
  initState() {
    setValue();

    super.initState();
  }

  late SharedPreferences prefs;
  String? phone;
  String? name;
  String? id;

  Future<void> setValue() async {
    prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone_customer');
    name = prefs.getString('name_customer');
    id = prefs.getString('id_customer');

    setState(() {
      _saldo = fetchSaldo(id.toString());
    });
  }

  final PanelController _panelController = PanelController();

  void togglePanel() => _panelController.isPanelOpen
      ? _panelController.close()
      : _panelController.open();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: setValue,
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                SlidingUpPanel(
                  controller: _panelController,
                  maxHeight: 450,
                  minHeight: 200,
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  body: FutureBuilder(
                    future: _saldo,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Container(
                            height: 800,
                            decoration:
                                const BoxDecoration(color: Color(0xFFFBFBFB)),
                            padding: const EdgeInsets.only(
                                right: 25, left: 25, top: 80, bottom: 74),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Text(
                                          'Assalamualaikum 👋',
                                          style: TextStyle(
                                            fontFamily: 'Euclid Circular B',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xff777777),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            name.toString(),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: 'Euclid Circular B',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30,
                                              color: Color(0xff222222),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(children: <Widget>[
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 52,
                                          height: 54,
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                              border: Border.all(
                                                  width: 1,
                                                  color:
                                                      const Color(0xffD2D2D2))),
                                          child: TextButton(
                                            child: Image.asset(
                                                'assets/image/logout.png'),
                                            onPressed: () {
                                              setState(() {
                                                prefs.remove('id_customer');
                                                prefs.remove('phone_customer');
                                                prefs.remove('name_customer');
                                                prefs.remove('pin_customer');
                                                prefs.remove('type_customer');
                                                prefs.remove('is_login');
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (ctx) =>
                                                                const LoginPage()),
                                                        (route) => false);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
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
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 30, right: 30),
                                    height: 172,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffD7D0FF),
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                    child: Column(children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text(
                                            'Saldo Anda',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'Euclid Circular B'),
                                          ),
                                          Image.asset('assets/image/wallet.png')
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 22,
                                      ),
                                      Container(
                                          padding: const EdgeInsets.only(
                                              left: 17, top: 20),
                                          width: 253,
                                          height: 90,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/image/back_money.png'))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 45, left: 10),
                                                    child: Text(
                                                      'Rp',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'SF Pro Display',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 180,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        snapshot.data!.saldo
                                                            .toString(),
                                                        // 'tes',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'SF Pro Display',
                                                            fontSize: 32,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ])),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(children: const <Widget>[
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
                                const SizedBox(
                                  height: 15,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    height: 165,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 15, right: 10, left: 10),
                                          width: 170,
                                          height: 164,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            color: const Color(0xfffeedbb),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffF4F0F0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                    width: 33,
                                                    height: 35,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Image.asset(
                                                        'assets/image/trans.png'),
                                                  ),
                                                  const Text(
                                                    'Pengeluaran',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xff222222)),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: 35,
                                                    ),
                                                    child: Text(
                                                      'Rp',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'SF Pro Display',
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color(
                                                              0xff606060)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        snapshot.data!
                                                            .totalPengeluaran
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'SF Pro Display',
                                                            fontSize: 27,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Color(
                                                                0xff222222)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      showTopup = false;
                                                      showPull = true;
                                                    });
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 49, top: 5),
                                                      width: double.infinity,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(27),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: const Color(
                                                                  0xffBCBDC7))),
                                                      child: const Text(
                                                        'Detail',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Euclid Circular B',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                0xff606169)),
                                                      )))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 15, right: 10, left: 10),
                                          width: 170,
                                          height: 164,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            color: const Color(0xffB3B9F0),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffF4F0F0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                    width: 33,
                                                    height: 35,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Image.asset(
                                                        'assets/image/trans.png'),
                                                  ),
                                                  const Text(
                                                    'Isi Ulang',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Euclid Circular B',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xff222222)),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: 35,
                                                    ),
                                                    child: Text(
                                                      'Rp',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'SF Pro Display',
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color(
                                                              0xff606060)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 110,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        snapshot
                                                            .data!.totalTopup
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'SF Pro Display',
                                                            fontSize: 28,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Color(
                                                                0xff222222)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 49, top: 5),
                                                      width: double.infinity,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(27),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: const Color(
                                                                  0xffDBDDF0))),
                                                      child: const Text(
                                                        'Detail',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Euclid Circular B',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                0xff606169)),
                                                      )))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.black,
                              size: 40,
                            ))
                          ]);
                    },
                  ),
                  panelBuilder: (controller) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: togglePanel,
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 15),
                                height: 5,
                                width: 90,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: showPull,
                            child: Column(children: [
                              const Center(
                                  child: Text(
                                'Detail Pengeluaran',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    fontFamily: 'Euclid Circular B',
                                    color: Color(0xff172437)),
                              )),
                              TextField(
                                onChanged: (value) async {
                                  final data =
                                      await fetchPengeluaran(id.toString());
                                  setState(() {
                                    _filteredPengeluaran = data
                                        .where((item) => item.penerima
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
                              const SizedBox(
                                height: 20,
                              ),
                              SingleChildScrollView(
                                  child: SizedBox(
                                      height: 290,
                                      child: Column(children: [
                                        SizedBox(
                                            height: 280,
                                            child: FutureBuilder(
                                              future: fetchPengeluaran(
                                                  id.toString()),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return ListView.builder(
                                                      itemCount:
                                                          _filteredPengeluaran
                                                                  .isNotEmpty
                                                              ? _filteredPengeluaran
                                                                  .length
                                                              : snapshot
                                                                  .data!.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              i) {
                                                        return SizedBox(
                                                            height: 50,
                                                            child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          SizedBox(
                                                                            width:
                                                                                200,
                                                                            child:
                                                                                Text(
                                                                              _filteredPengeluaran.isNotEmpty ? _filteredPengeluaran[i].penerima : snapshot.data![i].penerima,
                                                                              style: const TextStyle(overflow: TextOverflow.ellipsis, fontFamily: 'Euclid Circular B', fontWeight: FontWeight.w600, fontSize: 20),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            _filteredPengeluaran.isNotEmpty
                                                                                ? _filteredPengeluaran[i].createdAt
                                                                                : snapshot.data![i].createdAt,
                                                                            style: const TextStyle(
                                                                                fontFamily: 'Euclid Circular B',
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 16,
                                                                                color: Color(0xffbebebe)),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            110,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Text(
                                                                            _filteredPengeluaran.isNotEmpty
                                                                                ? '-Rp ${_filteredPengeluaran[i].nominal}'
                                                                                : '-Rp ${snapshot.data![i].nominal}',
                                                                            // '-Rp ${snapshot.data![i].nominal}',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontFamily: 'Euclid Circular B',
                                                                                fontSize: 20,
                                                                                color: Color(0xff222222)),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ]));
                                                      });
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      '${snapshot.error}');
                                                }

                                                return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                          child: LoadingAnimationWidget
                                                              .staggeredDotsWave(
                                                        color: Colors.black,
                                                        size: 40,
                                                      ))
                                                    ]);
                                              },
                                            )),
                                      ])))
                            ]),
                          ),
                          Visibility(
                            visible: showTopup,
                            child: Column(children: [
                              const Center(
                                  child: Text(
                                'Detail Topup',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    fontFamily: 'Euclid Circular B',
                                    color: Color(0xff172437)),
                              )),
                              TextField(
                                onChanged: (value) async {
                                  // filter list berdasarkan input pengguna
                                  final data = await fetchTopup(id.toString());
                                  setState(() {
                                    _filteredTopup = data
                                        .where((item) => item.pengirim
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
                              const SizedBox(
                                height: 20,
                              ),
                              SingleChildScrollView(
                                  child: SizedBox(
                                      height: 290,
                                      child: Column(children: [
                                        SizedBox(
                                            height: 280,
                                            child: FutureBuilder(
                                              future: fetchTopup(id.toString()),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return ListView.builder(
                                                      itemCount: _filteredTopup
                                                              .isNotEmpty
                                                          ? _filteredTopup
                                                              .length
                                                          : snapshot
                                                              .data!.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              i) {
                                                        return SizedBox(
                                                            height: 50,
                                                            child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          SizedBox(
                                                                            width:
                                                                                200,
                                                                            child:
                                                                                Text(
                                                                              _filteredTopup.isNotEmpty ? _filteredTopup[i].pengirim : snapshot.data![i].pengirim,
                                                                              style: const TextStyle(overflow: TextOverflow.ellipsis, fontFamily: 'Euclid Circular B', fontWeight: FontWeight.w600, fontSize: 20),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            _filteredTopup.isNotEmpty
                                                                                ? _filteredTopup[i].createdAt
                                                                                : snapshot.data![i].createdAt,
                                                                            style: const TextStyle(
                                                                                fontFamily: 'Euclid Circular B',
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 16,
                                                                                color: Color(0xffbebebe)),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            110,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Text(
                                                                            _filteredTopup.isNotEmpty
                                                                                ? '+Rp ${_filteredTopup[i].nominal}'
                                                                                : '+RP ${snapshot.data![i].nominal}',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontFamily: 'Euclid Circular B',
                                                                                fontSize: 20,
                                                                                color: Color(0xff222222)),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ]));
                                                      });
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      '${snapshot.error}');
                                                }

                                                return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                          child: LoadingAnimationWidget
                                                              .staggeredDotsWave(
                                                        color: Colors.black,
                                                        size: 40,
                                                      ))
                                                    ]);
                                              },
                                            )),
                                      ])))
                            ]),
                          ),
                        ]);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (ctx) => const QRPage()),
                          (route) => false);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.only(left: 15),
                      height: 70,
                      width: 189,
                      decoration: BoxDecoration(
                        color: const Color(0xffc1c1c1).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: 51,
                            height: 51,
                            decoration: BoxDecoration(
                                color: const Color(0xffFCFAFA),
                                borderRadius: BorderRadius.circular(14)),
                            child: Image.asset('assets/image/scan.png'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
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
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
