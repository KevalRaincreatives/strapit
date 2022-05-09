import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/screens/AddTicketScreen.dart';
import 'package:strapit/screens/TicketDetailScreen.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShExtension.dart';

class ManageTicketScreen extends StatefulWidget {
  static String tag='/ManageTicketScreen';
  const ManageTicketScreen({Key? key}) : super(key: key);

  @override
  _ManageTicketScreenState createState() => _ManageTicketScreenState();
}

class _ManageTicketScreenState extends State<ManageTicketScreen> {
  int? IsAdmin=0;

  Stream<QuerySnapshot>? _groups5;
  @override
  void initState() {
    super.initState();
    _getAllGroups();
    // disableCapture();
  }

  _getAllGroups() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getInt('IsAdmin')==1) {
        setState(() {
          _groups5 =
              FirebaseFirestore.instance.collection("Tickets").snapshots();


        });
      }else{
        setState(() {
          _groups5 =
              FirebaseFirestore.instance.collection("Tickets").where('UserId', isEqualTo: prefs.getString('UserId')).snapshots();
        });
      }


    } catch (e) {
      // setState(() {
      //   _error = true;
      // });
    }
  }

  Future<String?> fetchadd() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      IsAdmin = prefs.getInt('IsAdmin');
      return '';
    } catch (e) {
      print('caught error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: sh_white,
      appBar: AppBar(
        elevation: 0,
        title: Text("Manage Tickets",style: TextStyle(color: sh_app_txt_color,fontSize: 24,fontFamily: 'Bold'),),
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actionsIconTheme: IconThemeData(color: sh_white),
        actions: [
          FutureBuilder<String?>(
            future: fetchadd(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(IsAdmin==0) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                      child: Wrap(
                        children: [GestureDetector(
                          onTap: () async {
                            // Navigator.pushNamed(context, AddTicketScreen.tag).then((_) => setState(() {}));
                            launchScreen(context, AddTicketScreen.tag);

                            // CreateOrder(widget.podCastModel2![index].id!, widget.podCastModel2![index].downloadCost!);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: sh_btn_color,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Center(
                                child: Text(
                                  "Add New",
                                  style: TextStyle(
                                    color: sh_app_txt_color,
                                    fontSize: 15,
                                    fontFamily: "Bold",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        ],
                      ),
                    ),
                  );
                }else{
                  return Container();
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),

      ],

      ),
      body: SafeArea(
          child: Container(
              color: sh_white,
              padding: EdgeInsets.all(16),
              child: StreamBuilder<QuerySnapshot>(
                stream: _groups5,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data != null) {
                      // print(snapshot.data['groups'].length);
                      if((snapshot.data! as QuerySnapshot).docs.length != 0) {
                        return  ListView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () async{
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    // launchScreen(context, TicketDetailScreen.tag);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TicketDetailScreen(title: (snapshot.data! as QuerySnapshot).docs[index]["Title"],
                                        userby: (snapshot.data! as QuerySnapshot).docs[index]["GenerateBy"],
                                        datetimes: (snapshot.data! as QuerySnapshot).docs[index]["DateTimeBy"],
                                          TicketId: (snapshot.data! as QuerySnapshot).docs[index]["TicketId"],
                                          userName: prefs.getString('UserName'),
                                        ),
                                      ),
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
                                            padding: EdgeInsets.fromLTRB(16,12,16,12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text((snapshot.data! as QuerySnapshot).docs[index]["Title"],
                                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: sh_app_black)),
                                                    SizedBox(height: 6,),
                                                    Text("Generate by : "+(snapshot.data! as QuerySnapshot).docs[index]["GenerateBy"],style: TextStyle(fontSize: 14,color: sh_app_black)),
                                                    SizedBox(height: 2,),
                                                    Text("Generate At : "+(snapshot.data! as QuerySnapshot).docs[index]["DateTimeBy"],style: TextStyle(fontSize: 14,color: sh_app_black)),

                                                  ],),
                                                Icon(Icons.keyboard_arrow_right,color: sh_app_txt_color,size: 36,)
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
                        )
                        ;
                      }
                      else {
                        return Center(
                          child: Text(
                            'No Data Found',
                            style: TextStyle(
                                fontSize: 20,
                                color: sh_app_black,
                                fontFamily: 'Bold',
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    }
                    else {
                      return Container();
                    }
                  }
                  else {
                    return Center(
                        child: CircularProgressIndicator()
                    );
                  }
                },
              ),
              )),
    );
  }
}
