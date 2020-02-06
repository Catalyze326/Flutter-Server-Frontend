import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

///runs MyApp and Initalize the code for sending notifications
void main() {
//Initalize the code for sending notifications
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.init("ad242baa-2f13-4d13-b062-e56f94e79d2c", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: true
  });
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
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
      home: MyHomePage(title: 'Server Frontend'),
    );
  }
}

///Mezzanine page
class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// Microcenter page
class _MyHomePageState extends State<MyHomePage> {
  Function eq = const ListEquality().equals;
  List<String> items = List<String>();
  List<String> tempItems = List<String>();
  String title;
  String url = 'http://youcantblock.me';
  Map map = {
    "action": {"microcenter": "update"}
  };

  ///Grab the json from the server and update items
  /// and then send a notification when need be
  void getAPIData() {
    apiRequest(url, map).then((s) {
      tempItems = List<String>();
      var parsedJson = json.decode(s);
      for (var item in parsedJson) {
        item.toString().split(",").forEach((value) {
          var val = value.replaceAll("{", " ").replaceAll("}", "");
          tempItems.add(val);
          print(val);
        });
        tempItems.add(
            " 13 : : ______________________________________________________\n");
      }
      if (!eq(tempItems, items) && !items.isNotEmpty) {
        OneSignal();
        items = tempItems;
        var notification =
            OSCreateNotification(content: "There are new microcenter items");
        var players = List<String>();
//      the emulater
        players.add("610dad03-792c-4005-aa37-e80e8bdcb608");
//      my phone
        players.add("f965fbba-e53f-406e-b5c4-ee0aa5edd948	");
        notification.playerIds = players;
        OneSignal().postNotification(notification);
      } else if (items.isEmpty) items = tempItems;
    });
  }

  /// Sends the tcp packet to the server and gets the response that has the data
  Future<String> apiRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  @override
  Widget build(BuildContext context) {
    getAPIData();
//    print(items);
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: AutoSizeText(
                "Microcenter",
                style: TextStyle(fontSize: 23),
                minFontSize: 8,
                maxLines: 2,
              ),
              onTap: () {},
            )
          ],
        ),
      ),
      body: PrintData(items: items),
      floatingActionButton: FloatingActionButton(
        onPressed: getAPIData,
        tooltip: 'send',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/// Creates the list of items
class PrintData extends StatelessWidget {
  List<String> items = List<String>();
  RegExp regExp = new RegExp("[0-9]");

  PrintData({this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Center(
                  child: (regExp.hasMatch(items[index].split(":")[0]))
                      ? AutoSizeText(
                          "${items[index].split(":")[2]}\n",
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
                              "${items[index].split(":")[2]}:${items[index].split(":")[3]}"),
                        ));
            }));
  }
}
