import 'package:flutter/material.dart';

class MyPlayerInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPlayerInfoState();
  }
}

class _MyPlayerInfoState extends State<MyPlayerInfo> {

  final _imageName = 'ic_Comment@3x.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.red,
          child: Row(
            children: <Widget>[
              buildButtonWithImageAndTitle(_imageName, '评论'),
              buildButtonWithImageAndTitle(_imageName, '收藏'),
              buildButtonWithImageAndTitle(_imageName, '缓存'),
              buildButtonWithImageAndTitle(_imageName, '分享'),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          height: 128,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          color: Colors.red,
        ),
      ],
    );
  }

  Widget buildButtonWithImageAndTitle(String imageName, String title) {
    return GestureDetector(
      onTap: () {
        handleButtonClick(title);
      },
      child: Column(
        children: <Widget>[
          Image.asset(imageName),
          Text(
            title,
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  void handleButtonClick(String title) {
    print('Clicked at $title');
  }
}
