import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strapit/screens/AddCustomerScreen.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShExtension.dart';


class CustomerListScreen extends StatefulWidget {
  static String tag='/CustomerListScreen';
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  Stream<QuerySnapshot>? _groups5;
  @override
  void initState() {
    super.initState();
    _getAllGroups();
    // disableCapture();
  }

  _getAllGroups() async {
    try {

      setState(() {
        _groups5=FirebaseFirestore.instance.collection("Users").snapshots();

      });


    } catch (e) {
      // setState(() {
      //   _error = true;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;


    Widget groupList() {
      return StreamBuilder<QuerySnapshot>(
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
                          onTap: () {
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text((snapshot.data! as QuerySnapshot).docs[index]["Name"],
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: sh_app_black)),
                                        SizedBox(height: 6,),
                                        Text((snapshot.data! as QuerySnapshot).docs[index]["Email"],style: TextStyle(fontSize: 16,color: sh_app_black)),
                                        SizedBox(height: 2,),
                                        Text((snapshot.data! as QuerySnapshot).docs[index]["Country"],style: TextStyle(fontSize: 16,color: sh_app_black)),
                                        SizedBox(height: 2,),
                                        Text((snapshot.data! as QuerySnapshot).docs[index]["Phone"],style: TextStyle(fontSize: 16,color: sh_app_black)),
                                        SizedBox(height: 2,),
                                        Text((snapshot.data! as QuerySnapshot).docs[index]["Website"],style: TextStyle(fontSize: 16,color: sh_app_black)),
                                        SizedBox(height: 2,),
                                        Text((snapshot.data! as QuerySnapshot).docs[index]["PlanDate"],style: TextStyle(fontSize: 16,color: sh_app_black)),
                                        SizedBox(height: 2,),

                                      ],),
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
                return Container();
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
              padding: const EdgeInsets.fromLTRB(0,0,8.0,0),
              child: Wrap(
                children: [GestureDetector(
                  onTap: () async{
                    // Navigator.pushNamed(context, AddTicketScreen.tag).then((_) => setState(() {}));
                    launchScreen(context, AddCustomerScreen.tag);
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
                )],
              ),
            ),
          )
        ],),
      body: SafeArea(
          child: Container(
              color: sh_white,
              padding: EdgeInsets.all(16),
              child: groupList())),
    );
  }
}
