import 'dart:ffi';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:searchfield/searchfield.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

Future<List> fetchUsers() async {
  final response = await http.get(
    Uri.parse('http://server.sekolahimpian.com:3000/api/cashier/1'),
  );

  if (response.statusCode == 200) {
    // final List<Map<dynamic, dynamic>> jsonResponse = jsonDecode(response.body)['list_buyer'];
    // print(jsonDecode(response.body)['list_buyer']);
    return jsonDecode(response.body)['list_buyer'];
  } else {
    throw Exception('Failed to Load');
  }
}
Future<List<TopUp>> fetchTopUp() async {
  final response = await http.get(
    Uri.parse('http://server.sekolahimpian.com:3000/api/cashier/1'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['list_topup'];
    print(jsonResponse);
    return jsonResponse.map((e) => TopUp.fromJson(e)).toList();
  } else {
    throw Exception('Failed to Load');
  }
}
class Users {
  final dynamic id;
  final dynamic nama;
  final dynamic no_hp;

  const Users({
    required this.id,
    required this.nama,
    required this.no_hp
  });

  Users.init()
      : id = 0,
        nama = 'somebody',
        no_hp = '00000000000';

  Users.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'] as Int,
        nama = map['nama'] as String,
        no_hp = map['no_hp'] as String;

  factory Users.fromJson(Map<dynamic, dynamic> json) {
    return Users(
      id: json['id'],
      nama: json['nama'],
      no_hp: json['no_hp'],
    );
  }
}
class TopUp {
  final dynamic id;
  final dynamic penerima;
  final dynamic nominal;
  final dynamic created_at;

  const TopUp({
    required this.id,
    required this.penerima,
    required this.nominal,
    required this.created_at,
  });

  factory TopUp.fromJson(Map<dynamic, dynamic> json) {
    return TopUp(
      id: json['id'],
      penerima: json['penerima'],
      nominal: json['nominal'],
      created_at: json['created_at'],
    );
  }
}

class CashierPage extends StatefulWidget {
  const CashierPage({Key? key}) : super(key: key);

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final searchController = TextEditingController();

  List<Users> user = [];
  Users _selectedUsers = Users.init();

  bool showPull = false;
  bool showTopup = true;
  bool visible = false;
  bool isSuccessful = false;

  final PanelController _controller = PanelController();
  late Future<List<TopUp>> topup;

  @override
  void initState() {
    super.initState();
    dvs();
    topup = fetchTopUp();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void togglePanel() {
    _controller.isPanelOpen
        ? _controller.close()
        : _controller.open();
  }

  void dvs() async {
    List<dynamic> data = await fetchUsers();
    user = data.map((e) => Users.fromJson(e)).toList();
    //
    // var h = user.map((e) => e.nama);
    // print(h);
  }

  bool containsUser(String text) {
    final Users result = user.firstWhere(
            (Users u) => u.nama.toLowerCase() == text.toLowerCase(),
            orElse: () => Users.init());

    if (result!.nama.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _controller,
        maxHeight: 590,
        minHeight: 150,
        padding: const EdgeInsets.only(left: 30, right: 30),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFDFDFD),
          ),
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 29),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 52,
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: const BorderRadius.all(Radius.circular(13)),
                              border: Border.all(color: const Color(0xFFD2D2D2), width: 1),
                            ),
                            child: Center(
                              child: Image.asset('assets/image/logout.png', width: 27.03, height: 27.05),
                            )
                        ),
                        const Text(
                          'Keluar',
                          style: TextStyle(
                            color: Color(0xFFADADAD),
                            fontFamily: 'Euclid Circular B',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 55),
              Center(
                child: Container(
                  width: 345,
                  height: 485,
                  decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          blurRadius: 6.0,
                          spreadRadius: 2.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 322,
                        height: 62,
                        margin: const EdgeInsets.only(top: 26.88),
                        child: SearchField(
                          searchInputDecoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                            ),
                            hintText: 'Cari Pengguna',
                            hintStyle: const TextStyle(
                              color: Color(0xFFBDBDBD),
                              fontFamily: 'Euclid Circular B',
                              fontWeight: FontWeight.w400,
                              fontSize: 18.8304,
                            ),
                            prefixIcon: Container(
                              padding: const EdgeInsets.all(0.01),
                              margin: const EdgeInsets.only(bottom: 15.0),
                              child: Image.asset('assets/image/search-all.png'),
                            ),
                          ),
                          suggestions: user.map((e) => SearchFieldListItem(e.nama, item: e)).toList(),
                          suggestionState: Suggestion.hidden,
                          controller: searchController,
                          inputType: TextInputType.text,
                          itemHeight: 40,
                          validator: (x) {
                            if (x!.isEmpty || !containsUser(x)) {
                              return 'Please enter valid name';
                            } else {
                              return null;
                            }
                          },
                          onSuggestionTap: (SearchFieldListItem<Users> x) {
                            setState(() {
                              _selectedUsers = x.item!;
                              print(_selectedUsers.nama);
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 325,
                        height: 81.51,
                        margin: const EdgeInsets.only(top: 24),
                        padding: const EdgeInsets.only(top: 18.58, left: 15.2),
                        decoration: const BoxDecoration(
                            color: Color(0xFF7C81DF),
                            borderRadius: BorderRadius.all(Radius.circular(18.6053))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedUsers.nama ?? 'Nama',
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 17.7193,
                                fontFamily: 'Euclid Circular B',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3.82),
                            Text(
                              'DPID: ${_selectedUsers.no_hp ?? '000000000000'}',
                              style: const TextStyle(
                                color: Color(0xFFC5C7F1),
                                fontSize: 13.0526,
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 312,
                        height: 67.51,
                        margin: const EdgeInsets.only(top: 38.61),
                        child: TextField(
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.912281,
                                color: Color(0xFFC8BDBD),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(6.38596)),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.912281,
                                color: Color(0xFFC8BDBD),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(6.38596)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.912281,
                                color: Color(0xFFC8BDBD),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(6.38596)),
                            ),
                            labelText: 'Nominal Top Up',
                            hintText: 'Rp0',
                            hintStyle: TextStyle(
                              color: Color(0xFFCAC5C5),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SF Pro Display',
                              fontSize: 21.8947,
                            ),
                            labelStyle: TextStyle(
                              color: Color(0xFF8D8989),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Euclid Circular B',
                              fontSize: 17,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [ThousandsSeparatorInputFormatter()],
                        ),
                      ),
                      Container(
                        width: 310,
                        height: 60,
                        margin: const EdgeInsets.only(top: 48),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              fetchTopUp();
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF5258D4)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(6.59649))
                              ),
                            ),
                          ),
                          child: const Text(
                            'Top-Up',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'Euclid Circular B',
                              fontSize: 19.7895,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Visibility(
                          visible: visible,
                          child: Image.asset(
                            (isSuccessful)
                                ? 'assets/image/success-topup.png'
                                : 'assets/image/failed-topup.png',
                            width: 153,
                            height: 60,
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
        panelBuilder: (controller) {
          return Column(
            children: [
              GestureDetector(
                onTap: togglePanel,
                child: Center(
                  child: Container(
                    width: 85,
                    height: 4,
                    margin: const EdgeInsets.only(top: 7),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.all(Radius.circular(29)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Riwayat Top-Up',
                  style: TextStyle(
                    color: Color(0xFF172437),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Euclid Circular B',
                  ),
                ),
              ),
              Container(
                width: 342,
                height: 30,
                margin: const EdgeInsets.only(top: 29),
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF1F1F1)),
                    ),
                    hintText: 'Cari Top-Up',
                    hintStyle: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontFamily: 'Euclid Circular B',
                      fontWeight: FontWeight.w400,
                      fontSize: 18.8304,
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(0.01),
                      margin: const EdgeInsets.only(bottom: 15.0),
                      child: Image.asset('assets/image/search-all.png'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              scrollingList(controller),
            ],
          );
        },
      ),
    );
  }
  Widget scrollingList(ScrollController sc) {
    return Container(
      height: 450,
      margin: const EdgeInsets.only(top: 1),
      child: FutureBuilder(
        future: topup,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 200,
                          child: Text(
                            snapshot.data![i].penerima,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF172437),
                              fontFamily: 'Euclid Circular B',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          snapshot.data![i].created_at,
                          style: const TextStyle(
                            color: Color(0xFFBEBEBE),
                            fontFamily: 'Euclid Circular B',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 19.84),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Rp${snapshot.data![i].nominal.toString()}',
                        style: const TextStyle(
                            color: Color(0xFF222222),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            fontFamily: 'SF Pro Display'
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          print(snapshot.data);
          return const Center(child: CircularProgressIndicator());
        },
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