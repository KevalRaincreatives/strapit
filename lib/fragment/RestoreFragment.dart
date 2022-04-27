import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/models/ListAllBackup2.dart';
import 'package:strapit/models/ListAllBackupModel.dart';
import 'package:strapit/models/ListCustomerBackupModel.dart';
import 'package:strapit/models/RestoreListModel.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';
import 'package:http/http.dart';

class RestoreFragment extends StatefulWidget {
  final String? PortalId,BackUpUser;
  RestoreFragment({this.PortalId,this.BackUpUser});

  @override
  _RestoreFragmentState createState() => _RestoreFragmentState();
}

class _RestoreFragmentState extends State<RestoreFragment> {
  String? pickdate = '', pickmonth = '', pickyear = '';
  DateTime selectedDate = DateTime.now();
  RestoreListModel? listResortModel;



  Future<RestoreListModel?> fetchRestore() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // String UserId = prefs.getString('UserId');
      String? token = prefs.getString('token');
      // IsAdmin=prefs.getInt("IsAdmin");
      int? MainUserId=prefs.getInt("MainUserId");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      String? userid=widget.BackUpUser;
      String? portid=widget.PortalId;

      print('https://strapit.rcstaging.co.in/strapit/public/api/listRestores?customer_id=$userid&portal_id=$portid');
      Response response;
      response = await get(Uri.parse(
          'https://strapit.rcstaging.co.in/strapit/public/api/listRestores?customer_id=$userid&portal_id=$portid'),
          headers: headers);


      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      print('Response bodyregi: ${response.body}');
      // listAllBackupModeldata!.clear();

      listResortModel = new RestoreListModel.fromJson(jsonResponse);


      return listResortModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;


    StepList(int index){
      List<Step> steps=[];
    if(listResortModel!.data![index]!.status==0)
      {
         steps =
         [
          Step(
            title: Text('Scheduled'),
            content: Text(''),
            state: StepState.complete,
            isActive: true,
          ),
          Step(
            title: Text('In progress'),
            content: Text(''),
            isActive: false,
          ),
          Step(
            title: Text('Downloading backup file from cloud'),
            content: Text(''),
            isActive: false,
          ),
          Step(
            title: Text('Uploading backup file to server'),
            content: Text(''),
            isActive: false,          ),
          Step(
            title: Text('Restoring backup on the server'),
            content: Text(''),
            isActive: false,
          ),
          Step(
            title: Text('Restore Completed'),
            content: Text(''),
            isActive: false,
          ),

        ];

      }
    else if(listResortModel!.data![index]!.status==2)
    {
      steps =
      [
        Step(
          title: Text('Scheduled'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('In progress'),
          content: Text(''),
          isActive: true,
          state: StepState.complete,
        ),
        Step(
          title: Text('Downloading backup file from cloud'),
          content: Text(''),
          isActive: false,
        ),
        Step(
          title: Text('Uploading backup file to server'),
          content: Text(''),
          isActive: false,          ),
        Step(
          title: Text('Restoring backup on the server'),
          content: Text(''),
          isActive: false,
        ),
        Step(
          title: Text('Restore Completed'),
          content: Text(''),
          isActive: false,
        ),

      ];

    }
    else if(listResortModel!.data![index]!.status==3)
    {
      steps =
      [
        Step(
          title: Text('Scheduled'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('In progress'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('Downloading backup file from cloud'),
          content: Text(''),
          isActive: true,
          state: StepState.complete,
        ),
        Step(
          title: Text('Uploading backup file to server'),
          content: Text(''),
          isActive: false,          ),
        Step(
          title: Text('Restoring backup on the server'),
          content: Text(''),
          isActive: false,
        ),
        Step(
          title: Text('Restore Completed'),
          content: Text(''),
          isActive: false,
        ),

      ];

    }
    else if(listResortModel!.data![index]!.status==4)
    {
      steps =
      [
        Step(
          title: Text('Scheduled'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('In progress'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('Downloading backup file from cloud'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('Uploading backup file to server'),
          content: Text(''),
          isActive: true,
          state: StepState.complete,
        ),
        Step(
          title: Text('Restoring backup on the server'),
          content: Text(''),
          isActive: false,
        ),
        Step(
          title: Text('Restore Completed'),
          content: Text(''),
          isActive: false,
        ),

      ];

    }
    else if(listResortModel!.data![index]!.status==5)
    {
      steps =
      [
        Step(
          title: Text('Scheduled'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('In progress'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('Downloading backup file from cloud'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('Uploading backup file to server'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('Restoring backup on the server'),
          content: Text(''),
          isActive: true,
          state: StepState.complete,
        ),
        Step(
          title: Text('Restore Completed'),
          content: Text(''),
          isActive: false,
        ),

      ];

    }
    else if(listResortModel!.data![index]!.status==1)
    {
      steps =
      [
        Step(
          title: Text('Scheduled'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('In progress'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('Downloading backup file from cloud'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('Uploading backup file to server'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('Restoring backup on the server'),
          content: Text(''),
          isActive: true,
        ),
        Step(
          title: Text('Restore Completed'),
          content: Text(''),
          isActive: true,
          state: StepState.complete,
        ),

      ];

    }

      return Stepper(
        physics: ClampingScrollPhysics(),
        controlsBuilder: (context, _) {
          return Container(
            height: 0,
          );
        },
        steps: steps,
        type: StepperType.vertical,

      );

    }
    
    Widget StepList2(int index){
      if(listResortModel!.data![index]!.status==0)
      {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              children: [
                Icon(Icons.check_circle,color: sh_green,size: 20,),
                SizedBox(width: 8,),
                Text("Scheduled",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              height: 20,
              color: sh_grey,
              width: 1.5,
            ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("In progress",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Downloading backup file from cloud",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Uploading backup file to server",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restoring backup on the server",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restore Completed",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
            ],
          ),
        );
      }
      else if(listResortModel!.data![index]!.status==1)
      {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Scheduled",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("In progress",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Downloading backup file from cloud",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Uploading backup file to server",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restoring backup on the server",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restore Completed",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
            ],
          ),
        );
      }
      else if(listResortModel!.data![index]!.status==2)
      {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Scheduled",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: food_color_blue_gradient2,size: 20,),
                  SizedBox(width: 8,),
                  Text("In progress",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Downloading backup file from cloud",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Uploading backup file to server",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restoring backup on the server",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restore Completed",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
            ],
          ),
        );
      }
      else if(listResortModel!.data![index]!.status==3)
      {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Scheduled",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("In progress",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: food_color_blue_gradient2,size: 20,),
                  SizedBox(width: 8,),
                  Text("Downloading backup file from cloud",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Uploading backup file to server",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restoring backup on the server",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restore Completed",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
            ],
          ),
        );
      }
      else if(listResortModel!.data![index]!.status==4)
      {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Scheduled",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("In progress",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Downloading backup file from cloud",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: food_color_blue_gradient2,size: 20,),
                  SizedBox(width: 8,),
                  Text("Uploading backup file to server",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restoring backup on the server",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restore Completed",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
            ],
          ),
        );
      }
      else if(listResortModel!.data![index]!.status==5)
      {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Scheduled",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("In progress",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Downloading backup file from cloud",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_green,size: 20,),
                  SizedBox(width: 8,),
                  Text("Uploading backup file to server",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: food_color_blue_gradient2,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restoring backup on the server",style: TextStyle(color: sh_app_black,fontFamily: 'Bold',fontSize: 16),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                color: sh_grey,
                width: 1.5,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle,color: sh_grey,size: 20,),
                  SizedBox(width: 8,),
                  Text("Restore Completed",style: TextStyle(color: sh_app_black,fontFamily: 'Regular',fontSize: 16),)
                ],
              ),
            ],
          ),
        );
      }
      else{
        return Container();
      }
      
    }


    return Scaffold(
      backgroundColor: sh_white,
      body: Container(
          width: width,
          height: height,

          color: sh_white,
          padding: EdgeInsets.all(8),
          child: FutureBuilder<RestoreListModel?>(
            future: fetchRestore(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(listResortModel!.data!.length==0){
                  return Container(
                    height: height*.5,
                    child: Center(
                      child: Text(
                        'No Data Found',
                        style: TextStyle(
                            fontSize: 20,
                            color: sh_app_black,
                            fontFamily: 'Bold',
                            fontWeight: FontWeight.bold),
                      ),
                    ),);
                }else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: listResortModel!.data!
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
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                "Customer : " +
                                                    listResortModel!.data![index]!
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
                                                    listResortModel!.data![index]!
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
                                                listResortModel!.data![index]!
                                                    .restoreTime ==
                                                    null ? '' :
                                                "Backup : " +
                                                    listResortModel!.data![index]!
                                                        .restoreTime!,
                                                style: TextStyle(
                                                    color: sh_app_txt_color,
                                                    fontSize: 15,
                                                    fontFamily: 'Bold'),
                                              ),
                                              SizedBox(
                                                height: 14,
                                              ),
                                              // Text(
                                              //   listResortModel!.data![index]!
                                              //       .message ==
                                              //       null ? '' :
                                              //   listResortModel!.data![index]!
                                              //       .message!,
                                              //   style: TextStyle(
                                              //       color: sh_green,
                                              //       fontSize: 15,
                                              //       fontFamily: 'Bold'),
                                              // ),
                                              // SizedBox(
                                              //   height: 4,
                                              // ),
                                              StepList2(index),
                                              // Stepper(
                                              //   physics: ClampingScrollPhysics(),
                                              //   currentStep: this.current_step,
                                              //   controlsBuilder: (context, _) {
                                              //     return Row(
                                              //       children: <Widget>[
                                              //         Container(),
                                              //         Container(),
                                              //       ],
                                              //     );
                                              //   },
                                              //   steps: steps,
                                              //   type: StepperType.vertical,
                                              //
                                              // ),


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
                  );
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            },
          )),
    );
  }
}
