import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/retry.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/models/UpdateProModel.dart';
import 'package:strapit/screens/ChangePasswordScreen.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  static String tag='/ProfileScreen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var emailCont = TextEditingController();
  var passwordCont = TextEditingController();
  var phoneCont = TextEditingController();
  var websiteCont = TextEditingController();
  var nameCont = TextEditingController();
  var plandateCont = TextEditingController();
  var countryCont = TextEditingController();
  UpdateProModel? updateProModel;


  Future<String?> fetchadd() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      emailCont.text = prefs.getString('UserEmail')!;
      phoneCont.text = prefs.getString('UserPhone')!;
      // websiteCont.text = prefs.getString('userWebsite')!;
      nameCont.text = prefs.getString('UserName')!;
      // plandateCont.text = prefs.getString('userPlanDate')!;
      countryCont.text = prefs.getString('UserCountry')!;
      return '';
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<String?> MyCheck() async{
    // EasyLoading.show(status: 'Please wait...');
    FirebaseFirestore.instance
        .collection('Customers')
        .where('Email', isEqualTo: emailCont.text)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        documentSnapshot.reference.update({
          'Phone': updateProModel!.data!.phone!,
          'Name': updateProModel!.data!.name.toString(),
          'Country': updateProModel!.data!.country.toString(),
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

      final msg = jsonEncode({"email": emailCont.text, "password": UserPassword, "confirm_password": UserPassword,
        "name": nameCont.text, "phone": phoneCont.text, "country": countryCont.text});


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
        title: Text("My Profile",style: TextStyle(color: sh_app_txt_color,fontSize: 24,fontFamily: 'Bold'),),
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actionsIconTheme: IconThemeData(color: sh_white),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                color: sh_white,
                padding: EdgeInsets.all(26),
                child: FutureBuilder<String?>(
                  future: fetchadd(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  // enabled: false,
                                  onEditingComplete: () =>
                                      node.nextFocus(),
                                  controller: nameCont,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter Username';
                                    }
                                    return null;
                                  },
                                  cursorColor: sh_app_txt_color,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                    hintText: "Name",
                                    hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                    labelText: "Name",
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
                                  enabled: false,
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
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                    labelText: "Email",
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
                                  keyboardType: TextInputType.number,
                                  controller: phoneCont,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter Phone';
                                    }
                                    return null;
                                  },
                                  cursorColor: sh_app_txt_color,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                    hintText: "Phone",
                                    hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                    labelText: "Phone",
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
                          // Container(
                          //   padding: EdgeInsets.fromLTRB(
                          //       spacing_standard_new,2,
                          //       spacing_standard_new,2),
                          //   decoration:
                          //   BoxDecoration(border: Border.all(color: sh_app_black, width: 1.0)),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       TextFormField(
                          //         enabled: false,
                          //         onEditingComplete: () =>
                          //             node.nextFocus(),
                          //         controller: websiteCont,
                          //         validator: (text) {
                          //           if (text == null || text.isEmpty) {
                          //             return 'Please Enter Website';
                          //           }
                          //           return null;
                          //         },
                          //         cursorColor: sh_app_txt_color,
                          //         decoration: InputDecoration(
                          //           border: InputBorder.none,
                          //           contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                          //           hintText: "Website",
                          //           hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                          //           labelText: "Website",
                          //           labelStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Bold'),
                          //           enabledBorder: UnderlineInputBorder(
                          //             borderSide: BorderSide(color: sh_transparent, width: 1.0),
                          //           ),
                          //           focusedBorder: UnderlineInputBorder(
                          //             borderSide:  BorderSide(color: sh_transparent, width: 1.0),
                          //           ),
                          //         ),
                          //         maxLines: 1,
                          //         style: TextStyle(color: sh_app_txt_color,fontFamily: 'Bold'),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(height: 12,),
                          // Container(
                          //   padding: EdgeInsets.fromLTRB(
                          //       spacing_standard_new,2,
                          //       spacing_standard_new,2),
                          //   decoration:
                          //   BoxDecoration(border: Border.all(color: sh_app_black, width: 1.0)),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       TextFormField(
                          //         enabled: false,
                          //         onEditingComplete: () =>
                          //             node.nextFocus(),
                          //         controller: plandateCont,
                          //         validator: (text) {
                          //           if (text == null || text.isEmpty) {
                          //             return 'Please Enter Website';
                          //           }
                          //           return null;
                          //         },
                          //         cursorColor: sh_app_txt_color,
                          //         decoration: InputDecoration(
                          //           border: InputBorder.none,
                          //           contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                          //           hintText: "Plan Date",
                          //           hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                          //           labelText: "Plan Date",
                          //           labelStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Bold'),
                          //           enabledBorder: UnderlineInputBorder(
                          //             borderSide: BorderSide(color: sh_transparent, width: 1.0),
                          //           ),
                          //           focusedBorder: UnderlineInputBorder(
                          //             borderSide:  BorderSide(color: sh_transparent, width: 1.0),
                          //           ),
                          //         ),
                          //         maxLines: 1,
                          //         style: TextStyle(color: sh_app_txt_color,fontFamily: 'Bold'),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(height: 12,),
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
                                  controller: countryCont,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter Website';
                                    }
                                    return null;
                                  },
                                  cursorColor: sh_app_txt_color,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                    hintText: "Country",
                                    hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                    labelText: "Country",
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
                          SizedBox(height: 22,),
                          InkWell(
                            onTap: () async {
                              launchScreen(context, ChangePasswordScreen.tag);
                              // getUpdate();
// MyCheck();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                  top: 6, bottom: 10),
                              decoration: boxDecoration(
                                  bgColor: sh_btn_color, radius: 10, showShadow: true),
                              child: text("Change Password",
                                  fontSize: 24.0,
                                  textColor: sh_app_txt_color,
                                  isCentered: true,
                                  fontFamily: 'Bold'),
                            ),
                          ),





                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),

            ),
          )),
    );
  }
}
