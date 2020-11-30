import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sip_3_mobile/screens/change_password_page.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[300]),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Account',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Edit and manage your account details',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[50]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        elevation: 0.0,
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          splashColor: Colors.blue,
                          onTap: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                ),
                                isScrollControlled: true,
                                isDismissible: true,
                                context: context,
                                builder: (context) => ChanagePasswordModal());
                          },
                          child: ListTile(
                            title: Text('Password'),
                            subtitle: Text('Change your password'),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[300]),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Help and Feedback',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Reach us with your feedback and questions',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[50]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        elevation: 0.0,
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          splashColor: Colors.blue,
                          onTap: () {},
                          child: ListTile(
                            title: Text('FAQ and Guides'),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0.0,
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          splashColor: Colors.blue,
                          onTap: () {},
                          child: ListTile(
                            title: Text('Contact us'),
                            trailing: Icon(Icons.arrow_forward_ios),
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
}
