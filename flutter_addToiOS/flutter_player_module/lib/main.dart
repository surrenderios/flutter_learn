import 'dart:ui' as appContext;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'my_player.dart';
import 'change_language.dart';

const String _kReloadChannelName = 'reload';
const BasicMessageChannel<String> _kReloadChannel =
    BasicMessageChannel<String>(_kReloadChannelName, StringCodec());

void main() {
  _kReloadChannel.setMessageHandler(run);
  run(appContext.window.defaultRouteName);
}

Future<String> run(String name) {
  switch (name) {
    case 'my_player':
      runApp(MyPlayer());
      break;
    case 'change_language':
      runApp(ChangeLanguage());
      break;
    default:
      runApp(PlaceHolderApp());
  }
}

Widget PlaceHolderApp() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text('Route is /'),
      ),
    ),
  );
}
