import 'dart:convert';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/retry.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/models/CustomerListModel.dart';
import 'package:strapit/models/PortalAddFailModel.dart';
import 'package:strapit/models/PortalAddModel.dart';
import 'package:strapit/models/PortalTypeModel.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';
import 'package:http/http.dart'as http;
import 'package:http/http.dart';

class EditPortalScreen extends StatefulWidget {
  static String tag='/EditPortalScreen';
  final String? PortalId,CustomerId,UserIdName,Name,Username,Password,Url,Host,Port,RootFolder,StartDate,EndDate,PortalType;
  final String? mysqlUsername,mysqlPassword,mysqlHost,mysqlPort,mysqlDatabase;

  EditPortalScreen({this.PortalId,this.CustomerId,this.UserIdName,this.Name,this.Username,this.Password,this.Url,this.Host,this.Port,this.RootFolder,this.StartDate,this.EndDate,
  this.mysqlUsername,this.mysqlPassword,this.mysqlHost,this.mysqlPort,this.mysqlDatabase,this.PortalType});
  // const EditPortalScreen({Key? key}) : super(key: key);

  @override
  _EditPortalScreenState createState() => _EditPortalScreenState();
}

class _EditPortalScreenState extends State<EditPortalScreen> {
  var portaltypeCont = TextEditingController();
  var usernameCont = TextEditingController();
  var passwordCont = TextEditingController();
  var portCont = TextEditingController();
  var nameCont = TextEditingController();
  var folderCont= TextEditingController();
  var urlCont = TextEditingController();
  var hostCont = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  var selectedAddressIndex = 0;
  var selectedUserIndex = -1;
  PortalAddModel? portalAddModel;
  PortalAddFailModel? portalAddFailModel;
  bool _showPassword = false;
  bool _showPasswordMySql = false;
  String? pickdate='', pickmonth='', pickyear='';
  String? pickenddate='', pickendmonth='', pickendyear='';
  var mysqlusernameCont = TextEditingController();
  var mysqlpasswordCont = TextEditingController();
  var mysqlportCont = TextEditingController();
  var mysqlhostCont = TextEditingController();
  var mysqldatabaseCont = TextEditingController();


  Country _selectedDialogCountry =  CountryPickerUtils.getCountryByPhoneCode('1-246');

  DateTime selectedDate = DateTime.now();
  DateTime selectedendDate = DateTime.now();
  CustomerListModel? customerListModel;
  Future<PortalTypeModel?>? portaltypedetail;
  PortalTypeModel? portalTypeModel;
  PortalTypeModelDataPortalTypes? selectedValue;
  String portal_type='';
  int? IsAdmin;
  String? UserName='';

  void initState() {
    super.initState();
    fetchadd();
    // fetchCustomer();
    // disableCapture();
  }

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
        // toast(selectedDate.toString().substring(0, 10));




        var yearString = DateFormat.yMMMMd('en_US')
            .format(selectedDate)
            .substring(DateFormat.yMMMMd('en_US')
            .format(selectedDate)
            .length -
            4);
        var monthstr;
        var datestr;

        if (DateFormat.yMMMMd('en_US').format(selectedDate) !=
            null &&
            DateFormat.yMMMMd('en_US')
                .format(selectedDate)
                .length >=
                6) {
          datestr = DateFormat.yMMMMd('en_US')
              .format(selectedDate)
              .substring(
              0,
              DateFormat.yMMMMd('en_US')
                  .format(selectedDate)
                  .length -
                  6);
          datestr = datestr.substring(datestr.length - 2);

        }

        if (DateFormat.yMMMMd('en_US').format(selectedDate) !=
            null &&
            DateFormat.yMMMMd('en_US')
                .format(selectedDate)
                .length >=
                8) {
          monthstr = DateFormat.yMMMMd('en_US')
              .format(selectedDate)
              .substring(
              0,
              DateFormat.yMMMMd('en_US')
                  .format(selectedDate)
                  .length -
                  8);
        }

        pickdate = datestr;
        pickmonth = monthstr;
        pickyear = yearString;

        //end date change by 1 year

        selectedendDate = DateTime(selectedDate.year+1,selectedDate.month,selectedDate.day);



        var yearString2 = DateFormat.yMMMMd('en_US')
            .format(selectedendDate)
            .substring(DateFormat.yMMMMd('en_US')
            .format(selectedendDate)
            .length -
            4);
        var monthstr2;
        var datestr2;

        if (DateFormat.yMMMMd('en_US').format(selectedendDate) !=
            null &&
            DateFormat.yMMMMd('en_US')
                .format(selectedendDate)
                .length >=
                6) {
          datestr2 = DateFormat.yMMMMd('en_US')
              .format(selectedendDate)
              .substring(
              0,
              DateFormat.yMMMMd('en_US')
                  .format(selectedendDate)
                  .length -
                  6);
          datestr2 = datestr2.substring(datestr2.length - 2);

        }

        if (DateFormat.yMMMMd('en_US').format(selectedendDate) !=
            null &&
            DateFormat.yMMMMd('en_US')
                .format(selectedendDate)
                .length >=
                8) {
          monthstr2 = DateFormat.yMMMMd('en_US')
              .format(selectedendDate)
              .substring(
              0,
              DateFormat.yMMMMd('en_US')
                  .format(selectedendDate)
                  .length -
                  8);
        }

        pickenddate = datestr2;
        pickendmonth = monthstr2;
        pickendyear = yearString2;
      });
  }

  _selectendDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedendDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),

    );
    if (selected != null && selected !=selectedendDate)
      setState(() {
        selectedendDate = selected;


        var yearString = DateFormat.yMMMMd('en_US')
            .format(selectedendDate)
            .substring(DateFormat.yMMMMd('en_US')
            .format(selectedendDate)
            .length -
            4);
        var monthstr;
        var datestr;

        if (DateFormat.yMMMMd('en_US').format(selectedendDate) !=
            null &&
            DateFormat.yMMMMd('en_US')
                .format(selectedendDate)
                .length >=
                6) {
          datestr = DateFormat.yMMMMd('en_US')
              .format(selectedendDate)
              .substring(
              0,
              DateFormat.yMMMMd('en_US')
                  .format(selectedendDate)
                  .length -
                  6);
          datestr = datestr.substring(datestr.length - 2);

        }

        if (DateFormat.yMMMMd('en_US').format(selectedendDate) !=
            null &&
            DateFormat.yMMMMd('en_US')
                .format(selectedendDate)
                .length >=
                8) {
          monthstr = DateFormat.yMMMMd('en_US')
              .format(selectedendDate)
              .substring(
              0,
              DateFormat.yMMMMd('en_US')
                  .format(selectedendDate)
                  .length -
                  8);
        }

        pickenddate = datestr;
        pickendmonth = monthstr;
        pickendyear = yearString;




      });
  }

  Future<String?> getAddPortal() async {
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

      String name=nameCont.text;
      String url=urlCont.text;
      String username=usernameCont.text;
      String port=portCont.text;
      String password=passwordCont.text;
      String folder=folderCont.text;
      String host=hostCont.text;

      String mysqlusername=mysqlusernameCont.text;
      String mysqlport=mysqlportCont.text;
      String mysqlpassword=mysqlpasswordCont.text;
      String mysqlhost=mysqlhostCont.text;
      String mysqldatabase=mysqldatabaseCont.text;

      // toast(customerListModel!.data![selectedAddressIndex]!.id.toString()+ " , "+portal_type);
      String useridPortal='';
      IsAdmin=prefs.getInt("IsAdmin");
      if(IsAdmin==1) {
        useridPortal =customerListModel!.data![selectedAddressIndex]!.id.toString();
      }else{
        useridPortal=widget.CustomerId!;
      }
      final msg = jsonEncode({"id":widget.PortalId,"username": username,"mysql_username":mysqlusername, "password": password,"mysql_password": mysqlpassword, "confirm_password": password,
        "name": name, "url": url, "port": port,"mysql_port":mysqlport, "root_folder": folder,"host":host,"mysql_host":mysqlhost,"mysql_database":mysqldatabase,
        "plan_start_date":selectedDate.toString().substring(0, 10),"plan_end_date":selectedendDate.toString().substring(0, 10),"user_id":useridPortal,"portal_type":portal_type});

      print("chhhh"+msg);

      final client = RetryClient(http.Client());
      var response;
      try {
        response=await client.post(
            Uri.parse(
                'https://strapit.rcstaging.co.in/strapit/public/api/editPortal'),
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
        portalAddModel = new PortalAddModel.fromJson(jsonResponse);
        EasyLoading.dismiss();

        toast(portalAddModel!.message);
        Navigator.pop(context);
        print('sucess');
      } else {
        EasyLoading.dismiss();
        portalAddFailModel = new PortalAddFailModel.fromJson(jsonResponse);
        //
        // toast(err_model!.message);
        toast(portalAddFailModel!.data!);
//        print("cat dta$cat_model");

      }
      return "cat_model";
    } catch (e) {
      EasyLoading.dismiss();
      print('caught error $e');
    }
  }

  Future<String?> getCheckSFTP() async {
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


      String name=nameCont.text;
      String url=urlCont.text;
      String username=usernameCont.text;
      String port=portCont.text;
      String password=passwordCont.text;
      String folder=folderCont.text;
      String host=hostCont.text;



      final msg = jsonEncode({"username": username, "password": password,
        "url": url, "port": port, "root_folder": folder,"host":host,
        "portal_type":widget.PortalType});



      print(msg);

      final client = RetryClient(http.Client());
      var response;
      try {
        response=await client.post(
            Uri.parse(
                'https://strapit.rcstaging.co.in/strapit/public/api/checkConnection'),
            headers: headers,
            body: msg);
      } finally {
        client.close();
      }



      final jsonResponse = json.decode(response.body);
      print('not json sftp$jsonResponse');
      print('Response bodysftp: ${response.body}');
      if (response.statusCode == 200) {
        portalAddFailModel = new PortalAddFailModel.fromJson(jsonResponse);
        toast(portalAddFailModel!.message!);
        EasyLoading.dismiss();
        print('sucess');
      } else {
        EasyLoading.dismiss();
        portalAddFailModel = new PortalAddFailModel.fromJson(jsonResponse);
        //
        // toast(err_model!.message);
        toast(portalAddFailModel!.data!);
//        print("cat dta$cat_model");

      }
      return "cat_model";
    } catch (e) {
      EasyLoading.dismiss();
      print('caught error $e');
    }
  }

  Future<String?> getCheckDB() async {
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

      String name=nameCont.text;
      String url=urlCont.text;
      String username=usernameCont.text;
      String port=portCont.text;
      String password=passwordCont.text;
      String folder=folderCont.text;
      String host=hostCont.text;

      String mysqlusername=mysqlusernameCont.text;
      String mysqlport=mysqlportCont.text;
      String mysqlpassword=mysqlpasswordCont.text;
      String mysqlhost=mysqlhostCont.text;
      String mysqldatabase=mysqldatabaseCont.text;



      final msg = jsonEncode({"username": username,"mysql_username":mysqlusername, "password": password,"mysql_password": mysqlpassword,
         "url": url, "port": port,"mysql_port":mysqlport, "root_folder": folder,"host":host,"mysql_host":mysqlhost,"mysql_database":mysqldatabase,
        "portal_type":widget.PortalType});

      print(msg);

      final client = RetryClient(http.Client());
      var response;
      try {
        response=await client.post(
            Uri.parse(
                'https://strapit.rcstaging.co.in/strapit/public/api/checkDBConnection'),
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
        portalAddFailModel = new PortalAddFailModel.fromJson(jsonResponse);
        toast(portalAddFailModel!.message!);
        EasyLoading.dismiss();

        print('sucess');
      } else {
        EasyLoading.dismiss();
        portalAddFailModel = new PortalAddFailModel.fromJson(jsonResponse);

        toast(portalAddFailModel!.data!);
//        print("cat dta$cat_model");

      }
      return "cat_model";
    } catch (e) {
      EasyLoading.dismiss();
      print('caught error $e');
    }
  }


  Future<String?> fetchadd() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final DateFormat format = new DateFormat("yyyy-MM-dd");

      var yearString = DateFormat.yMMMMd('en_US')
          .format(format.parse(widget.StartDate!))
          .substring(DateFormat.yMMMMd('en_US')
          .format(format.parse(widget.StartDate!))
          .length -
          4);
      var monthstr;
      var datestr;

      if (DateFormat.yMMMMd('en_US').format(format.parse(widget.StartDate!)) !=
          null &&
          DateFormat.yMMMMd('en_US')
              .format(format.parse(widget.StartDate!))
              .length >=
              6) {
        datestr = DateFormat.yMMMMd('en_US')
            .format(format.parse(widget.StartDate!))
            .substring(
            0,
            DateFormat.yMMMMd('en_US')
                .format(format.parse(widget.StartDate!))
                .length -
                6);
        datestr = datestr.substring(datestr.length - 2);

      }

      if (DateFormat.yMMMMd('en_US').format(format.parse(widget.StartDate!)) !=
          null &&
          DateFormat.yMMMMd('en_US')
              .format(format.parse(widget.StartDate!))
              .length >=
              8) {
        monthstr = DateFormat.yMMMMd('en_US')
            .format(format.parse(widget.StartDate!))
            .substring(
            0,
            DateFormat.yMMMMd('en_US')
                .format(format.parse(widget.StartDate!))
                .length -
                8);
      }

      pickdate = datestr;
      pickmonth = monthstr;
      pickyear = yearString;


      var yearString2 = DateFormat.yMMMMd('en_US')
          .format(format.parse(widget.EndDate!))
          .substring(DateFormat.yMMMMd('en_US')
          .format(format.parse(widget.EndDate!))
          .length -
          4);
      var monthstr2;
      var datestr2;

      if (DateFormat.yMMMMd('en_US').format(format.parse(widget.EndDate!)) !=
          null &&
          DateFormat.yMMMMd('en_US')
              .format(format.parse(widget.EndDate!))
              .length >=
              6) {
        datestr2 = DateFormat.yMMMMd('en_US')
            .format(format.parse(widget.EndDate!))
            .substring(
            0,
            DateFormat.yMMMMd('en_US')
                .format(format.parse(widget.EndDate!))
                .length -
                6);
        datestr2 = datestr2.substring(datestr2.length - 2);

      }

      if (DateFormat.yMMMMd('en_US').format(format.parse(widget.EndDate!)) !=
          null &&
          DateFormat.yMMMMd('en_US')
              .format(format.parse(widget.EndDate!))
              .length >=
              8) {
        monthstr2 = DateFormat.yMMMMd('en_US')
            .format(format.parse(widget.EndDate!))
            .substring(
            0,
            DateFormat.yMMMMd('en_US')
                .format(format.parse(widget.EndDate!))
                .length -
                8);
      }

      pickenddate = datestr2;
      pickendmonth = monthstr2;
      pickendyear = yearString2;


      usernameCont.text=widget.Username!;
      passwordCont.text=widget.Password!;
      portCont.text=widget.Port!;
      nameCont.text=widget.Name!;
      folderCont.text=widget.RootFolder!;
      urlCont.text=widget.Url!;
      hostCont.text=widget.Host!;
      selectedDate=format.parse(widget.StartDate!);
      selectedendDate=format.parse(widget.EndDate!);
      mysqlusernameCont.text=widget.mysqlUsername!;
      mysqlpasswordCont.text=widget.mysqlPassword!;
      mysqlhostCont.text=widget.mysqlHost!;
      mysqlportCont.text=widget.mysqlPort!;
      mysqldatabaseCont.text=widget.mysqlDatabase!;
      portaltypeCont.text=widget.PortalType!;

      // portaltypedetail = fetchPortalType();
      UserName=prefs.getString("UserName");
      IsAdmin=prefs.getInt("IsAdmin");
      if(IsAdmin==1) {
        fetchCustomer();
      }else{
        portaltypedetail = fetchPortalType();
      }

      return '';
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<CustomerListModel?> fetchCustomer() async {
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


      Response response =
      await get(Uri.parse('https://strapit.rcstaging.co.in/strapit/public/api/listCustomers'), headers: headers);

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      customerListModel = new CustomerListModel.fromJson(jsonResponse);
      String gg=widget.UserIdName!;
      print(gg);
      for (var i = 0; i < customerListModel!.data!.length; i++) {
        if (customerListModel!.data![i]!.name == gg) {
          selectedUserIndex = i;
          selectedAddressIndex=i;
        }
      }
      EasyLoading.dismiss();
      portaltypedetail = fetchPortalType();

      return customerListModel;
    } catch (e) {
      EasyLoading.dismiss();
      print('caught error $e');
    }
  }


  Future<PortalTypeModel?> fetchPortalType() async {
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


      Response response =
      await get(Uri.parse('https://strapit.rcstaging.co.in/strapit/public/api/listPortalTypes'), headers: headers);

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      portalTypeModel = new PortalTypeModel.fromJson(jsonResponse);
      // print(_addressModel!.data);

      for (var i = 0; i < portalTypeModel!.data!.portalTypes!.length; i++) {
        if (portalTypeModel!.data!.portalTypes![i]!.type == widget.PortalType) {
          selectedValue = portalTypeModel!.data!.portalTypes![i];
          portal_type=portalTypeModel!.data!.portalTypes![i]!.type!;
        }
      }
      EasyLoading.dismiss();
      setState(() {

      });

      return portalTypeModel;
    } catch (e) {
      EasyLoading.dismiss();
      print('caught error $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);

    ShowDlg2() {
      var height2 = MediaQuery.of(context).size.height;


      return showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 200),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState2
                  /*You can rename this!*/) {
                return SafeArea(
                    child: Scaffold(
                      body: Container(
                        height: height2,
                        padding: EdgeInsets.all(8),
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.bottomCenter,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: customerListModel!.data!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: EdgeInsets.all(textSizeSmall),
                                          margin: EdgeInsets.only(
                                            right: spacing_standard,
                                            left: spacing_standard,
                                          ),
                                          decoration: boxDecoration(
                                              radius: 2,
                                              showShadow: true,
                                              color: sh_white
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Radio(
                                                  value: index,
                                                  groupValue: selectedAddressIndex,
                                                  onChanged: (int? value) {
                                                    setState2(() {
                                                      selectedAddressIndex = value!;
                                                      selectedUserIndex= value;
                                                    });
                                                  },
                                                  activeColor: sh_colorPrimary2),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Container(


                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(8.0,8,8,8),
                                                        child: Container(
                                                          padding: EdgeInsets.fromLTRB(12,6,12,6),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text(customerListModel!.data![index]!.name!,
                                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: sh_app_black)),
                                                              SizedBox(height: 6,),
                                                              Text(customerListModel!.data![index]!.email!,style: TextStyle(fontSize: 16,color: sh_app_black)),
                                                              SizedBox(height: 2,),
                                                              Text(customerListModel!.data![index]!.country!,style: TextStyle(fontSize: 16,color: sh_app_black)),
                                                              SizedBox(height: 2,),
                                                              Text(customerListModel!.data![index]!.phone!,style: TextStyle(fontSize: 16,color: sh_app_black)),
                                                              SizedBox(height: 2,),

                                                            ],),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 12,)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                  SizedBox(
                                    height: 60,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                child: Container(
                                  height: 60,
                                  width: width,
                                  margin: EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(color: sh_white),
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.of(context).pop(ConfirmAction.CANCEL);
                                      // getRegister();
// MyCheck();
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(
                                          top: 6, bottom: 10),
                                      decoration: boxDecoration(
                                          bgColor: sh_btn_color, radius: 10, showShadow: true),
                                      child: text("Select",
                                          fontSize: 24.0,
                                          textColor: sh_app_txt_color,
                                          isCentered: true,
                                          fontFamily: 'Bold'),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ));
              });
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
            Tween(begin: Offset(0, 0.8), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
    }

    UserSelection(){
      if(IsAdmin==1) {
        // String userss=widget.Username!;
        String userss = customerListModel!.data![selectedUserIndex]!.name!;

        return InkWell(
          onTap: () async {
            ShowDlg2();
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(
                spacing_standard_new, 16,
                spacing_standard_new, 16),
            decoration:
            BoxDecoration(border: Border.all(color: sh_app_black, width: 1.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("User Name\n$userss", style: TextStyle(
                    color: sh_app_txt_color,
                    fontSize: 16,
                    fontFamily: 'Bold'),),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        );
      }else{

        String userss=widget.Username!;
        // String userss = customerListModel!.data![selectedUserIndex]!.name!;

        return InkWell(
          onTap: () async {
            // ShowDlg2();
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(
                spacing_standard_new, 16,
                spacing_standard_new, 16),
            decoration:
            BoxDecoration(border: Border.all(color: sh_app_black, width: 1.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("User Name\n$UserName", style: TextStyle(
                    color: sh_app_txt_color,
                    fontSize: 16,
                    fontFamily: 'Bold'),),
              ],
            ),
          ),
        );
      }
    }


    return Scaffold(
      backgroundColor: sh_white,
      appBar: AppBar(
        elevation: 0,
        title: Text("Edit Portal",style: TextStyle(color: sh_app_txt_color,fontSize: 24,fontFamily: 'Bold'),),
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
                    UserSelection(),
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
                            controller: nameCont,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please Enter Username';
                              }
                              return null;
                            },
                            cursorColor: sh_app_txt_color,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                              hintText: "Portal Nickname",
                              hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                              labelText: "Portal Nickname",
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: DropdownButton<PortalTypeModelDataPortalTypes?>(
                              underline: Container(),
                              // decoration: InputDecoration(
                              //     labelText: 'Change Country'
                              // ),
                              isExpanded: true,
                              items: portalTypeModel!.data!.portalTypes!.map((item) {
                                return new DropdownMenuItem(
                                  child: Text(
                                      item!.value!,
                                      style: TextStyle(color: sh_app_txt_color,fontSize: 16,fontFamily: 'Bold')
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              hint: Text('Select Portal Type',style: TextStyle(color: sh_app_txt_color,fontSize: 16,fontFamily: 'Bold')),
                              value: selectedValue,
                              onChanged: (PortalTypeModelDataPortalTypes? newVal) async{
// toast(newVal!.type);
                                setState(() {
                                  selectedValue = newVal;
                                  portal_type = newVal!.type!;

                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    //         onEditingComplete: () =>
                    //             node.nextFocus(),
                    //         enabled: false,
                    //         controller: portaltypeCont,
                    //         validator: (text) {
                    //           if (text == null || text.isEmpty) {
                    //             return 'Please Enter Username';
                    //           }
                    //           return null;
                    //         },
                    //         cursorColor: sh_app_txt_color,
                    //         decoration: InputDecoration(
                    //           contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                    //           hintText: "Portal Type",
                    //           hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                    //           labelText: "Portal Type",
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
                    SizedBox(height: 12,),
                    Form(
                      key: _formKey2,
                      child: Container(
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
                              keyboardType: TextInputType.text,
                              controller: urlCont,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Please Enter Url';
                                }
                                return null;
                              },
                              cursorColor: sh_app_txt_color,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                hintText: "Portal Url",
                                hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                labelText: "Portal Url",
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
                    ),
                    SizedBox(height: 12,),

                    InkWell(
                      onTap: () async{
                        _selectDate(context);

                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            spacing_standard_new,16,
                            spacing_standard_new,16),
                        decoration:
                        BoxDecoration(border: Border.all(color: sh_app_black, width: 1.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(pickdate=='' ? "Select Plan Start Date" : pickdate! +
                                " " +
                                pickmonth! +
                                "," +
                                pickyear!,style: TextStyle(color: sh_app_txt_color,fontSize: 16,fontFamily: 'Bold'),),
                            Icon(Icons.date_range_sharp)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12,),
                    InkWell(
                      onTap: () async{
                        _selectendDate(context);

                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            spacing_standard_new,16,
                            spacing_standard_new,16),
                        decoration:
                        BoxDecoration(border: Border.all(color: sh_app_black, width: 1.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(pickenddate=='' ? "Select Plan End Date" : pickenddate! +
                                " " +
                                pickendmonth! +
                                "," +
                                pickendyear!,style: TextStyle(color: sh_app_txt_color,fontSize: 16,fontFamily: 'Bold'),),
                            Icon(Icons.date_range_sharp)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12,),

                    Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            spacing_standard_new,16,
                            spacing_standard_new,16),
                        decoration:
                        BoxDecoration(border: Border.all(color: sh_app_black, width: 1.0)),
                        child: Column(
                          children: [
                            Text("SFTP/SSH Controls",style: TextStyle(color: sh_app_txt_color,fontSize: 20,fontFamily: 'Bold'),),
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
                                    keyboardType: TextInputType.text,
                                    controller: hostCont,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please Enter Sftp/SSH Host';
                                      }
                                      return null;
                                    },
                                    cursorColor: sh_app_txt_color,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                      hintText: "Sftp/SSH Host",
                                      hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                      labelText: "Sftp/SSH Host",
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
                                    keyboardType: TextInputType.text,
                                    controller: portCont,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please Enter Sftp/SSH Port';
                                      }
                                      return null;
                                    },
                                    cursorColor: sh_app_txt_color,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                      hintText: "Sftp/SSH Port",
                                      hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                      labelText: "Sftp/SSH Port",
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
                                    keyboardType: TextInputType.text,
                                    controller: folderCont,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please Enter Root Folder';
                                      }
                                      return null;
                                    },
                                    cursorColor: sh_app_txt_color,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                      hintText: "Website Root Folder(absolute server path)",
                                      hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                      labelText: "Website Root Folder(absolute server path)",
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
                                    controller: usernameCont,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please Enter Sftp/SSh User';
                                      }
                                      return null;
                                    },
                                    cursorColor: sh_app_txt_color,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                      hintText: "Sftp/SSh User",
                                      hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                      labelText: "Sftp/SSh User",
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
                                    obscureText: !this._showPassword,
                                    controller: passwordCont,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please Enter Sftp/SSh Password';
                                      }
                                      return null;
                                    },
                                    cursorColor: sh_app_txt_color,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                      hintText: "Sftp/SSh Password",
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
                                      labelText: "Sftp/SSh Password",
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      // TODO submit
                                      if (_formKey2.currentState!.validate()) {
                                        // TODO submit
                                        if(widget.PortalType==''){
                                          toast("Please Select Portal Type");
                                        }else {
                                          FocusScope.of(context).requestFocus(
                                              FocusNode());
                                          getCheckSFTP();
                                        }
                                      }
                                    }
                                    // getCheckSFTP();
                                    // getRegister();
// MyCheck();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 2, bottom: 6,left: 12,right: 12),
                                    decoration: boxDecoration(
                                        bgColor: sh_btn_color, radius: 10, showShadow: true),
                                    child: text("Check Connection",
                                        fontSize: 14.0,
                                        textColor: sh_app_txt_color,
                                        isCentered: true,
                                        fontFamily: 'Bold'),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),



                    SizedBox(height: 12,),
                    Form(
                      key: _formKey3,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            spacing_standard_new,16,
                            spacing_standard_new,16),
                        decoration:
                        BoxDecoration(border: Border.all(color: sh_app_black, width: 1.0)),
                        child: Column(
                          children: [
                            Text("Mysql Controls",style: TextStyle(color: sh_app_txt_color,fontSize: 20,fontFamily: 'Bold'),),
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
                                    controller: mysqlusernameCont,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please Enter MySql Username';
                                      }
                                      return null;
                                    },
                                    cursorColor: sh_app_txt_color,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                      hintText: "MySql Username",
                                      hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                      labelText: "MySql Username",
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
                                    controller: mysqlpasswordCont,
                                    obscureText: !this._showPasswordMySql,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please Enter MySql Password';
                                      }
                                      return null;
                                    },
                                    cursorColor: sh_app_txt_color,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                      hintText: "MySql Password",
                                      hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: this._showPasswordMySql ? sh_colorPrimary2 : Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() => this._showPasswordMySql = !this._showPasswordMySql);
                                        },
                                      ),
                                      labelText: "MySql Password",
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
                                    controller: mysqlhostCont,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please Enter MySql Host';
                                      }
                                      return null;
                                    },
                                    cursorColor: sh_app_txt_color,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                      hintText: "MySql Host",
                                      hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                      labelText: "MySql Host",
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
                                    controller: mysqlportCont,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please Enter MySql Port';
                                      }
                                      return null;
                                    },
                                    cursorColor: sh_app_txt_color,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                      hintText: "MySql Port",
                                      hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                      labelText: "MySql Port",
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
                                    controller: mysqldatabaseCont,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please Enter MySql Database';
                                      }
                                      return null;
                                    },
                                    cursorColor: sh_app_txt_color,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                                      hintText: "MySql Database",
                                      hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                                      labelText: "MySql Database",
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      // TODO submit
                                      if (_formKey2.currentState!.validate()) {
                                        // TODO submit
                                        if (_formKey3.currentState!.validate()) {
                                          if (widget.PortalType == '') {
                                            toast("Please Select Portal Type");
                                          } else {
                                            FocusScope.of(context).requestFocus(
                                                FocusNode());
                                            getCheckDB();
                                          }
                                        }
                                      }
                                    }

                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 2, bottom: 6,left: 12,right: 12),
                                    decoration: boxDecoration(
                                        bgColor: sh_btn_color, radius: 10, showShadow: true),
                                    child: text("Check Connection",
                                        fontSize: 14.0,
                                        textColor: sh_app_txt_color,
                                        isCentered: true,
                                        fontFamily: 'Bold'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: 42,),
                    InkWell(
                      onTap: () async {

                        // toast(customerListModel!.data![selectedAddressIndex]!.id.toString()+ " , "+portal_type);
                        getAddPortal();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            top: 6, bottom: 10),
                        decoration: boxDecoration(
                            bgColor: sh_btn_color, radius: 10, showShadow: true),
                        child: text("Save Portal",
                            fontSize: 24.0,
                            textColor: sh_app_txt_color,
                            isCentered: true,
                            fontFamily: 'Bold'),
                      ),
                    ),

                  ],
                )),
          ))

    );
  }
}
