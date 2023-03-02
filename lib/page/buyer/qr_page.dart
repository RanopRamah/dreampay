import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dreampay/page/buyer/buyer_home.dart';
import 'package:dreampay/page/buyer/nominal_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRPage extends StatefulWidget {
  const QRPage({Key? key}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.resumeCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderColor: const Color(0xFFE4F789),
                borderRadius: 76,
                borderLength: 70,
                borderWidth: 20),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          ),
          // label(),
        ],
      ),
    );
  }

  Container label() {
    return Container(
      width: 342,
      height: 77,
      margin: const EdgeInsets.only(left: 35, top: 730),
      padding: const EdgeInsets.only(left: 16, right: 22, top: 11, bottom: 11),
      decoration: const BoxDecoration(
          color: Color(0xFFFDFDFD),
          borderRadius: BorderRadius.all(Radius.circular(13))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pindai dari',
                style: TextStyle(
                  color: Color(0xFFC0B9B9),
                  fontFamily: 'Euclid Circular B',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              Text(
                'Kamera Ponsel',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontFamily: 'Euclid Circular B',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          Image.asset('assets/image/phone.png', width: 35, height: 44.66),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        isThisJson();
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void isThisJson() {
    var output = result!.code;
    var response = jsonDecode(output!);

    controller!.dispose();

    if (response['nama'] != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => NominalPage(response['no_hp'], response['nama'])));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const BuyerHomePage()));
    }
  }
}
