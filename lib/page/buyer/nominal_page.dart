import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NominalPage extends StatefulWidget {
  const NominalPage(this.id_seller, this.name, {super.key}) : super();

  final id_seller;
  final name;

  @override
  State<NominalPage> createState() => _NominalPageState();
}

class _NominalPageState extends State<NominalPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 48),
        decoration: const BoxDecoration(
          color: Color(0xFFFDFDFD),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF6F75EA),
                        borderRadius: BorderRadius.all(Radius.circular(21))
                    ),
                    padding: const EdgeInsets.only(left: 13),
                    width: 342,
                    height: 92,
                    child: Row(
                      children: [
                        Image.asset('assets/image/store-icon.png', width: 61, height: 61),
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
                                'DPID: ${widget.id_seller}',
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
                    height: 86,
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        color: Color(0xFF222222),
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                        fontSize: 72,
                      ),
                      decoration: const InputDecoration(
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
                      inputFormatters: [ThousandsSeparatorInputFormatter()],
                      onChanged: (value) {
                        _controller.value = TextEditingValue(
                          text: value,
                          selection: TextSelection.collapsed(offset: value.length),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 66.99),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 36),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 46),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  child: const Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _controller.text += '1';
                                    });
                                  },
                                ),
                                const SizedBox(width: 120),
                                GestureDetector(
                                  child: const Text(
                                    '2',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _controller.text += '2';
                                    });
                                  },
                                ),
                                const SizedBox(width: 120),
                                GestureDetector(
                                  child: const Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _controller.text += '3';
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 36.11),
                            Row(
                              children: [
                                GestureDetector(
                                  child: const Text(
                                    '4',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _controller.text += '4';
                                    });
                                  },
                                ),
                                const SizedBox(width: 120),
                                GestureDetector(
                                  child: const Text(
                                    '5',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _controller.text += '5';
                                    });
                                  },
                                ),
                                const SizedBox(width: 120),
                                GestureDetector(
                                  child: const Text(
                                    '6',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _controller.text += '6';
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 36.11),
                            Row(
                              children: [
                                GestureDetector(
                                  child: const Text(
                                    '7',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _controller.text += '7';
                                    });
                                  },
                                ),
                                const SizedBox(width: 120),
                                GestureDetector(
                                  child: const Text(
                                    '8',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _controller.text += '8';
                                    });
                                  },
                                ),
                                const SizedBox(width: 120),
                                GestureDetector(
                                  child: const Text(
                                    '9',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _controller.text += '9';
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 36.11),
                            Row(
                              children: [
                                GestureDetector(
                                  child: const Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _controller.text += '0';
                                    });
                                  },
                                ),
                                const SizedBox(width: 100),
                                GestureDetector(
                                  child: const Text(
                                    '000',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _controller.text += '000';
                                    });
                                  },
                                ),
                                const SizedBox(width: 85),
                                GestureDetector(
                                  child: Image.asset('assets/image/backspace.png', width: 38, height: 32),
                                  onTap: () {
                                    setState(() {
                                      _controller.text = "";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: 342,
                      height: 73,
                      child: ElevatedButton(
                        onPressed: () {
                          print(_controller.text);
                          print(widget.id_seller);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF5258D4)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
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
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = '.'; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}