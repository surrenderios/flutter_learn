import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangeLanguageState();
  }
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  int _selectedIndex;
  final _languages = <String>['English', '简体中文', '繁体中文', '俄语'];

  static const _channelName = 'com.iosapp.demo/change_language_init';
  static const _methodChannel = const MethodChannel(_channelName);

  static const _eventChannelName = 'com.iosapp.demo/change_language_event';
  static const EventChannel _eventChannel =
      const EventChannel(_eventChannelName);

  @override
  void initState() {
    super.initState();
    _eventChannel.receiveBroadcastStream(_eventChannelName).listen(_onInitData);
  }

  void _onInitData(Object index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _changeLanguage(int index) async {
    bool ret = await _methodChannel.invokeMethod('changeLanguage', index);
    if (ret == true) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      print('change language error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView.builder(
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                bool isSelected = (_selectedIndex == index);
                return ListTile(
                    leading: null,
                    title: Text(
                      _languages[index],
                      style: TextStyle(
                          color: isSelected ? Colors.red : Colors.black),
                    ),
                    selected: isSelected,
                    onTap: () {
                      if (!isSelected) {
                        _changeLanguage(index);
                      }
                    },
                    trailing: (isSelected) ? Icon(Icons.check_box) : null);
              }),
        ),
      ),
    );
  }
}
