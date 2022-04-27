import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/screens/CustomerListScreen.dart';
import 'package:strapit/screens/LoginScreen.dart';
import 'package:strapit/screens/ManageBackupScreen.dart';
import 'package:strapit/screens/ManageTicketScreen.dart';
import 'package:strapit/screens/MyPortalScreen.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';

class AdminDashoardScreen extends StatefulWidget {
  static String tag="/AdminDashoardScreen";
  const AdminDashoardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashoardScreenState createState() => _AdminDashoardScreenState();
}

class _AdminDashoardScreenState extends State<AdminDashoardScreen> {


  Future<bool> _onWillPop()  async{
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit an App'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => exit(0),
              /*Navigator.of(context).pop(true)*/
              child: Text('Yes'),
            ),
          ],
        ),
      ) ?? false;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(

      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          color: sh_semi_white,
          width: width,
          height: height,
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: width*.5,
                          child: Image.asset(sh_app_logo)),
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('UserId', "");
                          prefs.setString('token', "");

                          Route route = MaterialPageRoute(
                              builder: (context) => LoginScreen());
                          Navigator.pushReplacement(context, route);
                        },
                          child: Icon(Icons.logout,size: 40,color: sh_app_black,))
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Image.network("https://raincreatives.com/wp-content/uploads/2021/03/rc_logo_web_header.png"),
                  //   ],
                  // )
              ),

              Expanded(flex: 1, child: Container()),
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () {
                    launchScreen(context, CustomerListScreen.tag);
                  },
                  child: Container(
                    width: width*.6,
                    padding: EdgeInsets.fromLTRB(
                        spacing_standard_new,spacing_standard_new,
                        spacing_standard_new,spacing_standard_new),
                    decoration:
                    BoxDecoration(color: sh_white,border: Border.all(color: sh_app_black, width: 1.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Manage\nCustomers",textAlign: TextAlign.center,style: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular',fontSize: 30,),),

                      ],
                    ),
                  ),
                ),
              ),
Expanded(flex: 1, child: Container()),
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () {
                    // launchScreen(context, ManageBackupScreen.tag);
                    launchScreen(context, MyPortalScreen.tag);
                  },
                  child: Container(
                    width: width*.6,
                    padding: EdgeInsets.fromLTRB(
                        spacing_standard_new,spacing_standard_new,
                        spacing_standard_new,spacing_standard_new),
                    decoration:
                    BoxDecoration(color: sh_white,border: Border.all(color: sh_app_black, width: 1.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Manage\nPortal",textAlign: TextAlign.center,style: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular',fontSize: 30,),),

                      ],
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1, child: Container()),
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () {
                    launchScreen(context, ManageTicketScreen.tag);
                  },
                  child: Container(
                    width: width*.6,
                    padding: EdgeInsets.fromLTRB(
                        spacing_standard_new,spacing_standard_new,
                        spacing_standard_new,spacing_standard_new),
                    decoration:
                    BoxDecoration(color: sh_white,border: Border.all(color: sh_app_black, width: 1.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Manage\nTickets",textAlign: TextAlign.center,style: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular',fontSize: 30,),),

                      ],
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
