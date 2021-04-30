import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatefulWidget {
  String text;
  double style;
  dynamic onButtonClick;
  CustomButton({this.onButtonClick, this.style, this.text});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return widget.style == 1
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                widget.onButtonClick();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                child: Text(
                  widget.text,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  side: MaterialStateProperty.all(
                    BorderSide.lerp(
                        BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.black,
                          width: 1.5,
                        ),
                        BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.black,
                          width: 1.5,
                        ),
                        1.5),
                  ),
                  overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    //if (states.contains(MaterialState.focused)) return Colors.red;
                    //if (states.contains(MaterialState.hovered)) return Colors.white;
                    //if (states.contains(MaterialState.pressed)) return Colors.white;
                    return null; // Defer to the widget's default.
                  })),
            ),
          )
        : widget.style == 2
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    widget.onButtonClick();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                    child: Text(
                      widget.text,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    side: MaterialStateProperty.all(
                      BorderSide.lerp(
                          BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.black,
                            width: 1.5,
                          ),
                          BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.black,
                            width: 1.5,
                          ),
                          1.5),
                    ),
                  ),
                ),
              )
            : widget.style == 3
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        widget.onButtonClick();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                        child: Text(
                          widget.text,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[100]),
                        side: MaterialStateProperty.all(
                          BorderSide.lerp(
                              BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.grey[100],
                                width: 1.5,
                              ),
                              BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.grey[100],
                                width: 1.5,
                              ),
                              1.5),
                        ),
                      ),
                    ),
                  )
                : widget.style == 4
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            widget.onButtonClick();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                            child: Text(
                              widget.text,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            side: MaterialStateProperty.all(
                              BorderSide.lerp(
                                  BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey[100],
                                    width: 1.5,
                                  ),
                                  BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey[100],
                                    width: 1.5,
                                  ),
                                  1.5),
                            ),
                          ),
                        ),
                      )
                    : widget.style == 5
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                widget.onButtonClick();
                              },
                              child: Text(
                                widget.text,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                  side: MaterialStateProperty.all(
                                    BorderSide.lerp(
                                        BorderSide(
                                          style: BorderStyle.solid,
                                          color: Colors.black,
                                          width: 1.5,
                                        ),
                                        BorderSide(
                                          style: BorderStyle.solid,
                                          color: Colors.black,
                                          width: 1.5,
                                        ),
                                        1.5),
                                  ),
                                  overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                    //if (states.contains(MaterialState.focused)) return Colors.red;
                                    //if (states.contains(MaterialState.hovered)) return Colors.white;
                                    //if (states.contains(MaterialState.pressed)) return Colors.white;
                                    return null; // Defer to the widget's default.
                                  })),
                            ),
                          )
                        : Container();
  }
}
