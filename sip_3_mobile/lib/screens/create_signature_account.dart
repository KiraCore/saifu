import 'package:flutter/material.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/widgets/create_pgp_widget.dart';

class SignatureAccount extends StatefulWidget {
  final String type;
  final String pubkey = '';
  final String privkey = '';
  SignatureAccount({this.type});

  @override
  _SignatureAccountState createState() => _SignatureAccountState();
}

class _SignatureAccountState extends State<SignatureAccount> {
  TextEditingController txtPubController = new TextEditingController();
  TextEditingController txtPrivController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return widget.type == 'PGP'
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(widget.type),
              elevation: 0.0,
              centerTitle: true,
            ),
            body: CreatePGPAccountForm(),
          )
        : Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back),
                        ),
                        title: Text(
                          widget.type,
                          textAlign: TextAlign.center,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.qr_code_rounded),
                          onPressed: () {},
                        ),
                      )),
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                child: Image.network('https://res-3.cloudinary.com/crunchbase-production/image/upload/c_lpad,h_256,w_256,f_auto,q_auto:eco/v1505765479/zghucdtjjevivjihplty.png'),
                              ),
                              Text(
                                'Public Address: ',
                                textAlign: TextAlign.center,
                              ),
                              Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  Card(
                                    color: greys,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(maxHeight: 60),
                                        child: TextField(
                                          showCursor: false,
                                          enabled: true,
                                          controller: txtPubController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.qr_code_scanner,
                                    ),
                                    onPressed: () {
                                      // Your codes...
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Private Address: ',
                                textAlign: TextAlign.center,
                              ),
                              Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  Card(
                                    color: greys,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(maxHeight: 60),
                                        child: TextField(
                                          showCursor: false,
                                          enabled: true,
                                          controller: txtPrivController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.qr_code_scanner),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {},
                            padding: EdgeInsets.all(15),
                            color: Colors.white,
                            textColor: Colors.black,
                            child: Text('Copy address'),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: () async {
                              print(txtPrivController.text);
                              print(txtPubController.text);
                              await storage.write(key: "keybasePub", value: txtPubController.text);
                              await storage.write(key: "keybasePriv", value: txtPrivController.text);
                            },
                            padding: EdgeInsets.all(15),
                            color: Colors.deepPurple,
                            textColor: Colors.white,
                            child: Text('Sign'),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
