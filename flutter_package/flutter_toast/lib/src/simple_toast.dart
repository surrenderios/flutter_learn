import 'package:flutter/material.dart';

class SimpleToast extends StatefulWidget{
  final String toastStr;
  final Color textColor;
  final double fontSize;

  SimpleToast({
    Key key,
    this.toastStr = 'This is SimpleToast',
    this.textColor = Colors.black,
    this.fontSize = 20.0,
  }) :  assert ( toastStr != null),
        assert ( textColor != null),
        assert ( fontSize != null),
        super(key:key);


  @override
  State<StatefulWidget> createState() {
    return new _SimpleToast();
  }
}

class _SimpleToast extends State<SimpleToast>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: new Text(
        widget.toastStr,
        style: new TextStyle(
            fontSize: widget.fontSize,
            color: widget.textColor),
      ),
    );
  }
}
