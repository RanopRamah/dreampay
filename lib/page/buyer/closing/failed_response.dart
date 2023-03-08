import 'package:dreampay/page/buyer/home/buyer_view.dart';
import 'package:flutter/material.dart';

class FailedResponsePage extends StatefulWidget {
  const FailedResponsePage(this.pesan, {super.key}) : super();

  final dynamic pesan;

  @override
  State<FailedResponsePage> createState() => _FailedResponsePageState();
}

class _FailedResponsePageState extends State<FailedResponsePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 250, left: 30, right: 24),
        decoration: const BoxDecoration(
          color: Color(0xFFFDFDFD),
        ),
        child: Column(
          children: [
            Image.asset('assets/image/failed.png', width: 92.99, height: 97.34),
            const Text(
              'Pembayaran Gagal',
              style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Euclid Circular B'),
            ),
            const SizedBox(height: 12),
            Text(
              'Yahh... Pembayaranmu gagal 😭,\n ${widget.pesan}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFFA6A6A6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Euclid Circular B'),
            ),
            const SizedBox(height: 59),
            SizedBox(
              width: 342,
              height: 48,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF5258D4)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(31)),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => const BuyerHomePage()));
                },
                child: const Text(
                  'Beranda',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Euclid Circular B'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
