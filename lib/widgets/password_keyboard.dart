import 'package:flutter/material.dart';

class Numpad extends StatelessWidget {
  ///Space between buttons on the numpad grid.
  final bool enabledBiometric;
  final double innerPadding;

  ///Size of the text on the buttons in the numpad grid.
  final double buttonTextSize;
  final Color buttonColor;
  final Color textColor;
  final double height;
  final double width;
  final TextEditingController controller;
  final VoidCallback authenticationSelected;

  Numpad({Key key, @required this.controller, this.buttonColor, this.textColor, this.innerPadding = 4, this.buttonTextSize = 30, this.height = double.infinity, this.width = double.infinity, this.authenticationSelected, this.enabledBiometric}) : super(key: key);

  EdgeInsetsGeometry _buttonPadding() {
    return EdgeInsets.all(innerPadding);
  }

  Widget _buildNumButton({BuildContext context, int displayNum, Icon icon}) {
    Widget effectiveChild;
    int passNum = displayNum;
    if (icon != null) {
      effectiveChild = icon;
    } else {
      effectiveChild = Text(
        displayNum.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: buttonTextSize, color: textColor),
      );
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: _buttonPadding(),
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 0,
              spreadRadius: 0,
            )
          ]),
          child: TextButton(
              style: TextButton.styleFrom(
                primary: buttonColor,
              ),
              child: effectiveChild,
              onPressed: () => {
                    if (passNum == -2)
                      {
                        controller.clear(),
                      }
                    else
                      {
                        controller.text = controller.text + passNum.toString(),
                      }
                  }),
        ),
      ),
    );
  }

  Widget _buildNumRow(BuildContext context, List<int> numbers) {
    List<Widget> buttonList = numbers.map((buttonNum) => _buildNumButton(context: context, displayNum: buttonNum)).toList();
    return Container(
      child: Expanded(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.stretch, children: buttonList),
      ),
    );
  }

  Widget _buildSpecialRow(BuildContext context) {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: enabledBiometric
                  ? Container(padding: _buttonPadding(), child: TextButton(style: TextButton.styleFrom(shape: CircleBorder(side: BorderSide.none), primary: Colors.black, backgroundColor: Colors.white), child: Icon(Icons.fingerprint), onPressed: () => authenticationSelected()))
                  : Container(
                      padding: _buttonPadding(),
                      child: TextButton(
                          child: Container(
                            color: Colors.transparent,
                          ),
                          onPressed: () {})),
            ),
            _buildNumButton(context: context, displayNum: 0),
            _buildNumButton(
                context: context,
                displayNum: -2,
                icon: Icon(
                  Icons.clear,
                  size: buttonTextSize,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildNumPad(BuildContext context, BoxConstraints constraints) {
    return Container(
      height: height,
      width: width,
      padding: _buttonPadding(),
      child: LimitedBox(
        maxHeight: 500,
        maxWidth: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildNumRow(context, [
              1,
              2,
              3
            ]),
            _buildNumRow(context, [
              4,
              5,
              6
            ]),
            _buildNumRow(context, [
              7,
              8,
              9
            ]),
            _buildSpecialRow(context)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: _buildNumPad,
    );
  }
}
