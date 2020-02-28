import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'globals.dart' as globals;

class AutoStart extends StatefulWidget {
  final String title;

  AutoStart({Key key, this.title}) : super(key: key);

  @override
  _AutoStart createState() => _AutoStart();
}

class _AutoStart extends State<AutoStart> {
  RegExp regExp = new RegExp("[0-9]");

  getAllDevices() async {
    setState(() {
      globals.apiRequest(globals.url, {
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
    globals.apiRequest(globals.url, map);
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