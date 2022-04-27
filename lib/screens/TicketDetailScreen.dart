import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:strapit/utils/ShColors.dart';
import 'package:strapit/utils/ShConstant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/utils/ShExtension.dart';
import 'package:strapit/utils/message_tile.dart';

class TicketDetailScreen extends StatefulWidget {
  static String tag = '/TicketDetailScreen';
  final String? title;
  final String? userby;
  final String? datetimes;
  final String? TicketId;
  final String? userName;

  const TicketDetailScreen(
      {Key? key,
      required this.title,
      required this.userby,
      required this.datetimes,
      required this.TicketId,
        required this.userName})
      : super(key: key);

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  String userId = '1';
  Stream<QuerySnapshot>? _chats;
  ScrollController _scrollController = new ScrollController();
  TextEditingController messageEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    getChats(widget.TicketId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }

  getChats(String? groupId) async {
    return FirebaseFirestore.instance
        .collection('Tickets')
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  _sendMessage() async{
    if (messageEditingController.text.isNotEmpty) {
      EasyLoading.show(status: 'Sending...');

      DateFormat formatter = DateFormat('MMM dd'); // create a formatter to get months 3 character

      String monthAbbr = formatter.format(DateTime.now()); //

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('kk:mm:ss').format(now);

      String c_dt=formattedDate+" , "+monthAbbr;

      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': c_dt,
      };




      // await DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      FirebaseFirestore.instance
          .collection('Tickets')
          .doc(widget.TicketId)
          .collection('messages')
          .add(chatMessageMap);


      // setState(() {
      //   messageEditingController.text = "";
      // });

      EasyLoading.dismiss();
      setState(() {
        messageEditingController.text = "";
      });

      // for (var i = 0; i < myrr; i++) {



      // print("my_arrays"+arr_tokns.length.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget buildChatMessages(ChatModel message) {
      if (message.id != userId) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                  color: sh_app_black,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: text(message.message,
                      textColor: sh_yellow,
                      fontSize: textSizeMedium,
                      fontFamily: fontMedium)
                  .center()
                  .paddingOnly(left: 8, right: 8, top: 8, bottom: 8),
            ).paddingOnly(left: 16, right: 16, bottom: 16),
          ],
        );
      } else {
        return Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: sh_white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  border: Border.all(color: sh_app_black, width: 1.0)),
              width: MediaQuery.of(context).size.width * 0.75,
              child: text(message.message,
                      textColor: sh_app_txt_color,
                      fontSize: textSizeMedium,
                      maxLine: 3,
                      fontFamily: fontMedium)
                  .paddingAll(8),
            ).paddingOnly(left: 16, right: 16, bottom: 16),
          ],
        );
      }
    }
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: sh_semi_white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Ticket Details",
          style: TextStyle(
              color: sh_app_txt_color, fontSize: 24, fontFamily: 'Bold'),
        ),
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actionsIconTheme: IconThemeData(color: sh_white),
      ),
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: ScrollPhysics(),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 2),
                          child: Text(
                            widget.title!,
                            style: TextStyle(
                                color: sh_app_txt_color,
                                fontSize: 24,
                                fontFamily: 'Bold'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 2.0, 16, 0),
                          child: Row(
                            children: [
                              Text(
                                "Generated By : "+widget.userby!,
                                style: TextStyle(
                                    color: sh_app_txt_color,
                                    fontSize: 14,
                                    fontFamily: 'Regular'),
                              ),
                              Text(" , "+
                                widget.datetimes!,
                                style: TextStyle(
                                    color: sh_app_txt_color,
                                    fontSize: 14,
                                    fontFamily: 'Regular'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4,)

                      ],
                    )
                    ,
                  ),

                  // ListView.builder(
                  //   itemBuilder: (context, i) => buildChatMessages(getMessages()[i]),
                  //   itemCount: getMessages().length,
                  //   shrinkWrap: true,
                  //   padding: EdgeInsets.only(bottom: 60),
                  // ),
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _chats,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if ((snapshot.data! as QuerySnapshot).docs.length == 0) {
                            return Center(
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text(
                                      'No Message Yet',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: sh_textColorSecondary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            Timer(
                              Duration(milliseconds: 100),
                              () => _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent),
                            );
                            return ListView.builder(
                              shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                controller: _scrollController,
                                itemCount: (snapshot.data! as QuerySnapshot)
                                    .docs
                                    .length,
                                itemBuilder: (context, index) {
                                  if (index ==
                                      (snapshot.data! as QuerySnapshot)
                                          .docs
                                          .length -
                                          1) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          child: MessageTile(
                                            message: (snapshot.data!
                                            as QuerySnapshot)
                                                .docs[index]["message"],
                                            sender: (snapshot.data!
                                            as QuerySnapshot)
                                                .docs[index]["sender"],
                                            sentByMe: widget.userName ==
                                                (snapshot.data!
                                                as QuerySnapshot)
                                                    .docs[index]["sender"],
                                            msgTime: ((snapshot.data!
                                            as QuerySnapshot)
                                                .docs[index]["time"])
                                                .toString(),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 150,
                                        )
                                      ],
                                    );
                                  } else {
                                    return MessageTile(
                                      message:
                                      (snapshot.data! as QuerySnapshot)
                                          .docs[index]["message"],
                                      sender:
                                      (snapshot.data! as QuerySnapshot)
                                          .docs[index]["sender"],
                                      sentByMe: widget.userName ==
                                          (snapshot.data! as QuerySnapshot)
                                              .docs[index]["sender"],
                                      msgTime:
                                      ((snapshot.data! as QuerySnapshot)
                                          .docs[index]["time"])
                                          .toString(),
                                    );
                                  }
                                });
                          }
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: width,
                margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(color: sh_white),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: messageEditingController,
                        style: TextStyle(
                            fontSize: textSizeMedium, fontFamily: fontRegular),
                        decoration: InputDecoration(
                          hintText: "Ask me Something",
                          filled: true,
                          fillColor: sh_white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: sh_white, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: sh_white, width: 0.0),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        child: Icon(Icons.arrow_upward,
                            size: 24, color: sh_app_black),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(right: 8, left: 8),
                        decoration: BoxDecoration(
                          color: sh_yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
              ).withShadow(shadowColor: learner_ShadowColor),
            ),
          ],
        ),
      ),
    );
  }
}

List<ChatModel> getMessages() {
  List<ChatModel> list = [];

  ChatModel model1 = ChatModel('1', 'Hello Nimisha');
  ChatModel model2 = ChatModel(
      '1', 'I am Revision Bot, here to help you study your ongoing courses.');
  ChatModel model3 = ChatModel('1',
      'select a course to begin Business Management Cloud Computing Moden Medicine');
  ChatModel model4 = ChatModel('2', 'Modren Medicine');

  list.add(model1);
  list.add(model2);
  list.add(model3);
  list.add(model4);

  return list;
}

class ChatModel {
  String id;
  String message;

  ChatModel(this.id, this.message);
}
