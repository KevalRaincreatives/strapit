import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/models/ListAllBackup2.dart';
import 'package:strapit/models/ListAllBackupModel.dart';
import 'package:strapit/models/ListCustomerBackupModel.dart';
import 'package:strapit/models/RestoreAddModel.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart'as http;


class BackupFragment extends StatefulWidget {
  final String? PortalId,BackUpUser;

  BackupFragment({this.PortalId,this.BackUpUser});

  @override
  _BackupFragmentState createState() => _BackupFragmentState();
}

class _BackupFragmentState extends State<BackupFragment> {
  String? pickdate = '', pickmonth = '', pickyear = '';
  DateTime selectedDate = DateTime.now();
  RestoreAddModel? restoreAddModel;
  ListAllBackupModel? listAllBackupModel;
  ListCustomerBackupModel? listCustomerBackupModel;
  int? IsAdmin;
  List<ListAllBackup2?>? listAllBackupModeldata=[];

  List<ListAllBackup2?>? listCustomerBackupModeldata=[];

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

  Future<ListAllBackupModel?> fetchBackup() async {
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
          'https://strapit.rcstaging.co.in/strapit/public/api/listBackups'),
          headers: headers);
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      print('Response bodyregi: ${response.body}');
      // listAllBackupModeldata!.clear();

      listAllBackupModeldata!.clear();

      listAllBackupModel = new ListAllBackupModel.fromJson(jsonResponse);

      for (var i = 0; i < listAllBackupModel!.data!.length; i++) {
        if (listAllBackupModel!.data![i]!.portalId == widget.PortalId.toInt()) {
          listAllBackupModeldata!.add(ListAllBackup2(backupId: listAllBackupModel!.data![i]!.backupId,
              backupTime: listAllBackupModel!.data![i]!.backupTime,customerName: listAllBackupModel!.data![i]!.customerName,
              message: listAllBackupModel!.data![i]!.message,portalId: listAllBackupModel!.data![i]!.portalId,
              portalName: listAllBackupModel!.data![i]!.portalName,portalUrl: listAllBackupModel!.data![i]!.portalUrl,
              status: listAllBackupModel!.data![i]!.status));

          listAllBackupModeldata=listAllBackupModeldata!.reversed.toList();
        }
//        orderListModel = new OrderListModel2.fromJson(i);
      }

      return listAllBackupModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<ListCustomerBackupModel?> fetchCustomerBackup() async {
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
          'https://strapit.rcstaging.co.in/strapit/public/api/listBackups?customer_id=$MainUserId'),
          headers: headers);

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      print('Response bodyregi: ${response.body}');
      listCustomerBackupModeldata!.clear();
      listCustomerBackupModel = new ListCustomerBackupModel.fromJson(jsonResponse);
      for (var i = 0; i < listCustomerBackupModel!.data!.length; i++) {
        if (listCustomerBackupModel!.data![i]!.portalId == widget.PortalId.toInt()) {
          listCustomerBackupModeldata!.add(ListAllBackup2(backupId: listCustomerBackupModel!.data![i]!.backupId,
              backupTime: listCustomerBackupModel!.data![i]!.backupTime,customerName: listCustomerBackupModel!.data![i]!.customerName,
              message: listCustomerBackupModel!.data![i]!.message,portalId: listCustomerBackupModel!.data![i]!.portalId,
              portalName: listCustomerBackupModel!.data![i]!.portalName,portalUrl: listCustomerBackupModel!.data![i]!.portalUrl,
              status: listCustomerBackupModel!.data![i]!.status));

        }
//        orderListModel = new OrderListModel2.fromJson(i);
      }

      return listCustomerBackupModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<String?> getAddRestore(String backupid) async {
    EasyLoading.show(status: 'Please wait...');
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

      final msg = jsonEncode({"backup_id": backupid,"portal_id":widget.PortalId});


      final client = RetryClient(http.Client());
      var response;
      try {
        response=await client.post(
            Uri.parse(
                'https://strapit.rcstaging.co.in/strapit/public/api/addRestore'),
            headers: headers,
            body: msg);
      } finally {
        client.close();
      }



      final jsonResponse = json.decode(response.body);
      print('not json restore$jsonResponse');
      print('Response bodyrestore: ${response.body}');
      if (response.statusCode == 200) {
        restoreAddModel = new RestoreAddModel.fromJson(jsonResponse);

        EasyLoading.dismiss();


        toast(restoreAddModel!.message);
        // Navigator.pop(context);
        setState(() {

        });
        print('sucess');
      } else {
        EasyLoading.dismiss();
        // err_model = new ShLoginErrorNewModel.fromJson(jsonResponse);
        //
        // toast(err_model!.message);
        toast('Something Went Wrong');
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

    void _openCustomDialog(String backupid) {
      showGeneralDialog(barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  title: Center(child: Text('Are you sure you want to restore the website? This will erase all files on your website directory and database data and restore from this backup copy. Please confirm',style: TextStyle(color: sh_app_black,fontSize: 18,fontFamily: 'Bold'),textAlign: TextAlign.center,)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 16,),
                      InkWell(
                        onTap: () async {
                          // BecameSeller();
                          Navigator.of(context, rootNavigator: true).pop();
                          getAddRestore(backupid);
                         },
                        child: Container(
                          width: MediaQuery.of(context).size.width*.7,
                          padding: EdgeInsets.only(
                              top: 6, bottom: 10),
                          decoration: boxDecoration(
                              bgColor: sh_btn_color, radius: 10, showShadow: true),
                          child: text("Confirm",
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


    CheckRestore(int index){
      if(listAllBackupModeldata![index]!.status==1){
        return Column(
          children: [
            InkWell(
              onTap: () {
                _openCustomDialog(listAllBackupModeldata![index]!.backupId!.toString());
                // getAddRestore(listAllBackupModeldata![index]!.backupId!.toString());
              },
              child: Container(
                padding: EdgeInsets
                    .all(4.0),
                decoration: boxDecoration(
                    bgColor: sh_btn_color,
                    radius: 6,
                    showShadow: true),
                child: text(
                    "Restore",
                    fontSize: 15.0,
                    textColor: sh_app_txt_color,
                    isCentered: true,
                    fontFamily: 'Bold'),
              ),
            ),
            SizedBox(
              height: 1,
            ),
          ],
        );
      }else{
        return Container();
      }
    }


    CheckRestoreCustomer(int index){
      if(listCustomerBackupModeldata![index]!.status==1){
        return Column(
          children: [
            InkWell(
              onTap: () {
                _openCustomDialog(listCustomerBackupModeldata![index]!.backupId!.toString());
                // getAddRestore(listCustomerBackupModeldata![index]!.backupId!.toString());
              },
              child: Container(
                padding: EdgeInsets
                    .all(4.0),
                decoration: boxDecoration(
                    bgColor: sh_btn_color,
                    radius: 6,
                    showShadow: true),
                child: text(
                    "Restore",
                    fontSize: 15.0,
                    textColor: sh_app_txt_color,
                    isCentered: true,
                    fontFamily: 'Bold'),
              ),
            ),
            SizedBox(
              height: 1,
            ),
          ],
        );
      }else{
        return Container();
      }
    }

    SetBackupDate(int index){
      if(listAllBackupModeldata![index]!.backupTime != null) {
        var inputFormat = DateFormat("yyyy-MM-dd");

        String date1 = inputFormat.parse(
            listAllBackupModeldata![index]!.backupTime!.substring(0,10)).toString();
        DateTime dateTime = DateTime.parse(date1);
        var outputFormat = DateFormat.yMMMMd('en_US').format(dateTime);

        String date2 = outputFormat.toString();

        String lasttime=listAllBackupModeldata![index]!.backupTime!.substring(10);
        return Text(
          listAllBackupModeldata![index]!
              .backupTime ==
              null ? '' :
          "Backup : " +
              date2 +lasttime,
          style: TextStyle(
              color: sh_app_txt_color,
              fontSize: 15,
              fontFamily: 'Bold'),
        );
      }else{
        return Text('',
          style: TextStyle(
              color: sh_app_txt_color,
              fontSize: 15,
              fontFamily: 'Bold'),
        );
      }
    }

    SetBackupCustomerDate(int index){
      if(listCustomerBackupModeldata![index]!.backupTime != null) {
        var inputFormat = DateFormat("yyyy-MM-dd");

        String date1 = inputFormat.parse(
            listCustomerBackupModeldata![index]!.backupTime!.substring(0,10)).toString();
        DateTime dateTime = DateTime.parse(date1);
        var outputFormat = DateFormat.yMMMMd('en_US').format(dateTime);

        String date2 = outputFormat.toString();

        String lasttime=listCustomerBackupModeldata![index]!.backupTime!.substring(10);
        return Text(
          listCustomerBackupModeldata![index]!
              .backupTime ==
              null ? '' :
          "Backup : " +
              date2 +lasttime,
          style: TextStyle(
              color: sh_app_txt_color,
              fontSize: 15,
              fontFamily: 'Bold'),
        );
      }else{
        return Text('',
          style: TextStyle(
              color: sh_app_txt_color,
              fontSize: 15,
              fontFamily: 'Bold'),
        );
      }
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: sh_white,
      body: Container(
        height: height,
        width: width,
        child: FutureBuilder<int?>(
          future: fetchadd(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(IsAdmin==1) {
                return SafeArea(
                    child: Container(
                        color: sh_white,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize:  MainAxisSize.max,
                          children: [

                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder<ListAllBackupModel?>(
                              future: fetchBackup(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if(listAllBackupModeldata!.length==0){
                                    return Container(
                                      height: height*.5,
                                      child: Center(
                                        child: Text(
                                          'No Backup Found',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: sh_app_black,
                                              fontFamily: 'Bold',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),);
                                  }else {
                                    return Expanded(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: AlwaysScrollableScrollPhysics(),
                                          itemCount: listAllBackupModeldata!
                                              .length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //       builder: (context) => EditPortalScreen(
                                                //         PortalId: portalListModel!.data![index]!.id.toString(),
                                                //         CustomerId: portalListModel!.data![index]!.userId!.toString(),
                                                //         UserIdName: portalListModel!.data![index]!.username!.toString(),
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
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName,)));
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .stretch,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: sh_white,
                                                        border:
                                                        Border.all(
                                                            color: sh_app_black,
                                                            width: 1.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8.0, 8, 8, 8),
                                                      child: ListTile(
                                                        title: Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              "Customer : " +
                                                                  listAllBackupModeldata![index]!
                                                                      .customerName!,
                                                              style: TextStyle(
                                                                  color: sh_app_txt_color,
                                                                  fontSize: 16,
                                                                  fontFamily: 'Bold'),
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              "Portal : " +
                                                                  listAllBackupModeldata![index]!
                                                                      .portalName!,
                                                              style: TextStyle(
                                                                  color: sh_app_txt_color,
                                                                  fontSize: 15,
                                                                  fontFamily: 'Bold'),
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              listAllBackupModeldata![index]!
                                                                  .backupId ==
                                                                  null ? '' :
                                                              "Backup Id: " +
                                                                  listAllBackupModeldata![index]!.backupId!.toString(),
                                                              style: TextStyle(
                                                                  color: sh_app_txt_color,
                                                                  fontSize: 15,
                                                                  fontFamily: 'Bold'),
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            SetBackupDate(index),
                                                            // Text(
                                                            //   listAllBackupModeldata![index]!
                                                            //       .backupTime ==
                                                            //       null ? '' :
                                                            //   "Backup : " +
                                                            //       listAllBackupModeldata![index]!
                                                            //           .backupTime!,
                                                            //   style: TextStyle(
                                                            //       color: sh_app_txt_color,
                                                            //       fontSize: 15,
                                                            //       fontFamily: 'Bold'),
                                                            // ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              listAllBackupModeldata![index]!
                                                                  .message ==
                                                                  null ? '' :
                                                              listAllBackupModeldata![index]!
                                                                  .message!,
                                                              style: TextStyle(
                                                                  color: sh_green,
                                                                  fontSize: 15,
                                                                  fontFamily: 'Bold'),
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            CheckRestore(index),
                                                            // Container(
                                                            //   padding: EdgeInsets
                                                            //       .all(4.0),
                                                            //   decoration: boxDecoration(
                                                            //       bgColor: sh_btn_color,
                                                            //       radius: 6,
                                                            //       showShadow: true),
                                                            //   child: text(
                                                            //       "Restore",
                                                            //       fontSize: 15.0,
                                                            //       textColor: sh_app_txt_color,
                                                            //       isCentered: true,
                                                            //       fontFamily: 'Bold'),
                                                            // ),
                                                            // SizedBox(
                                                            //   height: 1,
                                                            // ),

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
                                      ),
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                // By default, show a loading spinner.
                                return Center(child: CircularProgressIndicator());
                              },
                            )
                          ],
                        )));
              }
              else{
                return SafeArea(
                    child: Container(
                        color: sh_white,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [

                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder<ListCustomerBackupModel?>(
                              future: fetchCustomerBackup(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {

                                  if(listCustomerBackupModeldata!.length==0){
                                    return Container(
                                      height: height*.5,
                                      child: Center(
                                        child: Text(
                                          'No Backup Found',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: sh_app_black,
                                              fontFamily: 'Bold',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),);
                                  }else {
                                    return Expanded(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: listCustomerBackupModeldata!.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName,)));
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
                                                      padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                                                      child: ListTile(
                                                        title: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "Customer : " +
                                                                        listCustomerBackupModeldata![index]!
                                                                            .customerName!,
                                                                    style: TextStyle(
                                                                        color: sh_app_txt_color,
                                                                        fontSize: 16,
                                                                        fontFamily: 'Bold'),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(
                                                                    "Portal : " +
                                                                        listCustomerBackupModeldata![index]!
                                                                            .portalName!,
                                                                    style: TextStyle(
                                                                        color: sh_app_txt_color,
                                                                        fontSize: 15,
                                                                        fontFamily: 'Bold'),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(
                                                                    listCustomerBackupModeldata![index]!
                                                                        .backupId ==
                                                                        null ? '' :
                                                                    "Backup Id: " +
                                                                        listCustomerBackupModeldata![index]!.backupId!.toString(),
                                                                    style: TextStyle(
                                                                        color: sh_app_txt_color,
                                                                        fontSize: 15,
                                                                        fontFamily: 'Bold'),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  SetBackupCustomerDate(index),
                                                                  // Text(listCustomerBackupModeldata![index]!
                                                                  //     .backupTime == null ? '' :
                                                                  // "Backup : " +
                                                                  //     listCustomerBackupModeldata![index]!
                                                                  //         .backupTime!,
                                                                  //   style: TextStyle(
                                                                  //       color: sh_app_txt_color,
                                                                  //       fontSize: 15,
                                                                  //       fontFamily: 'Bold'),
                                                                  // ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(listCustomerBackupModeldata![index]!
                                                                      .message == null ? '' :
                                                                  listCustomerBackupModeldata![index]!
                                                                      .message!,
                                                                    style: TextStyle(
                                                                        color: sh_green,
                                                                        fontSize: 15,
                                                                        fontFamily: 'Bold'),
                                                                  ),
                                                                  CheckRestoreCustomer(index),
                                                                  // SizedBox(
                                                                  //   height: 8,
                                                                  // ),
                                                                  // Container(
                                                                  //   padding: EdgeInsets.all(4.0),
                                                                  //   decoration: boxDecoration(
                                                                  //       bgColor: sh_btn_color,
                                                                  //       radius: 6,
                                                                  //       showShadow: true),
                                                                  //   child: text("Restore",
                                                                  //       fontSize: 15.0,
                                                                  //       textColor: sh_app_txt_color,
                                                                  //       isCentered: true,
                                                                  //       fontFamily: 'Bold'),
                                                                  // ),

                                                                  SizedBox(
                                                                    height: 1,
                                                                  ),
                                                                ],
                                                              ),
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
                        )));
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
