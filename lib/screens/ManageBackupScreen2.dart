import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:strapit/utils/ShExtension.dart';

class ManageBackupScreen extends StatefulWidget {
  static String tag = '/ManageBackupScreen';

  const ManageBackupScreen({Key? key}) : super(key: key);

  @override
  _ManageBackupScreenState createState() => _ManageBackupScreenState();
}

class _ManageBackupScreenState extends State<ManageBackupScreen> {
  String? pickdate = '', pickmonth = '', pickyear = '';
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
      body: SafeArea(
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
                  ListView(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Backup Date : 22 March 2022",
                                      style: TextStyle(
                                          color: sh_app_txt_color,
                                          fontSize: 15,
                                          fontFamily: 'Bold'),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Backup Time : 10:14",
                                      style: TextStyle(
                                          color: sh_app_txt_color,
                                          fontSize: 15,
                                          fontFamily: 'Bold'),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: boxDecoration(
                                          bgColor: sh_btn_color,
                                          radius: 6,
                                          showShadow: true),
                                      child: text("Reorder",
                                          fontSize: 15.0,
                                          textColor: sh_app_txt_color,
                                          isCentered: true,
                                          fontFamily: 'Bold'),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: sh_green,
                                  size: 36,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: sh_white,
                            border:
                                Border.all(color: sh_app_black, width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Backup Date : 22 March 2022",
                                      style: TextStyle(
                                          color: sh_app_txt_color,
                                          fontSize: 15,
                                          fontFamily: 'Bold'),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Backup Time : 10:14",
                                      style: TextStyle(
                                          color: sh_app_txt_color,
                                          fontSize: 15,
                                          fontFamily: 'Bold'),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: boxDecoration(
                                          bgColor: sh_btn_color,
                                          radius: 6,
                                          showShadow: true),
                                      child: text("Reorder",
                                          fontSize: 15.0,
                                          textColor: sh_app_txt_color,
                                          isCentered: true,
                                          fontFamily: 'Bold'),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: sh_green,
                                  size: 36,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: sh_white,
                            border:
                                Border.all(color: sh_app_black, width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Backup Date : 22 March 2022",
                                      style: TextStyle(
                                          color: sh_app_txt_color,
                                          fontSize: 15,
                                          fontFamily: 'Bold'),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Backup Time : 10:14",
                                      style: TextStyle(
                                          color: sh_app_txt_color,
                                          fontSize: 15,
                                          fontFamily: 'Bold'),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: boxDecoration(
                                          bgColor: sh_btn_color,
                                          radius: 6,
                                          showShadow: true),
                                      child: text("Reorder",
                                          fontSize: 15.0,
                                          textColor: sh_app_txt_color,
                                          isCentered: true,
                                          fontFamily: 'Bold'),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: sh_green,
                                  size: 36,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: sh_white,
                            border:
                                Border.all(color: sh_app_black, width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Backup Date : 22 March 2022",
                                      style: TextStyle(
                                          color: sh_app_txt_color,
                                          fontSize: 15,
                                          fontFamily: 'Bold'),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Backup Time : 10:14",
                                      style: TextStyle(
                                          color: sh_app_txt_color,
                                          fontSize: 15,
                                          fontFamily: 'Bold'),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: boxDecoration(
                                          bgColor: sh_btn_color,
                                          radius: 6,
                                          showShadow: true),
                                      child: text("Reorder",
                                          fontSize: 15.0,
                                          textColor: sh_app_txt_color,
                                          isCentered: true,
                                          fontFamily: 'Bold'),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: sh_green,
                                  size: 36,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ))),
    );
  }
}
