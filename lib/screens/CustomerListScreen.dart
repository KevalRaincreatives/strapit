import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/models/CustomerListModel.dart';
import 'package:strapit/screens/AddCustomerScreen.dart';
import 'package:strapit/screens/EditProfileScreen.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';


class CustomerListScreen extends StatefulWidget {
  static String tag='/CustomerListScreen';
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  Stream<QuerySnapshot>? _groups5;
  CustomerListModel? customerListModel;
  // CustomerListModel? customerListModel2;
  List<CustomerListModelData?>? customerListModel2=[];
  // @override
  // void initState() {
  //   super.initState();
  //   _getAllGroups();
  //   // disableCapture();
  // }
  //
  // _getAllGroups() async {
  //   try {
  //
  //     setState(() {
  //       _groups5=FirebaseFirestore.instance.collection("Users").snapshots();
  //
  //     });
  //
  //
  //   } catch (e) {
  //     // setState(() {
  //     //   _error = true;
  //     // });
  //   }
  // }

  Future<CustomerListModel?> fetchCustomer() async {
    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      // String UserId = prefs.getString('UserId');
      String? token = prefs.getString('token');
      // add_from=prefs.getString("from");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };


      Response response =
      await get(Uri.parse('https://strapit.rcstaging.co.in/strapit/public/api/listCustomers'), headers: headers);

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      customerListModel2!.clear();

      customerListModel = new CustomerListModel.fromJson(jsonResponse);

      customerListModel2=customerListModel!.data!.reversed.toList();
      // print(_addressModel!.data);


      return customerListModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;


    Widget groupList() {
      return FutureBuilder<CustomerListModel?>(
        future: fetchCustomer(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: customerListModel2!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              CustomerId: customerListModel2![index]!.id!.toString(),
                              name: customerListModel2![index]!.name!.toString(),
                              email: customerListModel2![index]!.email!.toString(),
                              phone: customerListModel2![index]!.phone!.toString(),
                              country: customerListModel2![index]!.country!.toString(),
                              password: customerListModel2![index]!.email!.toString(),
                            )),
                      );
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName,)));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(

                          decoration:
                          BoxDecoration(color: sh_white,border: Border.all(color: sh_app_black, width: 1.0)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0,8,8,8),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(12,6,12,6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(customerListModel2![index]!.name!,
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: sh_app_black)),
                                      SizedBox(height: 6,),
                                      Text(customerListModel2![index]!.email!,style: TextStyle(fontSize: 16,color: sh_app_black)),
                                      SizedBox(height: 2,),
                                      Text(customerListModel2![index]!.country!,style: TextStyle(fontSize: 16,color: sh_app_black)),
                                      SizedBox(height: 2,),
                                      Text(customerListModel2![index]!.phone!,style: TextStyle(fontSize: 16,color: sh_app_black)),
                                      SizedBox(height: 2,),

                                    ],),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: sh_app_black,
                                    size: 36,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12,)
                      ],
                    ),

                  );
                }
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      );
    }

    return Scaffold(
backgroundColor: sh_white,
      appBar: AppBar(
        elevation: 0,
        title: Text("Customers",style: TextStyle(color: sh_app_txt_color,fontSize: 24,fontFamily: 'Bold'),),
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actionsIconTheme: IconThemeData(color: sh_white),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,0,16.0,0),
              child: Wrap(
                children: [
                  GestureDetector(
                    onTap: () async{
                      Navigator.pushNamed(context, AddCustomerScreen.tag).then((_) => setState(() {}));
                    },
                    child: Container(
                      // color: sh_app_black,
                        child: Image.asset(sh_plus,height:40,width: 40,)),
                  )

                ],
              ),
            ),
          )
        ],

      ),
      body: SafeArea(
          child: Container(
              color: sh_white,
              padding: EdgeInsets.all(16),
              child: groupList())),
    );
  }
}
