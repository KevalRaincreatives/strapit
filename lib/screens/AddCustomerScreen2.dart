import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:strapit/screens/AdminDashoardScreen.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';

class AddCustomerScreen extends StatefulWidget {
  static String tag='/AddCustomerScreen';
  const AddCustomerScreen({Key? key}) : super(key: key);

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  var emailCont = TextEditingController();
  var passwordCont = TextEditingController();
  var phoneCont = TextEditingController();
  var websiteCont = TextEditingController();
  var nameCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  String? pickdate='', pickmonth='', pickyear='';

  Country _selectedDialogCountry =  CountryPickerUtils.getCountryByPhoneCode('1-246');
  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection('Users');


  Future<String?> MyCheck() async{
    EasyLoading.show(status: 'Please wait...');
    DocumentReference groupDocRef = await groupCollection.add({
      'Name': nameCont.text,
      'Email': emailCont.text,
      'Phone': phoneCont.text,
      'PlanDate': pickdate! + " " + pickmonth! + "," + pickyear!,
      'Type': 'Customer',
      'Password': passwordCont.text,
      'UserId': '',
      'Website': websiteCont.text,
      'Country': _selectedDialogCountry.name
    });

    await groupDocRef.update({
      'UserId': groupDocRef.id
    });


EasyLoading.dismiss();
    Navigator.pop(context);

  }
  DateTime selectedDate = DateTime.now();

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
      });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);


    Widget _buildDialogItem(Country country) => Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        Text("+${country.phoneCode}",style: TextStyle(color: sh_app_txt_color,fontFamily: 'Bold'),),
        SizedBox(width: 8.0),
        Flexible(child: Text(country.name,style: TextStyle(color: sh_app_txt_color,fontFamily: 'Bold'),))
      ],
    );

    void _openCountryPickerDialog() => showDialog<void>(
      context: context,
      builder: (BuildContext context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
              titlePadding: EdgeInsets.all(8.0),
              searchCursorColor: Colors.pinkAccent,
              searchInputDecoration: InputDecoration(hintText: 'Search...',hintStyle: TextStyle(color: sh_app_txt_color)),
              isSearchable: true,
              title: Text('Select your phone code',style: TextStyle(color: sh_app_txt_color,fontFamily: 'Bold'),),
              onValuePicked: (Country country) =>
                  setState(() =>
                  _selectedDialogCountry = country),
              priorityList: [
                CountryPickerUtils.getCountryByIsoCode('BB'),
                CountryPickerUtils.getCountryByIsoCode('US'),
              ],
              itemBuilder: _buildDialogItem)),
    );

    return Scaffold(
      backgroundColor: sh_white,
      appBar: AppBar(
        elevation: 0,
        title: Text("Add Customers",style: TextStyle(color: sh_app_txt_color,fontSize: 24,fontFamily: 'Bold'),),
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
                            controller: websiteCont,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please Enter Website';
                              }
                              return null;
                            },
                            cursorColor: sh_app_txt_color,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(2, 8, 4, 8),
                              hintText: "Website",
                              hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular'),
                              labelText: "Website",
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
                            child: ListTile(
                              onTap: _openCountryPickerDialog,
                              title: _buildDialogItem(_selectedDialogCountry),
                            ),
                          ),
                          Icon(Icons.arrow_drop_down,color: sh_app_txt_color,)
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
MyCheck();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            top: 6, bottom: 10),
                        decoration: boxDecoration(
                            bgColor: sh_btn_color, radius: 10, showShadow: true),
                        child: text("Add Customer",
                            fontSize: 24.0,
                            textColor: sh_app_txt_color,
                            isCentered: true,
                            fontFamily: 'Bold'),
                      ),
                    ),

                  ],
                )),
          )),
    );
  }
}
