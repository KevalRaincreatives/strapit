import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';

class AddTicketScreen extends StatefulWidget {
  static String tag='/AddTicketScreen';
  const AddTicketScreen({Key? key}) : super(key: key);

  @override
  _AddTicketScreenState createState() => _AddTicketScreenState();
}

class _AddTicketScreenState extends State<AddTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  var oldpasswordCont = TextEditingController();
  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection('Tickets');

  Future<String?> AddTicket() async{
    EasyLoading.show(status: 'Please wait...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('UserId', "");

    DateFormat formatter = DateFormat('MMM dd'); // create a formatter to get months 3 character

    String monthAbbr = formatter.format(DateTime.now()); //

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm').format(now);

    String c_dt=formattedDate+" , "+monthAbbr;

    DocumentReference groupDocRef = await groupCollection.add({
      'Title': oldpasswordCont.text,
      'GenerateBy': prefs.getString('UserName'),
      'GenerateByEmail': prefs.getString('UserEmail'),
      'DateTimeBy': c_dt,
      'UserId':prefs.getString('UserId'),
      'AdminUserId':'m6SOpds2ZxPKMLiDQj7f'
    });

    await groupDocRef.update({
      'TicketId': groupDocRef.id
    });

    EasyLoading.dismiss();
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: sh_white,
      appBar: AppBar(
        elevation: 0,
        title: Text("Add Ticket",style: TextStyle(color: sh_app_txt_color,fontSize: 24,fontFamily: 'Bold'),),
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actionsIconTheme: IconThemeData(color: sh_white),
      ),
      body: SafeArea(
          child: Container(
              color: sh_white,
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: spacing_standard_new),
                                Container(
                                  child: TextFormField(
                                    autofocus: false,
                                    maxLines: 6,
                                    style: TextStyle(
                                      color: sh_app_txt_color,
                                      fontSize: textSizeMedium,
                                      fontFamily: "Regular",
                                      fontWeight: FontWeight.w600,
                                    ),
                                    controller: oldpasswordCont,
                                    cursorColor: sh_app_txt_color,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please Enter Title';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      // fillColor: sh_editText_background,
                                      focusColor:
                                      sh_app_txt_color,
                                      hintText: "Add Request",
                                      hintStyle: TextStyle(color: sh_app_txt_color,fontFamily: 'Regular',fontSize: textSizeMedium),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(2.0),
                                          borderSide: BorderSide(
                                              color: sh_app_black,
                                              width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(2.0),
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              style: BorderStyle.none,
                                              width: 0)),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // launchScreen(context, DashboardScreen.tag);
                                    if (_formKey.currentState!.validate()) {
                                      // TODO submit
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      // ChangePassword();
                                      AddTicket();

                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                        top: 6, bottom: 10),
                                    decoration: boxDecoration(
                                        bgColor: sh_btn_color, radius: 10, showShadow: true),
                                    child: text("Add Ticket",
                                        fontSize: 24.0,
                                        textColor: sh_app_txt_color,
                                        isCentered: true,
                                        fontFamily: 'Bold'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            )
                          ],
                        ),
                      ),
                    )),
              ))),
    );
  }
}
