import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';




class ArticleMainPage extends StatefulWidget {
  const ArticleMainPage({Key? key}) : super(key: key);

  @override
  State<ArticleMainPage> createState() => _ArticleMainPageState();
}

class _ArticleMainPageState extends State<ArticleMainPage> {
  TextEditingController controller = TextEditingController();
  String thisText = "";
  int pinLength = 4;
  bool hasError = false;


  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(

          decoration: const BoxDecoration(color: Color(0xFFFBFBFB)),
          padding: const EdgeInsets.only(top: 190),
          child: Center(
    child: Column(

        
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Masukkan PIN',style: TextStyle(
    fontSize: 32,
    fontFamily: 'Euclid Circular B',
    fontWeight: FontWeight.w600,
                color: Color(0xff222222)
    ),),

              Text('Masukkan PIN anda untuk melanjutkan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Euclid Circular B',
                  fontWeight: FontWeight.w500,
                  color: Color(0xffa6a6a6)
              ),),
              SizedBox(
                height: 60,
              ),
              Container(
                height: 50,
                width: 300,
                child: PinCodeTextField(
                  appContext: context,
                  obscureText: true,

                  length: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  pinTheme: PinTheme(
                    fieldWidth: 55,
                    borderWidth: 4,
                    inactiveColor: Color(0xffd9d9d9),

                  ),
                  onChanged: (value){
                    print(value);
                  },
                ),
              ),

              SizedBox(
                height: 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10,right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextButton(onPressed: (){}, child: Text('Batalkan',style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Euclid Circular B',
                      fontSize: 20,
                      color:  Color(0xffDD3960)
                    ),),),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 50,
                    right: 50),
                    decoration: BoxDecoration(
                      color: Color(0xff5258D4),
borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextButton(onPressed: (){}, child: Text('Lanjutkan',style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Euclid Circular B',
                        fontSize: 20,
                      color: Colors.white
                    ),),),
                  ),

                ],
              )

        ]
      )

          ),
      )
      )
        );
  }


}