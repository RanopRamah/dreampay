import 'package:dreampay/page/buyer/input_pin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NominalPage extends StatefulWidget {
  const NominalPage(this.idSeller, this.name, {super.key}) : super();

  final dynamic idSeller;
  final String name;

  @override
  State<NominalPage> createState() => _NominalPageState();
}

class _NominalPageState extends State<NominalPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 48),
          decoration: const BoxDecoration(
            color: Color(0xFFFDFDFD),
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF6F75EA),
                        borderRadius: BorderRadius.all(Radius.circular(21))),
                    padding: const EdgeInsets.only(left: 13),
                    width: 342,
                    height: 92,
                    child: Row(
                      children: [
                        Image.asset('assets/image/store-icon.png',
                            width: 61, height: 61),
                        const SizedBox(width: 9),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.98),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Euclid Circular B',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'DPID: ${widget.idSeller}',
                                style: const TextStyle(
                                  color: Color(0xFFC5C7F1),
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.7327,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 33.01),
                  const Text(
                    'Nominal pembayaran',
                    style: TextStyle(
                      color: Color(0xFFACA9A9),
                      fontFamily: 'Euclid Circular B',
                      fontWeight: FontWeight.w500,
                      fontSize: 21.2896,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 342,
                    height: 96,
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        color: Color(0xFF222222),
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                        fontSize: 72,
                      ),
                      decoration: const InputDecoration(
                        enabled: false,
                        hintText: 'Rp0',
                        hintStyle: TextStyle(
                          color: Color(0xFFACA9A9),
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                          fontSize: 72,
                        ),
                        prefixStyle: TextStyle(
                          color: Color(0xFFACA9A9),
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                          fontSize: 72,
                        ),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _controller.value = TextEditingValue(
                          text: value,
                          selection:
                              TextSelection.collapsed(offset: value.length),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 66.99),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(13),
                      topRight: Radius.circular(13),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurStyle: BlurStyle.normal,
                        blurRadius: 10,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buttonNominal('1'),
                                  buttonNominal('2'),
                                  buttonNominal('3'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buttonNominal('4'),
                                  buttonNominal('5'),
                                  buttonNominal('6'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buttonNominal('7'),
                                  buttonNominal('8'),
                                  buttonNominal('9'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buttonNominal('0'),
                                  buttonNominal('000'),
                                  GestureDetector(
                                    child: Center(
                                      child: Container(
                                        color: Colors.white,
                                        width: 125,
                                        child: Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Center(
                                            child: Image.asset(
                                                'assets/image/backspace.png',
                                                width: 38,
                                                height: 32),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () => {
                                      setState(() {
                                        _controller.text = _controller.text
                                            .substring(
                                                0, _controller.text.length - 1);
                                        formatNominal('');
                                      })
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 342,
                        height: 73,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (widget.idSeller != null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => ArticleMainPage(
                                        widget.idSeller, _controller.text)));
                              } else {
                                null;
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF5258D4)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Konfirmasi',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buttonNominal(String nominal) {
    return GestureDetector(
      child: Center(
        child: Container(
          color: Colors.white,
          width: 125,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                nominal,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w600,
                  fontSize: 36,
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        formatNominal(nominal);
      },
    );
  }

  void formatNominal(String nominal) {
    return setState(() {
      if (_controller.text.isNotEmpty) {
        _controller.text = _controller.text.replaceAll('.', '');
      }

      if (nominal.isNotEmpty) {
        _controller.text += nominal;
      }

      var f = NumberFormat('#,###', 'id_ID');
      var formatted = f.format(int.parse(_controller.text));

      _controller.text = formatted;
    });
  }
}
