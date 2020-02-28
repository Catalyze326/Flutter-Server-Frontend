import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

///Mezzanine page
class MainPage extends StatefulWidget {
  final String title;

  MainPage({Key key, this.title}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

/// Mezzanine page
class _MainPage extends State<MainPage> {

  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Center(
              child: (AutoSizeText(
                "Pick one of the pages",
                style: TextStyle(fontSize: 30),
                minFontSize: 12,
                maxLines: 1,
              )))),
    );
  }
}