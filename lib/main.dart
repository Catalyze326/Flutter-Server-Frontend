import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title;
  String url = 'http://youcantblock.me';

  void _sendWebhook() {
    setState(() {
//      Map example = {'projects': {"projectName": "action", "projectName": "delete", "projectName": "update"}, "debug": "debugInfo"};
//      TODO have the server script update any new project types when a webhook is sent and write that to a json file
      Map map = {
        "action": {"microcenter": "update"}
      };
      List<String> litems;
      apiRequest(url, map).then((s) {
        var parsedJson = json.decode(s);
        for (var item in parsedJson) {
//          litems.add(item);
          item.toString().split(",").forEach((value) {
            print(value.replaceAll("{", " ").replaceAll("}", ""));
          });
          print("\n");
        }
      });
    });
  }

  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 1), () => "1");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> writeCounter(String s) async {
    final path = await _localPath;
    final file = File('$path/jsonReport.json');
    return file.writeAsString(s);
  }

  Future<String> apiRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text("Microcenter"),
              onTap: () {
                Map map = {
                  "action": {"microcenter": "update"}
                };
                apiRequest(url, map).then((s) {
                  var parsedJson = json.decode(s);
                  for (var item in parsedJson) {
                    item.toString().split(",").forEach((value) {
                      print(value.replaceAll("{", " ").replaceAll("}", ""));
                    });
                    print("\n");
                  }
                  Navigator.pop(context);
                });
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(
                "asdasdasdasd",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
//                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: _sendWebhook,
      tooltip: 'send',
      child: Icon(Icons.add),
    ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Multi Page Application Page-1"),
      ),
      body: new Text("Another Page...!!!!!!"),
    );
  }
}
