import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saifu/constants.dart';
import 'package:saifu/screens/create_mnemonic%20.dart';
import 'package:saifu/screens/import_qrcode.dart';
import 'package:saifu/screens/input_mnemonics.dart';
import 'package:saifu/screens/main.dart';

import 'change_password.dart';

// ignore: must_be_immutable
class MainInterface extends StatefulWidget {
  @override
  _MainInterfaceState createState() => _MainInterfaceState();
}

// created the ScaffoldState key

class _MainInterfaceState extends State<MainInterface> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Main(),
    //Setting(),
  ];

/*
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            automaticallyImplyLeading: false,
            elevation: 0.0,
            actions: [
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
            title: Text(
              "saifu",
              style: TextStyle(fontSize: 35, color: Colors.black),
            ),
          ),

/* 
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(35.0),
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black, blurRadius: 35.0, offset: Offset(0.0, 0.75))
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
          */
          floatingActionButton: _selectedIndex == 0
              ? FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
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
                                child: Column(mainAxisSize: MainAxisSize.min, children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(20.0),
                                  child: SafeArea(
                                      child: Center(
                                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                                    IntrinsicWidth(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(180, 220, 220, 220).withOpacity(0.1),
                                            border: new Border.all(
                                              color: Color.fromARGB(180, 220, 220, 220).withOpacity(0.0),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: TextButton(
                                              style: ButtonStyle(
                                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => ImportQrcodeScanner()));
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Scan security words",
                                                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                                                  ),
                                                  Spacer(),
                                                  Icon(
                                                    Icons.qr_code_scanner_rounded,
                                                    color: Colors.black,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(180, 220, 220, 220).withOpacity(0.1),
                                                border: new Border.all(
                                                  color: Color.fromARGB(180, 220, 220, 220).withOpacity(0.0),
                                                  width: 1,
                                                ),
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                              ),
                                              child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: TextButton(
                                                      style: ButtonStyle(
                                                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                      ),
                                                      onPressed: () {
                                                        //Navigator.pop(context);
                                                        showModalBottomSheet(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                                            ),
                                                            isScrollControlled: true,
                                                            isDismissible: true,
                                                            context: context,
                                                            builder: (context) => InputMnemonic());
                                                      },
                                                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                                                        Text(
                                                          "Input security words",
                                                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                                                        ),
                                                        Spacer(),
                                                        Icon(
                                                          Icons.arrow_forward_ios_rounded,
                                                          color: Colors.black,
                                                        )
                                                      ]))))),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromRGBO(134, 53, 213, 1),
                                                    Color.fromRGBO(85, 53, 214, 1),
                                                    Color.fromRGBO(7, 200, 248, 1),
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.1),
                                                    spreadRadius: 2,
                                                    blurRadius: 7,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: TextButton(
                                                      style: ButtonStyle(
                                                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).push(CupertinoPageRoute(builder: (context) => CreateMnemonic()));
                                                      },
                                                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                                                        Text(
                                                          "Create security words",
                                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                                        ),
                                                        Spacer(),
                                                        Icon(
                                                          Icons.arrow_forward_ios_rounded,
                                                          color: Colors.white,
                                                        )
                                                      ])))))
                                    ]))
                                  ]))))
                            ])));
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.purple,
                    size: 30,
                  ),
                  backgroundColor: Colors.grey[100],
                  elevation: 5,
                  splashColor: Colors.grey,
                )
              : Container(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                  ),
                ),
          //floatingActionButtonLocation: FloatingActionButtonLocation,
          body: Container(margin: EdgeInsets.only(top: 10.0, bottom: 10.0), color: Colors.grey[100], child: _widgetOptions.elementAt(_selectedIndex))),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.About) {}
    if (choice == Constants.Change) {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          isScrollControlled: true,
          isDismissible: true,
          context: context,
          builder: (context) => ChanagePasswordModal());
    }
  }
}

/*
Widget _showIndicator(bool show) {
  return show
      ? Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(Icons.brightness_1, size: 10, color: Colors.black),
        )
      : SizedBox();
}
*/
