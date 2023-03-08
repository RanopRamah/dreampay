import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'api/topup.dart';
import 'api/totalsaldo.dart';
import 'api/user.dart';
import '../login_page.dart';



var url = dotenv.env['API_URL'];

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
  bool isSuccessful = false;
  bool isSubmit = false;

  final PanelController _controller = PanelController();
  late Future<List<TopUp>> listTopup;
  late TotalSaldo jumlahSaldo;

  String? phone;
  String? name;
  String? id;
  late SharedPreferences prefs;

  Future<void> setValue() async {
    prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone_customer');
    name = prefs.getString('name_customer');
    id = prefs.getString('id_customer');

    setState(() {
      dvs();
      setSaldo();
      listTopup = fetchTopUp(id);
    });
  }

  @override
  void initState() {
    setValue();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void togglePanel() {
    _controller.isPanelOpen ? _controller.close() : _controller.open();
  }

  void dvs() async {
    List<dynamic> data = await fetchUsers(id);
    setState(() {
      user = data.map((e) => Users.fromMap(e)).toList();
    });
  }

  void setSaldo() async {
    TotalSaldo data = await fetchTotalSaldo(id);
    setState(() {
      jumlahSaldo = data;
    });
  }

  bool containsUser(String text) {
    final Users result = user.firstWhere(
        (Users u) => u.nama.toLowerCase() == text.toLowerCase(),
        orElse: () => Users.init());

    if (result.nama.isEmpty) {
      return false;
    }
    return true;
  }

  final TextEditingController _topupcontrol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: setValue,
        child: SlidingUpPanel(
          maxHeight: 590,
          minHeight: 150,
          padding: const EdgeInsets.only(left: 30, right: 30),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 29),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        name.toString(),
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Euclid Circular B',
                            color: Color(0xff222222)),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 52,
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(13)),
                              border: Border.all(
                                  color: const Color(0xFFD2D2D2), width: 1),
                            ),
                            child: TextButton(
                              child: Image.asset('assets/image/logout.png',
                                  width: 27.03, height: 27.05),
                              onPressed: () {
                                setState(() {
                                  prefs.remove('id_customer');
                                  prefs.remove('phone_customer');
                                  prefs.remove('name_customer');
                                  prefs.remove('pin_customer');
                                  prefs.remove('type_customer');
                                  prefs.remove('is_login');
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (ctx) => const LoginPage()),
                                      (route) => false);
                                });
                              },
                            )),
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
                    ),
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
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 322,
                        height: 62,
                        margin: const EdgeInsets.only(top: 26.88),
                        child: SearchField<dynamic>(
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
                          suggestions: user
                              .map(
                                (e) => SearchFieldListItem(
                                  e.nama,
                                  item: e,
                                  // Use child to show Custom Widgets in the suggestions
                                  // defaults to Text widget
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, left: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                e.nama,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff222222),
                                                    fontSize: 20,
                                                    fontFamily:
                                                        'Euclid Circular B'),
                                              ),
                                              Text(
                                                e.no_hp,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xffbebebe),
                                                    fontSize: 15,
                                                    fontFamily:
                                                        'Euclid Circular B'),
                                              ),
                                            ])
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          suggestionState: Suggestion.hidden,
                          controller: searchController,
                          inputType: TextInputType.text,
                          itemHeight: 80,
                          validator: (v) {
                            if (v!.isEmpty || !containsUser(v)) {
                              return 'Please enter valid name';
                            } else {
                              return null;
                            }
                          },
                          onSuggestionTap: (SearchFieldListItem v) {
                            setState(() {
                              _selectedUsers = v.item!;
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(18.6053))),
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
                              'DPID: ${_selectedUsers.no_hp ?? '-'}',
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
                          controller: _topupcontrol,
                          style: const TextStyle(
                              fontSize: 23, color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.912281,
                                color: Color(0xFFC8BDBD),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.38596)),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.912281,
                                color: Color(0xFFC8BDBD),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.38596)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.912281,
                                color: Color(0xFFC8BDBD),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.38596)),
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
                        ),
                      ),
                      Container(
                        width: 310,
                        height: 60,
                        margin: const EdgeInsets.only(top: 48),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              createTopup();
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF5258D4)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(6.59649))),
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
                      Visibility(
                        visible: isSuccessful,
                        child: Image.asset(
                          'assets/image/success-topup.png',
                          width: 153,
                          height: 60,
                        ),
                      ),
                      Visibility(
                        visible: isSubmit,
                        child: Visibility(
                          visible: !isSuccessful,
                          child: Image.asset(
                            'assets/image/failed-topup.png',
                            width: 153,
                            height: 60,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'Uang Diterima: ${jumlahSaldo.totalSaldo}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Euclid Circular B',
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
      ),
    );
  }

  Widget scrollingList(ScrollController sc) {
    return Container(
      height: 450,
      margin: const EdgeInsets.only(top: 1),
      child: FutureBuilder(
        future: listTopup,
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
                          snapshot.data![i].createdAt,
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
                            fontFamily: 'SF Pro Display'),
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 40,
            ))
          ]);
        },
      ),
    );
  }

  Future<void> createTopup() async {
    final response = await http.post(
      Uri.parse('$url/cashier/topup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'cashier_id': id.toString(),
        'buyer_id': '${_selectedUsers.id}',
        'nominal': _topupcontrol.text.toString(),
      }),
    );

    setState(() {
      isSubmit = true;
    });

    if (response.statusCode == 200) {
      setState(() {
        isSuccessful = true;
        _topupcontrol.clear();
      });

      Timer(const Duration(seconds: 1), () {
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => const CashierPage()),
              (route) => false);
        });
      });
    } else {
      setState(() {
        isSuccessful = false;
      });
    }
  }
}
