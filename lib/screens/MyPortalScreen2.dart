import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/models/PortalListCustomerModel.dart';
import 'package:strapit/models/PortalListModel.dart';
import 'package:strapit/screens/AddPortalScreen.dart';
import 'package:strapit/screens/EditPortalScreen.dart';
import 'package:strapit/screens/ManageBackupScreen.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';


class MyPortalScreen extends StatefulWidget {
  static String tag='/MyPortalScreen';
  const MyPortalScreen({Key? key}) : super(key: key);

  @override
  _MyPortalScreenState createState() => _MyPortalScreenState();
}

class _MyPortalScreenState extends State<MyPortalScreen> {
  String? pickdate = '', pickmonth = '', pickyear = '';
  DateTime selectedDate = DateTime.now();
  PortalListModel? portalListModel;
  PortalListCustomerModel? portalListCustomerModel;
  int? IsAdmin;
  TextEditingController editingController = TextEditingController();

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;

        var yearString = DateFormat.yMMMMd('en_US')
            .format(selectedDate)
            .substring(
            DateFormat.yMMMMd('en_US').format(selectedDate).length - 4);
        var monthstr;
        var datestr;

        if (DateFormat.yMMMMd('en_US').format(selectedDate) != null &&
            DateFormat.yMMMMd('en_US').format(selectedDate).length >= 6) {
          datestr = DateFormat.yMMMMd('en_US').format(selectedDate).substring(
              0, DateFormat.yMMMMd('en_US').format(selectedDate).length - 6);
          datestr = datestr.substring(datestr.length - 2);
        }

        if (DateFormat.yMMMMd('en_US').format(selectedDate) != null &&
            DateFormat.yMMMMd('en_US').format(selectedDate).length >= 8) {
          monthstr = DateFormat.yMMMMd('en_US').format(selectedDate).substring(
              0, DateFormat.yMMMMd('en_US').format(selectedDate).length - 8);
        }

        pickdate = datestr;
        pickmonth = monthstr;
        pickyear = yearString;
      });
  }

  Future<int?> fetchadd() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      IsAdmin=prefs.getInt("IsAdmin");
      return IsAdmin;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<PortalListModel?> fetchPortal() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // String UserId = prefs.getString('UserId');
      String? token = prefs.getString('token');
      IsAdmin=prefs.getInt("IsAdmin");
      int? MainUserId=prefs.getInt("MainUserId");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      Response response;
        response = await get(Uri.parse(
            'https://strapit.rcstaging.co.in/strapit/public/api/listPortals'),
            headers: headers);
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      print('Response bodyregi: ${response.body}');
        portalListModel = new PortalListModel.fromJson(jsonResponse);
      return portalListModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<PortalListCustomerModel?> fetchPortalCustomer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // String UserId = prefs.getString('UserId');
      String? token = prefs.getString('token');
      IsAdmin=prefs.getInt("IsAdmin");
      int? MainUserId=prefs.getInt("MainUserId");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      Response response;
        response = await get(Uri.parse(
            'https://strapit.rcstaging.co.in/strapit/public/api/listPortals?customer_id=$MainUserId'),
            headers: headers);

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      print('Response bodyregi: ${response.body}');

        portalListCustomerModel = new PortalListCustomerModel.fromJson(jsonResponse);

      return portalListCustomerModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    CheckDate() {
      if(pickdate=='') {
        return Container();
      }else{
        return Column(
          children: [
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Date : "+
                    pickdate! + " " + pickmonth! + "," + pickyear!,
                  style: TextStyle(
                      color: sh_app_txt_color, fontSize: 15, fontFamily: 'Bold'),
                ),
                SizedBox(width: 8,),
                InkWell(
                  onTap: (){
                    setState(() {
                      pickdate='';
                    });
                  },
                  child: Container(
                    child: Icon(
                      Icons.cancel,
                      size: 18,
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      }
    }

    return FutureBuilder<int?>(
      future: fetchadd(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(IsAdmin==1) {
            return Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: sh_white,
                appBar: AppBar(
                  elevation: 0,
                  title: Text(
                    "Portal",
                    style: TextStyle(
                        color: sh_app_txt_color, fontSize: 24, fontFamily: 'Bold'),
                  ),
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
                                launchScreen(context, AddPortalScreen.tag);
                              },
                              child: Container(
                                // color: sh_app_black,
                                  child: Image.asset(sh_plus,height:40,width: 40,)),
                            )

                          //   GestureDetector(
                          //   onTap: () async{
                          //     // Navigator.pushNamed(context, AddTicketScreen.tag).then((_) => setState(() {}));
                          //     launchScreen(context, AddPortalScreen.tag);
                          //     // CreateOrder(widget.podCastModel2![index].id!, widget.podCastModel2![index].downloadCost!);
                          //   },
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(2),
                          //       color: sh_btn_color,
                          //     ),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(6.0),
                          //       child: Center(
                          //         child: Text(
                          //           "Add",
                          //           style: TextStyle(
                          //             color: sh_app_txt_color,
                          //             fontSize: 15,
                          //             fontFamily: "Bold",
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                body:
                SafeArea(
                    child: Container(
                        color: sh_white,
                        padding: EdgeInsets.fromLTRB(12,8,12,8),
                        child: Column(
                          mainAxisSize:  MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 10, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: Container(
                                      child: TextFormField(
                                        textInputAction: TextInputAction.search,
                                        onChanged: (value){
                                          setState(() {

                                          });
                                        },
                                        controller: editingController,
                                        onFieldSubmitted: (value) async {
                                          if (value.length > 1) {
                                          } else {
                                            toast("Please enter more character");
                                          }
                                        },
                                        style: TextStyle(
                                            fontSize: textSizeMedium,
                                            fontFamily: "Regular"),
                                        decoration: InputDecoration(
                                          filled: true,
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: sh_app_black,
                                          ),
                                          fillColor: sh_white,
                                          contentPadding:
                                          EdgeInsets.fromLTRB(16, 6, 16, 6),
                                          hintText: "Search",
                                          hintStyle:
                                          TextStyle(color: sh_textColorPrimary),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(26),
                                            borderSide: BorderSide(
                                                color: sh_app_black, width: 0.7),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(26),
                                            borderSide: BorderSide(
                                                color: sh_app_black, width: 0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () async {
                                        _selectDate(context);
                                      },
                                      child: Container(
                                        child: IconButton(
                                          icon: new Icon(
                                            Icons.date_range,
                                            size: 30,
                                          ),
                                          highlightColor: Colors.black,
                                          onPressed: () {
                                            _selectDate(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            CheckDate(),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder<PortalListModel?>(
                              future: fetchPortal(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
if(portalListModel!.data==null){
  return Container();
}else {
  return Expanded(
    child: ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: portalListModel!.data!.length,
        itemBuilder: (context, index) {

          if (editingController.text.isEmpty) {
            return GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => EditPortalScreen(
                //         PortalId: portalListModel!.data![index]!.id.toString(),
                //           CustomerId: portalListModel!.data![index]!.userId!.toString(),
                //           UserIdName: portalListModel!.data![index]!.username!.toString(),
                //         Name: portalListModel!.data![index]!.name!.toString(),
                //         Username: portalListModel!.data![index]!.username!.toString(),
                //         Password: portalListModel!.data![index]!.password!.toString(),
                //         Url: portalListModel!.data![index]!.url!.toString(),
                //         Host: portalListModel!.data![index]!.host!.toString(),
                //         Port: portalListModel!.data![index]!.port!.toString(),
                //         RootFolder: portalListModel!.data![index]!.rootFolder!.toString(),
                //         StartDate: portalListModel!.data![index]!.planStartDate!.toString(),
                //         EndDate: portalListModel!.data![index]!.planEndDate!.toString(),
                //       )),
                // );
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ManageBackupScreen(PortalId: portalListModel!.data![index]!.id.toString(),)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: sh_white,
                        border:
                        Border.all(color: sh_app_black, width: 1.0)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Portal Name: " +
                                  portalListModel!.data![index]!.name!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 17,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Customer : " + portalListModel!.data![index]!
                                  .customerName!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 15,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Host : " +
                                  portalListModel!.data![index]!.host!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 15,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(portalListModel!.data![index]!
                                .planStartDate == null ? '' :
                            "Start Date : " + portalListModel!.data![index]!
                                .planStartDate!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 15,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              portalListModel!.data![index]!.planEndDate ==
                                  null ? '' :
                              "End Date : " + portalListModel!.data![index]!
                                  .planEndDate!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 15,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Customer : " + portalListModel!.data![index]!
                                  .customerName!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 15,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              ManageBackupScreen(
                                                PortalId: portalListModel!
                                                    .data![index]!.id
                                                    .toString(),
                                                BackupUser: portalListModel!
                                                    .data![index]!.userId
                                                    .toString(),)));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: boxDecoration(
                                          bgColor: sh_btn_color,
                                          radius: 6,
                                          showShadow: true),
                                      child: text("VIEW BACKUPS",
                                          fontSize: 14.0,
                                          textColor: sh_app_black,
                                          isCentered: true,
                                          fontFamily: 'Bold'),
                                    ),
                                  ),
                                ),
                                Expanded(child: Container(
                                  width: 8,
                                )),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditPortalScreen(
                                                  PortalId: portalListModel!
                                                      .data![index]!.id
                                                      .toString(),
                                                  CustomerId: portalListModel!
                                                      .data![index]!.userId!
                                                      .toString(),
                                                  UserIdName: portalListModel!
                                                      .data![index]!.username!
                                                      .toString(),
                                                  Name: portalListModel!
                                                      .data![index]!
                                                      .name!.toString(),
                                                  Username: portalListModel!
                                                      .data![index]!.username!
                                                      .toString(),
                                                  Password: portalListModel!
                                                      .data![index]!.password!
                                                      .toString(),
                                                  Url: portalListModel!
                                                      .data![index]!
                                                      .url!.toString(),
                                                  Host: portalListModel!
                                                      .data![index]!
                                                      .host!.toString(),
                                                  Port: portalListModel!
                                                      .data![index]!
                                                      .port!.toString(),
                                                  RootFolder: portalListModel!
                                                      .data![index]!.rootFolder!
                                                      .toString(),
                                                  StartDate: portalListModel!
                                                      .data![index]!
                                                      .planStartDate!
                                                      .toString(),
                                                  EndDate: portalListModel!
                                                      .data![index]!
                                                      .planEndDate!
                                                      .toString(),
                                                  mysqlUsername: portalListModel!
                                                      .data![index]!
                                                      .mysqlUsername!
                                                      .toString(),
                                                  mysqlPassword: portalListModel!
                                                      .data![index]!
                                                      .mysqlPassword!
                                                      .toString(),
                                                  mysqlHost: portalListModel!
                                                      .data![index]!.mysqlHost!
                                                      .toString(),
                                                  mysqlPort: portalListModel!
                                                      .data![index]!.mysqlPort!
                                                      .toString(),
                                                  mysqlDatabase: portalListModel!
                                                      .data![index]!
                                                      .mysqlDatabase!
                                                      .toString(),
                                                )),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: boxDecoration(
                                          bgColor: sh_btn_color,
                                          radius: 6,
                                          showShadow: true),
                                      child: text("EDIT PORTAL",
                                          fontSize: 14.0,
                                          textColor: sh_app_black,
                                          isCentered: true,
                                          fontFamily: 'Bold'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12,)
                ],
              ),

            );
          } else if (portalListModel!.data![index]!.name!.toLowerCase().contains(editingController.text)) {
            return GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => EditPortalScreen(
                //         PortalId: portalListModel!.data![index]!.id.toString(),
                //           CustomerId: portalListModel!.data![index]!.userId!.toString(),
                //           UserIdName: portalListModel!.data![index]!.username!.toString(),
                //         Name: portalListModel!.data![index]!.name!.toString(),
                //         Username: portalListModel!.data![index]!.username!.toString(),
                //         Password: portalListModel!.data![index]!.password!.toString(),
                //         Url: portalListModel!.data![index]!.url!.toString(),
                //         Host: portalListModel!.data![index]!.host!.toString(),
                //         Port: portalListModel!.data![index]!.port!.toString(),
                //         RootFolder: portalListModel!.data![index]!.rootFolder!.toString(),
                //         StartDate: portalListModel!.data![index]!.planStartDate!.toString(),
                //         EndDate: portalListModel!.data![index]!.planEndDate!.toString(),
                //       )),
                // );
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ManageBackupScreen(PortalId: portalListModel!.data![index]!.id.toString(),)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: sh_white,
                        border:
                        Border.all(color: sh_app_black, width: 1.0)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Portal Name: " +
                                  portalListModel!.data![index]!.name!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 17,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Customer : " + portalListModel!.data![index]!
                                  .customerName!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 15,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Host : " +
                                  portalListModel!.data![index]!.host!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 15,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(portalListModel!.data![index]!
                                .planStartDate == null ? '' :
                            "Start Date : " + portalListModel!.data![index]!
                                .planStartDate!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 15,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              portalListModel!.data![index]!.planEndDate ==
                                  null ? '' :
                              "End Date : " + portalListModel!.data![index]!
                                  .planEndDate!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 15,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Customer : " + portalListModel!.data![index]!
                                  .customerName!,
                              style: TextStyle(
                                  color: sh_app_txt_color,
                                  fontSize: 15,
                                  fontFamily: 'Bold'),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              ManageBackupScreen(
                                                PortalId: portalListModel!
                                                    .data![index]!.id
                                                    .toString(),
                                                BackupUser: portalListModel!
                                                    .data![index]!.userId
                                                    .toString(),)));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: boxDecoration(
                                          bgColor: sh_btn_color,
                                          radius: 6,
                                          showShadow: true),
                                      child: text("VIEW BACKUPS",
                                          fontSize: 14.0,
                                          textColor: sh_app_black,
                                          isCentered: true,
                                          fontFamily: 'Bold'),
                                    ),
                                  ),
                                ),
                                Expanded(child: Container(
                                  width: 8,
                                )),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditPortalScreen(
                                                  PortalId: portalListModel!
                                                      .data![index]!.id
                                                      .toString(),
                                                  CustomerId: portalListModel!
                                                      .data![index]!.userId!
                                                      .toString(),
                                                  UserIdName: portalListModel!
                                                      .data![index]!.username!
                                                      .toString(),
                                                  Name: portalListModel!
                                                      .data![index]!
                                                      .name!.toString(),
                                                  Username: portalListModel!
                                                      .data![index]!.username!
                                                      .toString(),
                                                  Password: portalListModel!
                                                      .data![index]!.password!
                                                      .toString(),
                                                  Url: portalListModel!
                                                      .data![index]!
                                                      .url!.toString(),
                                                  Host: portalListModel!
                                                      .data![index]!
                                                      .host!.toString(),
                                                  Port: portalListModel!
                                                      .data![index]!
                                                      .port!.toString(),
                                                  RootFolder: portalListModel!
                                                      .data![index]!.rootFolder!
                                                      .toString(),
                                                  StartDate: portalListModel!
                                                      .data![index]!
                                                      .planStartDate!
                                                      .toString(),
                                                  EndDate: portalListModel!
                                                      .data![index]!
                                                      .planEndDate!
                                                      .toString(),
                                                  mysqlUsername: portalListModel!
                                                      .data![index]!
                                                      .mysqlUsername!
                                                      .toString(),
                                                  mysqlPassword: portalListModel!
                                                      .data![index]!
                                                      .mysqlPassword!
                                                      .toString(),
                                                  mysqlHost: portalListModel!
                                                      .data![index]!.mysqlHost!
                                                      .toString(),
                                                  mysqlPort: portalListModel!
                                                      .data![index]!.mysqlPort!
                                                      .toString(),
                                                  mysqlDatabase: portalListModel!
                                                      .data![index]!
                                                      .mysqlDatabase!
                                                      .toString(),
                                                )),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: boxDecoration(
                                          bgColor: sh_btn_color,
                                          radius: 6,
                                          showShadow: true),
                                      child: text("EDIT PORTAL",
                                          fontSize: 14.0,
                                          textColor: sh_app_black,
                                          isCentered: true,
                                          fontFamily: 'Bold'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),
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
          else {
            return Container();
          }
        }
    ),
  );
}

                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                // By default, show a loading spinner.
                                return CircularProgressIndicator();
                              },
                            )
                          ],
                        ))));

          }else{
            return Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: sh_white,
                appBar: AppBar(
                  elevation: 0,
                  title: Text(
                    "Portal",
                    style: TextStyle(
                        color: sh_app_txt_color, fontSize: 24, fontFamily: 'Bold'),
                  ),
                  backgroundColor: sh_white,
                  iconTheme: IconThemeData(color: sh_textColorPrimary),
                  actionsIconTheme: IconThemeData(color: sh_white),

                ),
                body:
                SafeArea(
                    child: Container(
                        color: sh_white,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 10, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: Container(
                                      child: TextFormField(
                                        textInputAction: TextInputAction.search,
                                        onFieldSubmitted: (value) async {
                                          if (value.length > 1) {
                                          } else {
                                            toast("Please enter more character");
                                          }
                                        },
                                        style: TextStyle(
                                            fontSize: textSizeMedium,
                                            fontFamily: "Regular"),
                                        decoration: InputDecoration(
                                          filled: true,
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: sh_app_black,
                                          ),
                                          fillColor: sh_white,
                                          contentPadding:
                                          EdgeInsets.fromLTRB(16, 6, 16, 6),
                                          hintText: "Search",
                                          hintStyle:
                                          TextStyle(color: sh_textColorPrimary),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(26),
                                            borderSide: BorderSide(
                                                color: sh_app_black, width: 0.7),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(26),
                                            borderSide: BorderSide(
                                                color: sh_app_black, width: 0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () async {
                                        _selectDate(context);
                                      },
                                      child: Container(
                                        child: IconButton(
                                          icon: new Icon(
                                            Icons.date_range,
                                            size: 30,
                                          ),
                                          highlightColor: Colors.black,
                                          onPressed: () {
                                            _selectDate(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            CheckDate(),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder<PortalListCustomerModel?>(
                              future: fetchPortalCustomer(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {

                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: portalListCustomerModel!.data!.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) => EditPortalScreen(
                                            //         PortalId: portalListModel!.data![index]!.id.toString(),
                                            //           CustomerId: portalListModel!.data![index]!.userId!.toString(),
                                            //           UserIdName: portalListModel!.data![index]!.username!.toString(),
                                            //         Name: portalListModel!.data![index]!.name!.toString(),
                                            //         Username: portalListModel!.data![index]!.username!.toString(),
                                            //         Password: portalListModel!.data![index]!.password!.toString(),
                                            //         Url: portalListModel!.data![index]!.url!.toString(),
                                            //         Host: portalListModel!.data![index]!.host!.toString(),
                                            //         Port: portalListModel!.data![index]!.port!.toString(),
                                            //         RootFolder: portalListModel!.data![index]!.rootFolder!.toString(),
                                            //         StartDate: portalListModel!.data![index]!.planStartDate!.toString(),
                                            //         EndDate: portalListModel!.data![index]!.planEndDate!.toString(),
                                            //       )),
                                            // );
                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ManageBackupScreen(PortalId: portalListModel!.data![index]!.id.toString(),)));
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: sh_white,
                                                    border:
                                                    Border.all(color: sh_app_black, width: 1.0)),
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                                                  child: ListTile(
                                                    title: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Portal Name: " + portalListCustomerModel!.data![index]!.name!,
                                                          style: TextStyle(
                                                              color: sh_app_txt_color,
                                                              fontSize: 17,
                                                              fontFamily: 'Bold'),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "Host : " +
                                                              portalListCustomerModel!.data![index]!.host!,
                                                          style: TextStyle(
                                                              color: sh_app_txt_color,
                                                              fontSize: 15,
                                                              fontFamily: 'Bold'),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(portalListCustomerModel!.data![index]!
                                                            .planStartDate == null ? '' :
                                                        "Start Date : " + portalListCustomerModel!.data![index]!
                                                            .planStartDate!,
                                                          style: TextStyle(
                                                              color: sh_app_txt_color,
                                                              fontSize: 15,
                                                              fontFamily: 'Bold'),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          portalListCustomerModel!.data![index]!.planEndDate ==
                                                              null ? '' :
                                                          "End Date : " + portalListCustomerModel!.data![index]!
                                                              .planEndDate!,
                                                          style: TextStyle(
                                                              color: sh_app_txt_color,
                                                              fontSize: 15,
                                                              fontFamily: 'Bold'),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: InkWell(
                                                                onTap: () async {
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ManageBackupScreen(PortalId: portalListCustomerModel!.data![index]!.id.toString(),BackupUser: portalListCustomerModel!.data![index]!.userId.toString(),)));

                                                                },
                                                                child: Container(
                                                                  padding: EdgeInsets.all(4.0),
                                                                  decoration: boxDecoration(
                                                                      bgColor: sh_btn_color, radius: 6, showShadow: true),
                                                                  child: text("VIEW BACKUPS",
                                                                      fontSize: 14.0,
                                                                      textColor: sh_app_black,
                                                                      isCentered: true,
                                                                      fontFamily: 'Bold'),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(child: Container(
                                                              width: 8,
                                                            )),
                                                            Expanded(
                                                              flex: 2,
                                                              child: InkWell(
                                                                onTap: () async {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => EditPortalScreen(
                                                                          PortalId: portalListCustomerModel!.data![index]!.id.toString(),
                                                                          CustomerId: portalListCustomerModel!.data![index]!.userId!.toString(),
                                                                          UserIdName: portalListCustomerModel!.data![index]!.username!.toString(),
                                                                          Name: portalListCustomerModel!.data![index]!.name!.toString(),
                                                                          Username: portalListCustomerModel!.data![index]!.username!.toString(),
                                                                          Password: portalListCustomerModel!.data![index]!.password!.toString(),
                                                                          Url: portalListCustomerModel!.data![index]!.url!.toString(),
                                                                          Host: portalListCustomerModel!.data![index]!.host!.toString(),
                                                                          Port: portalListCustomerModel!.data![index]!.port!.toString(),
                                                                          RootFolder: portalListCustomerModel!.data![index]!.rootFolder!.toString(),
                                                                          StartDate: portalListCustomerModel!.data![index]!.planStartDate!.toString(),
                                                                          EndDate: portalListCustomerModel!.data![index]!.planEndDate!.toString(),
                                                                          mysqlUsername: portalListCustomerModel!.data![index]!.mysqlUsername!.toString(),
                                                                          mysqlPassword: portalListCustomerModel!.data![index]!.mysqlPassword!.toString(),
                                                                          mysqlHost: portalListCustomerModel!.data![index]!.mysqlHost!.toString(),
                                                                          mysqlPort: portalListCustomerModel!.data![index]!.mysqlPort!.toString(),
                                                                          mysqlDatabase: portalListCustomerModel!.data![index]!.mysqlDatabase!.toString(),
                                                                        )),
                                                                  );
                                                                },
                                                                child: Container(
                                                                  padding: EdgeInsets.all(4.0),
                                                                  decoration: boxDecoration(
                                                                      bgColor: sh_btn_color, radius: 6, showShadow: true),
                                                                  child: text("EDIT PORTAL",
                                                                      fontSize: 14.0,
                                                                      textColor: sh_app_black,
                                                                      isCentered: true,
                                                                      fontFamily: 'Bold'),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 1,
                                                        ),
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
                            )
                          ],
                        ))));
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );

  }
}
