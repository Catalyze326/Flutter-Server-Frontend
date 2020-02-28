import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart' as globals;

///Mezzanine page
class Microcenter extends StatefulWidget {
  final String title;

  Microcenter({Key key, this.title}) : super(key: key);

  @override
  _Microcenter createState() => _Microcenter();
}

/// Microcenter page
class _Microcenter extends State<Microcenter> {
  Function eq = const ListEquality().equals;

  String title;
  RegExp regExp = new RegExp("[0-9]");
  Map map = {
    "action": {"microcenter": "update"}
  };

  ///Grab the json from the server and update globals.items
  /// and then send a notification when need be
  getItems() async {
    setState(() {
      globals.apiRequest(globals.url, map).then((s) {
        globals.tempItems = List<String>();
        var parsedJson = json.decode(s);
        for (var item in parsedJson) {
          item.toString().split(",").forEach((value) {
            var val = value.replaceAll("{", " ").replaceAll("}", "");
            globals.tempItems.add(val);
            print(val);
          });
          globals.tempItems.add(
              " 13 : : ____________________________________________________\n");
        }
        print(globals.tempItems);
        if (!eq(globals.tempItems, globals.items) && globals.items.isNotEmpty) {
//        globals.items = tempglobals.items;
          var players = List<String>();
//      the emulater
          players.add("610dad03-792c-4005-aa37-e80e8bdcb608");
//      my phone
          players.add("f965fbba-e53f-406e-b5c4-ee0aa5edd948");
          var notification = OSCreateNotification(
              playerIds: players, content: "There are new microcenter items");
          OneSignal().postNotification(notification);
        }
        globals.items = globals.tempItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getItems();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: ListView.builder(
            itemCount: globals.items.length,
            itemBuilder: (context, index) {
              return Center(
                  child: (regExp.hasMatch(globals.items[index].split(":")[0]))
                      ? AutoSizeText(
                    "${globals.items[index].split(":")[2]}\n",
                    style: TextStyle(fontSize: 18),
                    minFontSize: 8,
                    maxLines: 2,
                  )
                      : InkWell(
                    child: AutoSizeText(
                      "Link",
                      style: TextStyle(fontSize: 20),
                      maxLines: 2,
                    ),
                    onTap: () => launch(
                        "${globals.items[index].split(":")[2]}:${globals.items[index].split(":")[3]}"),
                  ));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getItems,
        tooltip: 'send',
        child: Icon(Icons.get_app),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}