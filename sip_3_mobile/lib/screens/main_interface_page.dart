import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sip_3_mobile/screens/address_book_page.dart';
import 'package:sip_3_mobile/screens/main_page.dart';
import 'package:sip_3_mobile/screens/setting_page.dart';
import 'package:sip_3_mobile/widgets/option_button.dart';

// ignore: must_be_immutable
class MainInterface extends StatefulWidget {
  bool retrievedData = false;
  @override
  _MainInterfaceState createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  @override
  void initState() {
    super.initState();
    //getApplicationDocumentsDirectory().then((value) => dir = value);
    //getTemporaryDirectory();
  }

  int _selectedIndex = 1;

  List<Widget> _widgetOptions = <Widget>[
    AddressBookPage(),
    MainPage(),
    SettingPage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            actions: [],
            title: Text(
              'Saifu',
              style: TextStyle(),
            ),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(color: Colors.black, blurRadius: 15.0, offset: Offset(0.0, 0.75))
                ],
              ),
              child: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedLabelStyle: TextStyle(color: Colors.black),
                  fixedColor: Colors.black,
                  items: <BottomNavigationBarItem>[
                    // ignore: deprecated_member_use
                    BottomNavigationBarItem(icon: Icon(Icons.vpn_key_rounded), title: showIndicator(_selectedIndex == 0)),
                    // ignore: deprecated_member_use
                    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), title: showIndicator(_selectedIndex == 1)),
                    // ignore: deprecated_member_use
                    BottomNavigationBarItem(icon: Icon(Icons.person_rounded), title: showIndicator(_selectedIndex == 2)),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTap),
            ),
          ),
          floatingActionButton: _selectedIndex == 1
              ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                      ),
                      isScrollControlled: false,
                      isDismissible: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OptionButton(
                              option: 'Create a new wallet',
                            ),
                            OptionButton(
                              option: "Import private key via Qrcode",
                            )
                            /*
                              OptionButton(
                                option: 'Import private key via key file',
                              ),
                              OptionButton(
                                option: 'Import private key via seed words',
                              ),
                              */
                          ],
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                    size: 30,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 5,
                  splashColor: Colors.grey,
                )
              : Container(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                  ),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: Container(margin: EdgeInsets.only(top: 30.0, bottom: 5.0), color: Colors.white, child: _widgetOptions.elementAt(_selectedIndex))),
    );
  }
}

Widget showIndicator(bool show) {
  return show
      ? Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(Icons.brightness_1, size: 10, color: Colors.black),
        )
      : SizedBox();
}
