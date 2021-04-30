import 'package:flutter/material.dart';
import 'package:sip_3_mobile/screens/main.dart';
import 'package:sip_3_mobile/screens/setting.dart';
import 'package:sip_3_mobile/widgets/option_button.dart';

// ignore: must_be_immutable
class MainInterface extends StatefulWidget {
  @override
  _MainInterfaceState createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Main(),
    Setting(),
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
              'SAIFU',
              style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.white, blurRadius: 15.0, offset: Offset(0.0, 0.75))
              ],
            ),
            child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedLabelStyle: TextStyle(color: Colors.black),
                fixedColor: Colors.black,
                items: <BottomNavigationBarItem>[
                  // ignore: deprecated_member_use
                  BottomNavigationBarItem(icon: Icon(Icons.person_rounded), title: _showIndicator(_selectedIndex == 0)),
                  // ignore: deprecated_member_use
                  BottomNavigationBarItem(icon: Icon(Icons.home_rounded), title: _showIndicator(_selectedIndex == 1)),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTap),
          ),
          floatingActionButton: _selectedIndex == 0
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
                            FloatingButton(
                              option: 'Create a new wallet',
                            ),
                            FloatingButton(
                              option: "Import private key via Qrcode",
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                  backgroundColor: Colors.black,
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

Widget _showIndicator(bool show) {
  return show
      ? Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(Icons.brightness_1, size: 10, color: Colors.black),
        )
      : SizedBox();
}
