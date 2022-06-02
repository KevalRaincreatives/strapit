import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:strapit/screens/AddCustomerScreen.dart';
import 'package:strapit/screens/AddPortalScreen.dart';
import 'package:strapit/screens/AddTicketScreen.dart';
import 'package:strapit/screens/AdminDashoardScreen.dart';
import 'package:strapit/screens/ChangePasswordScreen.dart';
import 'package:strapit/screens/CustmerDashoardScreen.dart';
import 'package:strapit/screens/CustomerListScreen.dart';
import 'package:strapit/screens/EditPortalScreen.dart';
import 'package:strapit/screens/LocalAutScreen.dart';
import 'package:strapit/screens/LoginScreen.dart';
import 'package:strapit/screens/ManageBackupScreen.dart';
import 'package:strapit/screens/ManageTicketScreen.dart';
import 'package:strapit/screens/MyPortalScreen.dart';
import 'package:strapit/screens/ProfileScreen.dart';
import 'package:strapit/screens/SplashScreens.dart';
import 'package:strapit/screens/TicketDetailScreen.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:local_auth/local_auth.dart';

Future<void>  main() async {
  bool isInDebugMode = false;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_messageHandler);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: sh_colorPrimary2,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    runZoned(() {
      runApp(MyApp(),
      );
      // configLoading();
    });
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

  // This widget is the root of your application.

class _MyAppState extends State<MyApp> {
  final LocalAuthentication auth = LocalAuthentication();

  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    setState(
            () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }
//flutterant - Biometric Authentication

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrapIT',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
initialRoute: SplashScreens.tag,
      routes: {
        LoginScreen.tag: (BuildContext contex) => LoginScreen(),
        SplashScreens.tag: (BuildContext contex) => SplashScreens(),
        AdminDashoardScreen.tag: (BuildContext contex) => AdminDashoardScreen(),
        CustomerListScreen.tag: (BuildContext contex) => CustomerListScreen(),
        AddCustomerScreen.tag: (BuildContext contex) => AddCustomerScreen(),
        ManageBackupScreen.tag: (BuildContext contex) => ManageBackupScreen(),
        ManageTicketScreen.tag: (BuildContext contex) => ManageTicketScreen(),
        AddTicketScreen.tag: (BuildContext contex) => AddTicketScreen(),
        // TicketDetailScreen.tag: (BuildContext contex) => TicketDetailScreen(title: 'title',userby: "",datetimes: "",),
        CustmerDashoardScreen.tag: (BuildContext contex) => CustmerDashoardScreen(),
        LocalAutScreen.tag: (BuildContext contex) => LocalAutScreen(),
        ProfileScreen.tag: (BuildContext contex) => ProfileScreen(),
        MyPortalScreen.tag: (BuildContext contex) => MyPortalScreen(),
        AddPortalScreen.tag: (BuildContext contex) => AddPortalScreen(),
        EditPortalScreen.tag: (BuildContext contex) => EditPortalScreen(),
        ChangePasswordScreen.tag: (BuildContext contex) => ChangePasswordScreen(),


      },
      debugShowCheckedModeBanner: false,
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Biometric Authentication'),
      //   ),
      //   body: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text('Current State: $_authorized\n'),
      //         (_isAuthenticating)
      //             ? ElevatedButton(
      //           onPressed: _cancelAuthentication,
      //           child: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Text("Cancel Authentication"),
      //               Icon(Icons.cancel),
      //             ],
      //           ),
      //         )
      //             : Column(
      //           children: [
      //             ElevatedButton(
      //               child: Row(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Text('Authenticate'),
      //                   Icon(Icons.fingerprint),
      //                 ],
      //               ),
      //               onPressed: _authenticate,
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
