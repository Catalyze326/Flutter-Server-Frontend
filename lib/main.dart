import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart' as globals;

//TODO fix the links
//TODO make new things come to the top

///runs MyApp and Initalize the code for sending notifications
void main() {
//Initalize the code for sending notifications
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.init("ad242baa-2f13-4d13-b062-e56f94e79d2c", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: true
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  runApp(MyApp());
}

/// Creates the root of the app
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
      ),
      home: MainPage(title: 'Server Frontend'),
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;

  MainPage({Key key, this.title}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (globals.section) {
      case globals.Section.Microcenter:
        body = Microcenter();
        break;
      case globals.Section.AutoStart:
        body = AutoStart();
        break;
      case globals.Section.Programs:
        body = Programs();
        break;
    }
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.fromLTRB(5, 20, 0, 0),
          children: <Widget>[
            ListTile(
              title: AutoSizeText(
                "Microcenter",
                style: TextStyle(fontSize: 23),
                minFontSize: 8,
                maxLines: 1,
              ),
              onTap: () {
                setState(() => globals.section = globals.Section.Microcenter);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: AutoSizeText(
                "AutoStart",
                style: TextStyle(fontSize: 23),
                minFontSize: 8,
                maxLines: 1,
              ),
              onTap: () {
                setState(() => globals.section = globals.Section.AutoStart);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: AutoSizeText(
                "Programs",
                style: TextStyle(fontSize: 23),
                minFontSize: 8,
                maxLines: 1,
              ),
              onTap: () {
                setState(() => globals.section = globals.Section.Programs);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: body,
      ),
    );
  }
}

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
  String url = 'http://youcantblock.me';
  Map map = {
    "action": {"microcenter": "update"}
  };

  ///Grab the json from the server and update globals.items
  /// and then send a notification when need be
  getAPIData() async {
    setState(() {
      globals.apiRequest(url, map).then((s) {
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
    getAPIData();
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
        onPressed: getAPIData,
        tooltip: 'send',
        child: Icon(Icons.get_app),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class AutoStart extends StatefulWidget {
  final String title;

  AutoStart({Key key, this.title}) : super(key: key);

  @override
  _AutoStart createState() => _AutoStart();
}

class _AutoStart extends State<AutoStart> {
  RegExp regExp = new RegExp("[0-9]");

  String url = 'http://youcantblock.me';

  getAllDevices() async {
    setState(() {
      globals.apiRequest(url, {
        "action": {"devices": "update"}
      }).then((s) {
        s = s.substring(10, s.length - 2);
        globals.devices = List<String>();
        var devices = s.split("*");
        for (var i = 0; i < devices.length; i++) {
          if (i & 1 == 1) globals.devices.add(devices[i]);
        }
      });
      print(globals.devices);
    });
  }

  sendRequest(Map map) {
    globals.apiRequest(url, map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: globals.devices.length != 0
            ? ListView.builder(
                itemCount: globals.devices.length,
                itemBuilder: (context, index) {
                  return (Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AutoSizeText(
                        globals.devices[index],
                        style: TextStyle(fontSize: 32),
                        minFontSize: 15,
                        maxLines: 1,
                      ),
                      FloatingActionButton(
                        onPressed: sendRequest(Map.of({
                          "action": {
                            "devices": {globals.devices[index]: "togglePower"}
                          }
                        })),
                        tooltip: 'togglePower',
                        child: Icon(Icons.power),
                      ),
                    ],
                  ));
                })
            : AutoSizeText(
                "No devices yet",
                style: TextStyle(fontSize: 18),
                minFontSize: 8,
                maxLines: 2,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getAllDevices,
        tooltip: 'send',
        child: Icon(Icons.get_app),
      ),
    );
  }
}

class Programs extends StatefulWidget {
  final String title;

  Programs({Key key, this.title}) : super(key: key);

  @override
  _Programs createState() => _Programs();
}

class _Programs extends State<Programs> {
  RegExp regExp = new RegExp("[0-9]");

  String url = 'http://youcantblock.me';

  getAllPrograms() async {
    setState(() {
      globals.apiRequest(url, {
        "action": {"programs": "update"}
      }).then((s) {
        s = s.replaceAll(RegExp("[^a-zA-Z0-9,.:]"), "");
        print(s);
        globals.programs = s.split(RegExp("[,:]"));
        print(globals.programs);
      });
      print(globals.programs);
    });
  }

  sendRequest(Map map) {
    globals.apiRequest(url, map);
  }

  Widget returnText(String s) {
    try {
      if (int.parse(s.split(".")[0]) >
          new DateTime.now().millisecondsSinceEpoch - (60 * 1000 * 2)) {
        return AutoSizeText("Running\n",
            style: TextStyle(color: Colors.green, fontSize: 32));
      } else {
        return AutoSizeText("Stalled\n",
            style: TextStyle(color: Colors.red, fontSize: 32));
      }
    } catch (ignore) {
      return AutoSizeText(s,
          style: TextStyle(fontSize: 32), minFontSize: 15, maxLines: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    getAllPrograms();
    print(globals.programs);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: globals.programs.length != 0
            ? ListView.builder(
                itemCount: globals.programs.length,
                itemBuilder: (context, index) {
                  return (Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      returnText(globals.programs[index]),
                    ],
                  ));
                })
            : AutoSizeText(
                "No programs yet",
                style: TextStyle(fontSize: 18),
                minFontSize: 8,
                maxLines: 2,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getAllPrograms,
        tooltip: 'send',
        child: Icon(Icons.get_app),
      ),
    );
  }
}
