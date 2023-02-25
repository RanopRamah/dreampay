import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';




class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


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
            child: Container(

              decoration: const BoxDecoration(color: Color(0xFFFBFBFB)),
              padding: const EdgeInsets.only(top: 190),
              child: Center(
                  child: Column(


                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
Container(
  height: 506,
  decoration: BoxDecoration(
    color: Color(0xff116ded),
    image: DecorationImage(
      image: AssetImage('assets/image/back_login.png')
    )
  ),
)
                      ]
                  )

              ),
            )
        )
    );
  }


}