import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/screens/AdminDashoardScreen.dart';
import 'package:strapit/screens/CustmerDashoardScreen.dart';
import 'package:strapit/screens/LocalAutScreen.dart';
import 'package:strapit/screens/LoginScreen.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';

class SplashScreens extends StatefulWidget {
  static String tag='/SplashScreens';
  const SplashScreens({Key? key}) : super(key: key);

  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  int mysec=3;

  @override
  void initState() {
    // TODO: implement initState
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        mysec--;

      });

      if(mysec==0){
    Check();

      }
    });
    super.initState();
  }

  Check() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('UserId', "");
    String? final_token = prefs.getString('token');

    if (final_token != null && final_token != '') {
      // int? isadmin = prefs.getInt('IsAdmin');
      if(prefs.getInt('IsAdmin')==1){
        launchScreen(context, AdminDashoardScreen.tag);
      }else{
        launchScreen(context, CustmerDashoardScreen.tag);
      }
    }else{
      launchScreen(context, LoginScreen.tag);
    }

    // if(prefs.getString('UserId')=='' ||prefs.getString('UserId')==null) {
    //   launchScreen(context, LoginScreen.tag);
    // }else{
    //   // launchScreen(context, LocalAutScreen.tag);
    //   if(prefs.getString('usertype')=='Admin') {
    //     launchScreen(context, AdminDashoardScreen.tag);
    //   }else{
    //       launchScreen(context, CustmerDashoardScreen.tag);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: sh_white,
        child: Stack(
          children: [Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("STRAP IT",style: TextStyle(color: sh_black,fontFamily: "ExtraBold",fontSize: 36),),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,10,10,6),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(50,50,50,10),
                      child: Image.asset(sh_app_logo)),
                ),
                Text("Disaster Recovery",style: TextStyle(color: sh_app_black,fontSize: 18,fontFamily: "Bold"),),
                SizedBox(height: 4,),
                Text("Anti Ransomware | Anti Malware",style: TextStyle(color: sh_app_black,fontSize: 16,fontFamily: "Bold"),)

              ],
            ),
          ),
            Positioned(
              bottom: 0,
right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(sh_rc_logo,height: 20,width: 20,),
                )
                // Image.network("https://raincreatives.com/wp-content/uploads/2021/03/rc_logo_web_header.png")
              )

          ],
        ),
      ),
    );
  }
}
