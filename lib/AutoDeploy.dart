import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class AutoDeploy extends StatefulWidget {
  final String title;

  AutoDeploy({Key key, this.title}) : super(key: key);

  @override
  _AutoDeploy createState() => _AutoDeploy();
}

class _AutoDeploy extends State<AutoDeploy> {
  RegExp regExp = new RegExp("[0-9]");
  String dropdownValue = 'Git Repos';

  getAllDeployments() async {
    while (globals.deployments.isEmpty) {
      setState(() {
        globals.apiRequest(globals.url, {
          "action": {"deployments": "update"}
        }).then((s) {
          s.split("*").forEach((value) {
            globals.deployments.add(value);
          });
        });
      });
    }
  }

  getRepos() async {
    while (globals.repos.isEmpty) {
      globals.repos = List<String>();
      var res = await http.get(
          'https://api.github.com/user/repos?access_token=YouThoughtYouWereGoingToGetThisLol');
      if (res.statusCode != 200)
        throw Exception('get error: statusCode= ${res.statusCode}');
      print(res.body);
      var jsonBody = json.decode(res.body);
      globals.repos.add('Git Repos*');
      for (var jsonItem in jsonBody)
        globals.repos.add(jsonItem["name"] + "*" + jsonItem["url"]);
      print(globals.repos);
    }
    addAction();
  }

  addAction() {
    setState(() {});
  }

  Widget createDeployment(String deploymentName) {
    print(globals.repos);
    if (globals.repos.isNotEmpty) {
      return Column(children: <Widget>[
        DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: globals.repos.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value.split("*")[0],
              child: Text(value),
            );
          }).toList(),
        )
      ]);
    } else {
      return (Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              deploymentName,
              style: TextStyle(fontSize: 28),
              minFontSize: 12,
              maxLines: 1,
            )
          ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    getRepos();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: globals.deployments.length != 0
            ? ListView.builder(
            itemCount: globals.repos.length,
            itemBuilder: (context, index) {
              return (Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    globals.deployments[index],
                    style: TextStyle(fontSize: 18),
                    minFontSize: 8,
                    maxLines: 2,
                  ),
                  createDeployment("Temp Name"),
                ],
              ));
            })
            : AutoSizeText(
          "No deployments yet",
          style: TextStyle(fontSize: 18),
          minFontSize: 8,
          maxLines: 2,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getRepos,
        tooltip: 'send',
        child: Icon(Icons.get_app),
      ),
    );
  }
}
