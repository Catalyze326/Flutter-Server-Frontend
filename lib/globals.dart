import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:collection/collection.dart';

String url = 'http://youcantblock.me:556/';
List<String> items = List<String>();
List<String> tempItems = List<String>();
List<String> devices = List<String>();
List<String> programs = List<String>();
List<String> deployments = List<String>();
List<String> repos = List<String>();
var reposJson;
Section section = Section.MainPage;

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

getAllDevices() async {
  apiRequest(url, {
    "action": {"devices": "update"}
  }).then((s) {
    s = s.substring(10, s.length - 2);
    devices = List<String>();
    var tempDevices = s.split("*");
    for (var i = 0; i < tempDevices.length; i++) {
      if (i & 1 == 1) tempDevices.add(tempDevices[i]);
    }
  });
  print(devices);
}

getAllPrograms() async {
  apiRequest(url, {
    "action": {"programs": "update"}
  }).then((s) {
    s = s.replaceAll(RegExp("[^a-zA-Z0-9,.:]"), "");
    print(s);
    programs = s.split(RegExp("[,:]"));
    print(programs);
  });
  print(programs);
}

getAllDeployments() async {
//  while (deployments.isEmpty) {
  apiRequest(url, {
    "action": {"deployments": "update"}
  }).then((s) {
    s.split("*").forEach((value) {
      deployments.add(value);
    });
  });
//  }
}

getAllItems() async {
  Map map = {
    "action": {"microcenter": "update"}
  };
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
          " 13 : : ____________________________________________________\n");
    }
    print(tempItems);
    Function eq = const ListEquality().equals;
    if (!eq(tempItems, items) && items.isNotEmpty) {
//        items = tempitems;
      var players = List<String>();
//      the emulater
      players.add("610dad03-792c-4005-aa37-e80e8bdcb608");
//      my phone
      players.add("f965fbba-e53f-406e-b5c4-ee0aa5edd948");
      var notification = OSCreateNotification(
          playerIds: players, content: "There are new microcenter items");
      OneSignal().postNotification(notification);
    }
    items = tempItems;
  });
}

void updateAll() async {
  getAllDeployments();
  getAllPrograms();
  getAllItems();
  getAllDevices();
}

enum Section {
  MainPage,
  Microcenter,
  AutoStart,
  Programs,
  AutoDeploy,
}
