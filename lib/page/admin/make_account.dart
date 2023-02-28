import 'package:dreampay/page/admin/topup.dart';
import 'package:dreampay/page/admin/transaction.dart';
import 'package:dreampay/page/admin/withdraw.dart';
import 'package:dreampay/page/buyer/buyer_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum SingingCharacter { user, cashier, seller }

class MakeAccountPage extends StatefulWidget {
  MakeAccountPage({Key? key}) : super(key: key);

  @override
  State<MakeAccountPage> createState() => _MakeAccountPageState();
}


SingingCharacter _character = SingingCharacter.user;

class _MakeAccountPageState extends State<MakeAccountPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PanelController _panelController = PanelController();

  final List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "HEFTIVE", "number": "62876545678"},
    {"id": 2, "name": "PASTRIP", "number": "62234567758"},
    {"id": 3, "name": "DreamBoba","number": "62876587683"},
    {"id": 4, "name": "Aksesoris STFQ","number": "628765123478"},
    {"id": 5, "name": "Akae","number": "628765123478"},
    {"id": 6, "name": "Akseaefsoris STFQ","number": "628765123478"},
    {"id": 7, "name": "Aksesoris faeSTFQ","number": "628765123478"},
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

  @override
  void togglePanel() => _panelController.isPanelOpen
      ? _panelController.close()
      : _panelController.open();
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
                  title: Container(
                    padding: EdgeInsets.only(right: 30, left: 40),
                    width: double.infinity,
                    height: 51,
                    decoration: BoxDecoration(
                        color: Color(0xff8A8EF9),
                        borderRadius: BorderRadius.circular(13)),
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (c) => AdminWithdrawPage()));
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
                padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                width: double.infinity,
                height: 98,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff292B5A)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Saldo A',style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Euclid Circular B',
                      fontSize: 14,
                      color: Color(0xffbebebe)
                    ),),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                        child:Row(
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
                        )
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                width: double.infinity,
                height: 98,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff3A2C62)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Saldo A',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Euclid Circular B',
                        fontSize: 14,
                        color: Color(0xffbebebe)
                    ),),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                        child:Row(
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
                        )
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                width: double.infinity,
                height: 98,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff2E3346)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Saldo A',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Euclid Circular B',
                        fontSize: 14,
                        color: Color(0xffbebebe)
                    ),),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                        child:Row(
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
                        )
                    )
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
      body: SlidingUpPanel(
        minHeight: 70,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
    body:Container(
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
            SizedBox(
              height: 30,
            ),
            Container(
              width: 345,
              height: 600,
              padding: EdgeInsets.only(top: 30, left: 15, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
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
                  Text(
                    'Akun Baru',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Euclid Circular B',
                        color: Color(0xff222222)),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    style: TextStyle(
                        fontFamily: 'Euclid Circular B'
                    ),
                    decoration: InputDecoration(
                      labelText: 'Nama Akun',
                      labelStyle: TextStyle(fontFamily: 'Euclid Circular B'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              width: 0.91,
                              color: Color(
                                0xffC8BDBD,
                              ))),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    style: TextStyle(
                        fontFamily: 'Euclid Circular B'
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nomor Akun',

                      labelStyle: TextStyle(fontFamily: 'Euclid Circular B'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              width: 0.91,
                              color: Color(
                                0xffC8BDBD,
                              ))),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontFamily: 'Euclid Circular B'
                    ),
                    decoration: InputDecoration(
                      labelText: 'PIN Akun',
                      labelStyle: TextStyle(fontFamily: 'Euclid Circular B'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              width: 0.91,
                              color: Color(
                                0xffC8BDBD,
                              ))),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  
                  Row(
                    children: <Widget>[
                      Text('Tipe',style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Euclid Circular B',
                        fontWeight: FontWeight.w600,
                        color: Color(0xff8D8989)
                      ),),

                      SizedBox(
                        width: 5,
                      ),
                      Text('Akun',style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Euclid Circular B',
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8D8989)
                      ),)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Radio<SingingCharacter>(
                              value: SingingCharacter.user,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value!;
                                });
                              }),
                          Expanded(
                              child: Text(
                            'User',style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 13,
                                  color: Color(0xff8D8989)
                              ),

                          ))
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Radio(
                              value: SingingCharacter.cashier,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value!;
                                });
                              }),
                          Text('Cashier',style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Euclid Circular B',
                            fontSize: 13,
                            color: Color(0xff8D8989)
                          ),)
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Radio(
                              value: SingingCharacter.seller,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value!;
                                });
                              }),
                          Text('Seller',style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Euclid Circular B',
                              fontSize: 13,
                              color: Color(0xff8D8989)
                          ),)
                        ],
                      ),
                    ),
                  ]),
                  TextButton(onPressed: (){}, child: Container(

                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xff5258D4),
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Center(child:Text('Buat Akun',style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Euclid Circular B',
                      fontSize: 19,
                      color: Colors.white
                    ),),)
                  ))
                ],
              ),
            )
          ],
        ),
      ),
        panelBuilder: (ScrollController sc) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    ),),
                ),
                    SizedBox(
                      height: 15,
                    ),


                    Text('Akun Terdaftar',style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Euclid Circular B',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff222222)
                    ),),

                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(right: 20,left: 20),
                child: TextField(
                  style: TextStyle(
                    fontFamily: 'Euclid Circular B'
                  ),
                  onChanged: (value) => _runFilter(value),
                  decoration: const InputDecoration(

                      labelText: 'Cari Transaksi',
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Euclid Circular B',
                          color: Color(0xffbdbdbd)),
                      prefixIcon: Icon(Icons.search)),
                ),),

_scrollingList(sc)


              ]);
        },
      ),

    );

  }

  Widget _scrollingList(ScrollController sc){
    return     Expanded(
      child: _foundUsers.isNotEmpty
          ? ListView.builder(
        controller: sc,
        itemCount: _foundUsers.length,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.only(top: 25,bottom: 25,left: 30,right: 20),
          key: ValueKey(_foundUsers[index]["id"]),


          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

             Text(_foundUsers[index]['name'], style:TextStyle(
                fontWeight: FontWeight.w600,
               fontFamily: 'Euclid Circular B',
               fontSize: 20,
               color: Color(0xff172437)
            )),
            Text(
                _foundUsers[index]['number'].toString(),style:TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Euclid Circular B',
                fontSize: 16,
                color: Color(0xffbebebe)
            )),

        ]),
                TextButton(onPressed: (){}, child: Container(
                  width: 101,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(49),
                    border: Border.all(width: 0.5,color: Color(0xffe6e6e6))
                  ),child: Center (child:Text('Detail',style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Euclid Circular B',
                    fontSize: 16,
                    color: Color(0xff222222)
                ),),)
                ))
            ]
          )
        ),
      )
          : const Text(
        'No results found',
        style: TextStyle(fontSize: 24),
      ),
    );


  }
}


