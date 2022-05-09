import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/retry.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/models/UpdateProModel.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  static String tag='/ChangePasswordScreen';
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var passwordCont = TextEditingController();
  var confirmPasswordCont = TextEditingController();
  bool _showPassword = false;
  bool _showCnfrmPassword = false;
  // ShLoginModel cat_model;
  final _formKey = GlobalKey<FormState>();
  UpdateProModel? updateProModel;



  Future<String?> MyCheck() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // EasyLoading.show(status: 'Please wait...');
    FirebaseFirestore.instance
        .collection('Customers')
        .where('Email', isEqualTo: updateProModel!.data!.email!)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        documentSnapshot.reference.update({
          'Password': passwordCont.text!,
        });
      });
    });


    EasyLoading.dismiss();
    Navigator.pop(context);

  }

  Future<String?> getUpdate() async {
    EasyLoading.show(status: 'Please wait...');
    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      // String UserId = prefs.getString('UserId');
      String? token = prefs.getString('token');
      // add_from=prefs.getString("from");
      String? UserPassword=prefs.getString("UserPassword");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final msg = jsonEncode({"email": prefs.getString('UserEmail'), "password": passwordCont.text, "confirm_password": confirmPasswordCont.text,
        "name": prefs.getString('UserName'), "phone": prefs.getString('UserPhone'), "country": prefs.getString('UserCountry')});


      final client = RetryClient(http.Client());
      var response;
      try {
        response=await client.post(
            Uri.parse(
                'https://strapit.rcstaging.co.in/strapit/public/api/editProfile'),
            headers: headers,
            body: msg);
      } finally {
        client.close();
      }



      final jsonResponse = json.decode(response.body);
      print('not json regi$jsonResponse');
      print('Response bodyregi: ${response.body}');
      if (response.statusCode == 200) {
        //
        updateProModel = new UpdateProModel.fromJson(jsonResponse);
        prefs.setString('UserName', updateProModel!.data!.name.toString());
        prefs.setString('UserEmail', updateProModel!.data!.email.toString());
        prefs.setString('UserCountry', updateProModel!.data!.country!);
        prefs.setString('UserPhone', updateProModel!.data!.phone!);

        MyCheck();

        toast(updateProModel!.message);
// Navigator.pop(context);
        print('sucess');
      } else {
        EasyLoading.dismiss();
        // err_model = new ShLoginErrorNewModel.fromJson(jsonResponse);
        //
        // toast(err_model!.message);
        // toast('Something Went Wrong');
//        print("cat dta$cat_model");

      }
      return "cat_model";
    } catch (e) {
      EasyLoading.dismiss();
      print('caught error $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    final node = FocusScope.of(context);

    return Scaffold(
      backgroundColor: sh_white,
      appBar: AppBar(
        elevation: 0,
        title: Text("Change Password",style: TextStyle(color: sh_app_txt_color,fontSize: 24,fontFamily: 'Bold'),),
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actionsIconTheme: IconThemeData(color: sh_white),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: sh_white,
              padding: EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                        'Your new password must be different from previous used password',
                        style: TextStyle(
                            color: sh_colorPrimary2,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(
                        spacing_standard_new,2,
                        spacing_standard_new,2),
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
                  SizedBox(height: 12,),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        spacing_standard_new,2,
                        spacing_standard_new,2),
                    decoration:
                    BoxDecoration(border: Border.all(color: sh_app_black, width: 1.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          onEditingComplete: () =>
                              node.nextFocus(),
                          obscureText: !this._showCnfrmPassword,
                          controller: confirmPasswordCont,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          cursorColor: sh_app_txt_color,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: this._showCnfrmPassword ? sh_colorPrimary2 : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => this._showCnfrmPassword = !this._showPassword);
                              },
                            ),
                            labelText: "Confirm Password",
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
                      getUpdate();
// MyCheck();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          top: 6, bottom: 10),
                      decoration: boxDecoration(
                          bgColor: sh_btn_color, radius: 10, showShadow: true),
                      child: text("Update",
                          fontSize: 24.0,
                          textColor: sh_app_txt_color,
                          isCentered: true,
                          fontFamily: 'Bold'),
                    ),
                  ),





                ],
              ),

            ),
          )),
    );

  }
}
