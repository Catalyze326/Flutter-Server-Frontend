import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'globals.dart' as globals;
import 'MainPage.dart';
import 'Microcenter.dart';
import 'AutoDeploy.dart';
import 'AutoStart.dart';
import 'Programs.dart';
import 'ChoseDeployAction.dart';

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
      home: AllPages(title: 'Server Frontend'),
    );
  }
}

class AllPages extends StatefulWidget {
  final String title;

  AllPages({Key key, this.title}) : super(key: key);

  @override
  _AllPages createState() => _AllPages();
}

class _AllPages extends State<AllPages> {

  _AllPages() {
    globals.updateAll();
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (globals.section) {
      case globals.Section.MainPage:
        body = MainPage();
        break;
      case globals.Section.Microcenter:
        body = Microcenter();
        break;
      case globals.Section.AutoStart:
        body = AutoStart();
        break;
      case globals.Section.Programs:
        body = Programs();
        break;
      case globals.Section.AutoDeploy:
        body = AutoDeploy();
        break;
      case globals.Section.ChoseDeployAction:
        body = ChoseDeployAction();
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
                "MainPage",
                style: TextStyle(fontSize: 23),
                minFontSize: 8,
                maxLines: 1,
              ),
              onTap: () {
                setState(() => globals.section = globals.Section.MainPage);
                Navigator.pop(context);
              },
            ),
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
            ListTile(
              title: AutoSizeText(
                "AutoDeploy",
                style: TextStyle(fontSize: 23),
                minFontSize: 8,
                maxLines: 1,
              ),
              onTap: () {
                setState(() => globals.section = globals.Section.AutoDeploy);
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
