import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/screens/LoginScreen.dart';
import 'package:strapit/screens/ManageBackupScreen.dart';
import 'package:strapit/screens/ManageTicketScreen.dart';
import 'package:strapit/screens/MyPortalScreen.dart';
import 'package:strapit/screens/ProfileScreen.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';

class CustmerDashoardScreen extends StatefulWidget {
  static String tag='/CustmerDashoardScreen';
  const CustmerDashoardScreen({Key? key}) : super(key: key);

  @override
  _CustmerDashoardScreenState createState() => _CustmerDashoardScreenState();
}

class _CustmerDashoardScreenState extends State<CustmerDashoardScreen> {

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

    void _openCustomDialog() {
      showGeneralDialog(barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  title: Center(child: Column(
                    children: [
                      Text('Logout',style: TextStyle(color: sh_app_black,fontSize: 28,fontFamily: 'Bold'),textAlign: TextAlign.center,),
                      SizedBox(height: 8,),
                      Text('Are you sure,do you want to logout?',style: TextStyle(color: sh_app_black,fontSize: 18,fontFamily: 'Bold'),textAlign: TextAlign.center,),
                    ],
                  )),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: () async {
                          // BecameSeller();
                          Navigator.of(context, rootNavigator: true).pop();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('UserId', "");
                          prefs.setString('token', "");

                          Route route = MaterialPageRoute(
                              builder: (context) => LoginScreen());
                          Navigator.pushReplacement(context, route);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width*.7,
                          padding: EdgeInsets.only(
                              top: 6, bottom: 10),
                          decoration: boxDecoration(
                              bgColor: sh_btn_color, radius: 10, showShadow: true),
                          child: text("Logout",
                              fontSize: 16.0,
                              textColor: sh_app_black,
                              isCentered: true,
                              fontFamily: 'Bold'),
                        ),
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width*.7,
                          padding: EdgeInsets.only(
                              top: 6, bottom: 10),
                          decoration: BoxDecoration(
                            color: sh_white,border: Border.all(color: sh_app_black, width: 1.0),borderRadius: BorderRadius.circular(8),),
                          child: text("Cancel",
                              fontSize: 16.0,
                              textColor: sh_app_black,
                              isCentered: true,
                              fontFamily: 'Bold'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {
            return Container();
          });
    }


    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          color: sh_semi_white
          ,
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
                          // SharedPreferences prefs = await SharedPreferences.getInstance();
                          // prefs.setString('UserId', "");
                          //
                          // Route route = MaterialPageRoute(
                          //     builder: (context) => LoginScreen());
                          // Navigator.pushReplacement(context, route);
                          _openCustomDialog();
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
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () {
                    launchScreen(context, ProfileScreen.tag);
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
                        Text("My\nProfile",textAlign: TextAlign.center,style: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular',fontSize: 30,),),

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
