import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychat/model/message_result.dart';

class MessageItem extends StatelessWidget{
  final Message message;
  MessageItem(this.message);
  @override
  Widget build(BuildContext context){
    Widget messageWidget;

    if(message.selfUser){
      print("self");
      messageWidget=MineMessageItem(message);
    }else{
      print("other");
      messageWidget=OtherMessageItem(message);
    }
    return Column(
      children: [
        messageWidget
      ],
    );
  }
}

class MineMessageItem extends StatelessWidget{
  final Message message;
  MineMessageItem(this.message);
  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  color: Color(0xff9FE658),
                  child: Text(message.content),
                )
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Image(
              width: 35,
                height: 35,
              image: NetworkImage("https://cdn.jsdelivr.net/gh/flutterchina/website@1.0/images/flutter-mark-square-100.png"),
            ),
          ),
        ],
      ),
    );
  }
}


class OtherMessageItem extends StatelessWidget{
  final Message message;
  OtherMessageItem(this.message);
  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Image(
              width: 35,
              height: 35,
              image: NetworkImage("https://cdn.jsdelivr.net/gh/flutterchina/website@1.0/images/flutter-mark-square-100.png"),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("username"),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    color: Colors.white,
                    child: Text(message.content),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }
}