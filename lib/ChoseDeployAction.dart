import 'package:flutter/material.dart';
import 'package:server_frontend/main.dart';
import 'globals.dart' as globals;

class ChoseDeployAction extends StatefulWidget {
  @override
  _ChoseDeployAction createState() => _ChoseDeployAction();
}

class _ChoseDeployAction extends State<ChoseDeployAction> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Deploy';
    return Center(
        child: Container(
            height: 50,
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 2,
              elevation: 16,
              style: TextStyle(color: Colors.white),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String newValue) {
                setState(() {
                  globals.apiRequest(globals.url, {
                    "addAutoDeploymentEngineCommand": {
                      "server": {globals.activeDeployment: { newValue.toLowerCase() : ("git@github.com:Catalyze326/" + globals.activeRepo + ".git")}}
                    }
                  }).then((value) => print("jkhkjhkjhkjhkjhk" + value));
                  print({
                    "addAutoDeploymentEngineCommand": {
                      "server": {globals.activeDeployment: { newValue.toLowerCase() : ("git@github.com:Catalyze326/" + globals.activeRepo + ".git")}}
                    }
                  });
                });
                globals.section = globals.Section.AutoDeploy;
                main();
              },
              items: <String>["Deploy", "Start", "Stop", "Restart"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.split("*")[0],
                  child: Text(value.split("*")[0]),
                );
              }).toList(),
            )));
  }
}
