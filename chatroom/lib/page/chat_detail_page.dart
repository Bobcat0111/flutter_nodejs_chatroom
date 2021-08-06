import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mychat/model/message_result.dart';
import 'package:mychat/model/user_result.dart';
import 'package:mychat/util/socket_manager.dart';
import 'package:mychat/widget/message_item.dart';

class ChatDetailPage extends StatefulWidget {
  String token;
  int fromUserId; //自己的id
  User toUser; //想聊天的对象

  ChatDetailPage(
      {required this.token, required this.fromUserId, required this.toUser});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  String text = "";

  TextEditingController inputController = TextEditingController(text: "");
  ScrollController scrollController = new ScrollController();

  List<Message> messageList = [];
  late onReceiveMessage listener;

  @override
  void initState(){
    print("chat detail page initstate");

     listener=(Map<String,dynamic> json){
       if(mounted){
         setState(() {
           print("messagelist增加一条信息");
           Message newMessage=Message.fromJson(json);
           if(newMessage.fromUserId==widget.fromUserId || newMessage.toUserId==widget.fromUserId){
             messageList.add(newMessage);
           }
         });
         Future.delayed(Duration(milliseconds: 50),(){
           scrollController.jumpTo(scrollController.position.maxScrollExtent);
         });
       }
     };

    GetIt.instance<SocketManager>().addListener(listener);
    getChatHistory();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdataWidget(ChatDetailPage oldWidget){
    print("didUpdataWidget");
    GetIt.instance<SocketManager>().addListener(listener);
    getChatHistory();
  }

  @override
  void dispose() {
    //移除监听
    GetIt.instance<SocketManager>().removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("ChatDetailPage build");
    var appbar=widget.toUser==null?null:AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      title: Text("${widget.toUser.username}"),
      centerTitle: false,
    );

    var inputLayout=Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Expanded(
        child: TextFormField(
          controller: inputController,
          onFieldSubmitted: (text){
            sendMessage();
          },
        ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.blue,
          ),
          onPressed: () {
            sendMessage();
          },
          child: Text('Send'),
        )
      ],
    );

    return Scaffold(
      appBar: appbar,
      body: Container(
        color: Color(0xffF3F3F3),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 8,
              child: CupertinoScrollbar(
                child: ListView.builder(
                  controller: scrollController,
                    itemCount: messageList.length,
                    itemBuilder: (context,index){
                    return MessageItem(messageList[index]);
                    }
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),
            inputLayout
          ],
        ),
      ),
    );

  }

  void getChatHistory() async {
    if(widget.token.isNotEmpty == false || widget.toUser ==null ){
      return;
    }


    Dio dio=Dio(BaseOptions(
      baseUrl: "https://bobcat-chatserver.herokuapp.com",
      headers: {'Authorization':'Bearer ${widget.token}'}
    ));

    Response<Map<String,dynamic>> response=await dio.get<Map<String,dynamic>>(
      "/message",
      queryParameters: {
        'fromId':widget.fromUserId,
        'toId':widget.toUser.id,
      },
    );
    if(response !=null && response.data !=null && response.data!['code']==1){
      var result=response.data!['data'];
      messageList.clear();
      result?.forEach((json){
        print(json);
        messageList.add(Message.fromJson(json));
      });
    }

    setState(() {

    });

    Future.delayed(Duration(milliseconds: 50),(){
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });

  }

  void sendMessage() {
    Map<String,dynamic> data={
      'toUserId':widget.toUser.id,
      'msg_content':inputController.text.toString(),
      'msg_type':1,
    };

    GetIt.instance<SocketManager>().sendMessage(data);

    inputController.clear();
    debugPrint("send to server: ${data}");

  }

}