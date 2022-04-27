import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/fragment/BackupFragment.dart';
import 'package:strapit/fragment/RestoreFragment.dart';
import 'package:strapit/models/ListAllBackup2.dart';
import 'package:strapit/models/ListAllBackupModel.dart';
import 'package:strapit/models/ListCustomerBackupModel.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';
import 'package:http/http.dart';

class ManageBackupScreen extends StatefulWidget {
  static String tag = '/ManageBackupScreen';
  final String? PortalId,BackupUser;

   ManageBackupScreen({this.PortalId,this.BackupUser});

  @override
  _ManageBackupScreenState createState() => _ManageBackupScreenState();
}

class _ManageBackupScreenState extends State<ManageBackupScreen> with TickerProviderStateMixin{
  String? pickdate = '', pickmonth = '', pickyear = '';
  DateTime selectedDate = DateTime.now();
  ListAllBackupModel? listAllBackupModel;
  ListCustomerBackupModel? listCustomerBackupModel;
  int? IsAdmin;
  List<ListAllBackup2?>? listAllBackupModeldata=[];

  List<ListAllBackup2?>? listCustomerBackupModeldata=[];
  TabController? _tabController;

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

      listAllBackupModel = new ListAllBackupModel.fromJson(jsonResponse);

      for (var i = 0; i < listAllBackupModel!.data!.length; i++) {
        if (listAllBackupModel!.data![i]!.portalId == widget.PortalId.toInt()) {
          listAllBackupModeldata!.add(ListAllBackup2(backupId: listAllBackupModel!.data![i]!.backupId,
          backupTime: listAllBackupModel!.data![i]!.backupTime,customerName: listAllBackupModel!.data![i]!.customerName,
          message: listAllBackupModel!.data![i]!.message,portalId: listAllBackupModel!.data![i]!.portalId,
          portalName: listAllBackupModel!.data![i]!.portalName,portalUrl: listAllBackupModel!.data![i]!.portalUrl,
          status: listAllBackupModel!.data![i]!.status));

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

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2,initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: sh_white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Manage Backups",
          style: TextStyle(
              color: sh_app_txt_color, fontSize: 24, fontFamily: 'Bold'),
        ),
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actionsIconTheme: IconThemeData(color: sh_white),
      ),
      body: Container(
          height: height,
          child: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                          color: sh_app_black,
                        ),
                        labelColor: sh_white,
                        unselectedLabelColor: sh_app_black,
                        tabs: [
                          Tab(
                            text: 'BACKUP',
                          ),
                          Tab(
                            text: 'RESTORE',
                          ),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: Container(
                margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    BackupFragment(PortalId: widget.PortalId!,BackUpUser: widget.BackupUser),
                    RestoreFragment(PortalId: widget.PortalId!,BackUpUser: widget.BackupUser),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      color: sh_white,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(
              25.0,
            ),
          ),
          child: _tabBar),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}