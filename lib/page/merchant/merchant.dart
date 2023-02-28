import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:badges/badges.dart' as badges;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';

import 'package:signed_spacing_flex/signed_spacing_flex.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MerchantPage extends StatefulWidget {
  const MerchantPage({Key? key}) : super(key: key);

  @override
  State<MerchantPage> createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  PanelController _panelController = PanelController();
  bool showPull = false;
  bool showTopup = true;

  @override
  void initState() {
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
                          Text(
                            'S K M',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                              color: Color(0xff222222),
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
                height: 20,
              ),
              SignedSpacingColumn(
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
                            'Susu Kocok Madjid',
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
                            'DPID: 6281287138898',
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
                            child: Image.asset('assets/image/qrex.png'),
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
                                        '250,000',
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
                                          '150,000',
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
                                          '150,000',
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
                  ])
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
                  child: Column(children: [
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'HEFTIVE',
                                            style: TextStyle(
                                                fontFamily: 'Euclid Circular B',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            '6/3/2023 - 10:32',
                                            style: TextStyle(
                                                fontFamily: 'Euclid Circular B',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Color(0xffbebebe)),
                                          )
                                        ],
                                      ),
                                      Text(
                                        '-Rp120,000',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Euclid Circular B',
                                            fontSize: 20,
                                            color: Color(0xff222222)),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Windoa',
                                            style: TextStyle(
                                                fontFamily: 'Euclid Circular B',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            '6/3/2023 - 11:32',
                                            style: TextStyle(
                                                fontFamily: 'Euclid Circular B',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Color(0xffbebebe)),
                                          )
                                        ],
                                      ),
                                      Text(
                                        '-Rp8,000',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Euclid Circular B',
                                            fontSize: 20,
                                            color: Color(0xff222222)),
                                      )
                                    ],
                                  )),
                            ])),
                      ]),
                    )))
                  ])),
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
