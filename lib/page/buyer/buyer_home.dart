import 'dart:core';
import 'dart:ui';

import 'package:dreampay/page/buyer/qr_page.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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

  @override
  initState() {
    _foundUsers = _allUsers;
    super.initState();
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
          minHeight: 240,
          padding: EdgeInsets.only(left: 30, right: 30),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        body: Container(
          decoration: const BoxDecoration(color: Color(0xFFFBFBFB)),
          padding:
              const EdgeInsets.only(right: 25, left: 25, top: 80, bottom: 74),
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
                      Text(
                        'Abi Dzaky',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Euclid Circular B',
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          color: Color(0xff222222),
                        ),
                      ),
                    ],
                  ),
                  Column(children: <Widget>[
                    Container(
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
                                  '250,000',
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
              Container(
                  height: 185,
                  child: Row(children: <Widget>[
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
                      width: 8,
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
                              child: ListView(children: [
                                Container(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
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
                                                '6/3/2023 - 10:32',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Euclid Circular B',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    color: Color(0xffbebebe)),
                                              )
                                            ],
                                          ),
                                      Text('-Rp120,000',style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Euclid Circular B',
                                        fontSize: 20,
                                        color: Color(0xff222222)
                                      ),)
                                        ],
                                      )


                                ),

                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                      children: [

                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Windoa',
                                              style: TextStyle(
                                                  fontFamily:
                                                  'Euclid Circular B',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              '6/3/2023 - 11:32',
                                              style: TextStyle(
                                                  fontFamily:
                                                  'Euclid Circular B',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Color(0xffbebebe)),
                                            )
                                          ],
                                        ),
                                        Text('-Rp8,000',style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Euclid Circular B',
                                            fontSize: 20,
                                            color: Color(0xff222222)
                                        ),)
                                      ],
                                    )


                                ),
                              ])),
                        ]),
                      )))
                    ])),
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

      Center(
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (c)=> QRPage()));
            },
              child:Container(
        margin: EdgeInsets.only(
          top: 700,
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
