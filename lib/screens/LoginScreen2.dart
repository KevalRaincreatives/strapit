import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/screens/AdminDashoardScreen.dart';
import 'package:strapit/screens/CustmerDashoardScreen.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';
import 'package:strapit/utils/auth_service.dart';
import 'package:strapit/utils/database_service.dart';

class LoginScreen extends StatefulWidget {
  static String tag='/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  var emailCont = TextEditingController();
  var passwordCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  final AuthService _auth = AuthService();


  Future<String?> getLogin() async {
    // Dialogs.showLoadingDialog(context, _keyLoader);
    EasyLoading.show(status: 'Loading...');

    try {
        // printAllLogs();
        try {
          // setUpLogs();

          // await FirebaseFirestore.instance
          //     .collection('Users')
          //     .where('Email', isEqualTo: emailCont.text).snapshots();
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('Users').where('Email', isEqualTo: emailCont.text).get();

          if(snapshot.docs.length>0) {
            if(snapshot.docs[0]['Password']==passwordCont.text) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("username", snapshot.docs[0]['Name']);
              prefs.setString("usertype", snapshot.docs[0]['Type']);
              prefs.setString("userCountry", snapshot.docs[0]['Country']);
              prefs.setString("userEmail", snapshot.docs[0]['Email']);
              prefs.setString("userPhone", snapshot.docs[0]['Phone']);
              prefs.setString("userPlanDate", snapshot.docs[0]['PlanDate']);
              prefs.setString("userWebsite", snapshot.docs[0]['Website']);
              prefs.setString('UserId', snapshot.docs[0]['UserId']);


              EasyLoading.dismiss();

              if (snapshot.docs[0]['Type'] == 'Admin') {
                launchScreen(context, AdminDashoardScreen.tag);
              } else {
                launchScreen(context, CustmerDashoardScreen.tag);
              }
            }else{
              EasyLoading.dismiss();
              toast("Password is in correct");
            }
          }else{
            EasyLoading.dismiss();
            toast("User Not Found");

          }


        } catch (e) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('UserId', "");
          EasyLoading.dismiss();
          toast("Something went wrong");

        }



      return "null";
    } catch (e) {
      EasyLoading.dismiss();
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: width*.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        spacing_standard_new,8,
                        spacing_standard_new,8),
                    decoration:
                    BoxDecoration(border: Border.all(color: sh_app_black, width: 1.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          onEditingComplete: () =>
                              node.nextFocus(),
                          controller: emailCont,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Username';
                            }
                            return null;
                          },
                          cursorColor: sh_app_txt_color,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                            hintText: "Email/Username",
                            hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                            labelText: "Email/Username",
                            labelStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Bold'),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: sh_transparent, width: 1.0),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:  BorderSide(color: sh_transparent, width: 1.0),
                            ),
                          ),
                          maxLines: 1,
                          style: TextStyle(color: sh_app_txt_color,fontFamily: 'Bold'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 26,),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        spacing_standard_new,8,
                        spacing_standard_new,8),
                    decoration:
                    BoxDecoration(border: Border.all(color: sh_app_black, width: 1.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          onEditingComplete: () =>
                              node.nextFocus(),
                          obscureText: !this._showPassword,
                          controller: passwordCont,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          cursorColor: sh_app_txt_color,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                            hintText: "Password",
                            hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: this._showPassword ? sh_colorPrimary2 : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => this._showPassword = !this._showPassword);
                              },
                            ),
                            labelText: "Password",
                            labelStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Bold'),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: sh_transparent, width: 1.0),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:  BorderSide(color: sh_transparent, width: 1.0),
                            ),
                          ),
                          maxLines: 1,
                          style: TextStyle(color: sh_app_txt_color,fontFamily: 'Bold'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 42,),
                  InkWell(
                    onTap: () async {
                      // launchScreen(context, AdminDashoardScreen.tag);
                      getLogin();
                      // if (_formKey.currentState!.validate()) {
                      //   // TODO submit
                      //   FocusScope.of(context).requestFocus(FocusNode());
                      // toast(selectedReportList.join(" , "));
                      // for (var i = 0; i < selectedReportList.length; i++) {
                      //   addProCatModel.add(new AddProCategoryModel(id: selectedReportList[i]));
                      // }
                      // toast(itemsModel.length.toString());
                      // AddProduct();
                      // }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width*.8,
                      padding: EdgeInsets.only(
                          top: 6, bottom: 10),
                      decoration: boxDecoration(
                          bgColor: sh_btn_color, radius: 10, showShadow: true),
                      child: text("Log In",
                          fontSize: 24.0,
                          textColor: sh_app_txt_color,
                          isCentered: true,
                          fontFamily: 'Bold'),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
