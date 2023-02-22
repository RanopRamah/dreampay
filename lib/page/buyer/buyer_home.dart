import 'package:flutter/material.dart';

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({Key? key}) : super(key: key);

  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 900,
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
                  Container(
                    width: 52,height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(width: 1,color: Color(0xffD2D2D2))
                    ),
                  )
                ],
              ),
SizedBox(
  height: 15,
),
Container(
  padding: EdgeInsets.only(
    top: 20,
    left: 30,
    right: 30
  ),
  height: 172,
  width: double.infinity,

  decoration: BoxDecoration(
    color: Color(0xffD7D0FF),
    borderRadius: BorderRadius.circular(22)
  ),
  child: Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Saldo Anda',style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'Euclid Circular B'
          ),),
          Image.asset('assets/image/wallet.png')
        ],
      ),
      SizedBox(
        height: 22,
      ),
      Container(
        width: 253,
        height: 90,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/back_money.png')
          )
        ),
        child: Row(
          children: <Widget>[
            Text('Rp',style: TextStyle(
              fontFamily: 'Euclid Circular B'
            ),)
          ],
        ),
      )
    ],
  ),
)
            ],
          ),
        ),
      ),
    );
  }
}
