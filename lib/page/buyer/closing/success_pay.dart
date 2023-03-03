import 'package:dreampay/page/buyer/buyer_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';




class SuccessPayPage extends StatefulWidget {
  const SuccessPayPage(this.seller, this.nota, this.nominal, {super.key}) : super();

  final seller;
  final nota;
  final nominal;

  @override
  State<SuccessPayPage> createState() => _SuccessPayPageState();
}

class _SuccessPayPageState extends State<SuccessPayPage> {


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
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
height: 1900,
              decoration: const BoxDecoration(color: Colors.white),

              padding: const EdgeInsets.only(top: 100,bottom: 0.1
              ),

                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
Container(
  height: 300,
  child:
          Center(
            child:
                Column(
                  children : [
          Image.asset('assets/image/success.png', width: 102, height: 116,),
                    SizedBox(
                      height: 30,
                    ),
                    Text('Pembayaran Berhasil',style: TextStyle(
                      fontFamily: 'Euclid Circular B',
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      color: Color(0xff222222)
                    ),),

                    SizedBox(
                      height: 10,
                    ),

                    Text('Hore! 👏 Transaksimu sudah selesai!',style: TextStyle(
                        fontFamily: 'Euclid Circular B',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xffa6a6a6)
                    ),),])

          ),
),

                      Container(
height: 900,
                        padding: EdgeInsets.only(top: 20,
                        right: 20,left: 20),
width: double.infinity,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
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
                        child:
                      Column(
                        children: <Widget>[
                          Text('Detail Transaksi',style: TextStyle(
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Color(0xff222222)
                          ),),
SizedBox(
  height: 40,
),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Total Pembayaran',style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Euclid Circular B',
                                fontSize: 16,
                                color: Color(0xffbebcbc)
                              ),),
                              Text('Rp ${widget.nominal}',style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 16,
                                  color: Color(0xff5258d4)
                              ),),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Merchant',style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 16,
                                  color: Color(0xffbebcbc)
                              ),),
                              Text(widget.seller,style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 16,
                                  color: Color(0xff222222)
                              ),),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Kode Unik',style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 16,
                                  color: Color(0xffbebcbc)
                              ),),
                              Text(widget.nota,style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Euclid Circular B',
                                  fontSize: 16,
                                  color: Color(0xff222222 )
                              ),),


                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xff5258D4),
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: TextButton(
                            child: Text('Beranda',style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w400,
                              color: Colors.white
                            ),),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (c)=> BuyerHomePage()));
                            },
                          ),
                        ),

                        ],
                      ),)

                  ])




              ),


)
    );
  }


}