import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:mychat/config/app_config.dart';
import 'package:mychat/model/user_result.dart';
import 'package:mychat/util/socket_manager.dart';

import 'chat_detail_page.dart';

class ChatListPage extends StatefulWidget {
  final String token;
  final int fromUserId;
  final String userName;

  const ChatListPage(this.token, this.fromUserId, this.userName);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<User> userList = [];

  bool isShowRight = false; //是否展示右侧的布局

  late User toUser;

  late SocketManager socketManager;

  //AppConfig appConfig;

  @override
  void initState() {
    getChatList();
    socketManager = GetIt.instance<SocketManager>();
    socketManager.connectWithServer(widget.token).then((bool) {
      if (bool) {
        Fluttertoast.showToast(msg: "Connect to server successfully!");
      } else {
        Fluttertoast.showToast(msg: "Connect to server failed!");
      }
    });
  }

  @override
  void dispose() {
    socketManager.disconnectWithServer();
    super.dispose();
  }

  getChatList() async {
    Dio dio = Dio(BaseOptions(
      baseUrl: GetIt.instance<AppConfig>().apiHost,
      headers: {'Authorization':'Bearer ${widget.token}'}
    ));

    Response<Map<String,dynamic>> response = await dio.get<Map<String,dynamic>>("/chat_list");
    if(response!=null && response.data!=null && response.data!['code']==1){
      List list=response.data!['data'];
      list.forEach((json) {
        setState(() {
          userList.add(User.fromJson(json));
        });

      });
      print(userList.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () => {
              Navigator.of(context).pop('刷新')
            },
          ),
          title: Text('Bobcat Chatroom'),
          centerTitle: true,
        ),

      body: SafeArea(
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    height: 60,
                    padding: EdgeInsets.all(10),
                    child: getChatItem(index),
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 60),
                    child: Divider(
                      color: Colors.black26,
                    ),
                  );
                },
                itemCount: userList.length,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget getChatItem(int index) {
    User user = userList[index];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Fluttertoast.showToast(msg: "show chatdetailPage");
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ChatDetailPage(
            toUser: user,
            token: widget.token,
            fromUserId: widget.fromUserId,
          );
        }));
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Image(
              image: NetworkImage(
                  'https://cdn.jsdelivr.net/gh/flutterchina/website@1.0/images/flutter-mark-square-100.png'),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${user.username}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
