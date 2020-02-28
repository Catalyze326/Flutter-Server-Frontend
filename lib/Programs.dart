import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'globals.dart' as globals;

class Programs extends StatefulWidget {
  final String title;

  Programs({Key key, this.title}) : super(key: key);

  @override
  _Programs createState() => _Programs();
}

class _Programs extends State<Programs> {
  RegExp regExp = new RegExp("[0-9]");

  getAllPrograms() async {
    setState(() {
      globals.apiRequest(globals.url, {
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
    globals.apiRequest(globals.url, map);
  }

  Widget returnText(String s) {
    print(s + "\n" + new DateTime.now().millisecondsSinceEpoch.toString());
    try {
      if (int.parse(s.split(".")[0]) >
          new DateTime.now().millisecondsSinceEpoch - (10 * 1000)) {
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