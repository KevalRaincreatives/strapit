import 'package:flutter/material.dart';
import 'package:strapit/utils/ShColors.dart';

class MessageTile extends StatelessWidget {

  final String? message;
  final String? sender;
  final bool? sentByMe;
  dynamic? msgTime;

  MessageTile({this.message, this.sender, this.sentByMe,this.msgTime});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: sentByMe! ? 0 : 24,
        right: sentByMe! ? 24 : 0),
        alignment: sentByMe! ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: sentByMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(sender!.toUpperCase(), textAlign: TextAlign.start, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5)),
            SizedBox(height: 7.0),
            Container(
              margin: sentByMe! ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
              padding: EdgeInsets.only(top: 12, bottom: 12, left: 20, right: 20),
              decoration: BoxDecoration(
              borderRadius: sentByMe! ? BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)
              )
              :
              BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)
              ),
              color: sentByMe! ? sh_app_black : sh_white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text(message!, textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: sentByMe! ?sh_yellow : sh_app_txt_color)),
              ],
            ),
      ),
            SizedBox(height: 2,),
            Text(msgTime!, textAlign: sentByMe! ?TextAlign.end :TextAlign.start, style: TextStyle(fontSize: 13.0, color: Colors.black54)),
          ],
        ),
    );
  }
}