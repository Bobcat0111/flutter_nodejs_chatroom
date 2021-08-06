import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:mychat/config/app_config.dart';
import 'package:mychat/page/chat_list_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username_controller = TextEditingController(text: "");
  TextEditingController password_controller = TextEditingController(text: "");
  var token;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                      "images/cat1.png",
                    width: 250,
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 10),
                  child: new TextFormField(
                    controller: username_controller,
                    decoration: new InputDecoration(
                      //   icon: new Icon(FontAwesomeIcons.user, color: Colors.black,),
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    style: new TextStyle(fontSize: 16, color: Colors.black),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Tag can not be empty";
                      }

                      return null;
                    },
                    onSaved: (value) {

                    },

                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 10),
                  child: new TextFormField(
                    controller: password_controller,
                    decoration: new InputDecoration(
                      //   icon: new Icon(FontAwesomeIcons.user, color: Colors.black,),
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    style: new TextStyle(fontSize: 16, color: Colors.black),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Tag can not be empty";
                      }

                      return null;
                    },
                    onSaved: (value) {

                    },

                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new InkWell(
                      child: new Container(
                        width: 130,
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 13, bottom: 13),
                        decoration: new BoxDecoration(
                         // color: Colors.cyanAccent[100],
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                         // border: new Border.all(color: Colors.lightBlue,width: 1),
                          gradient: Theme1.primaryGradient,
                        ),
                        child: Center(
                          child: new Text(
                            "Login",
                            style: new TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () {
                        login();
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    new InkWell(
                      child: new Container(
                        width: 130,
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 13, bottom: 13),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                         // border: new Border.all(color: Colors.black45,width: 1),
                          gradient: Theme1.primaryGradient,
                        ),
                        child: Center(
                          child: new Text(
                            "Register",
                            style: new TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () {
                        register();
                      },
                    ),
                  ],
                ),

              ],
            ),
          ),
        )
    );
  }

  void login() async{
    Dio dio=Dio(BaseOptions(baseUrl: GetIt.instance<AppConfig>().apiHost));
    dio.options.headers['content-Type'] = 'application/json';

    var response=await dio.post(
      "/login",
      //data: formData
      data: {
        'username':username_controller.text.toString(),
        'pass':password_controller.text.toString(),
      },
    );

    print("result: "+response.statusCode.toString());
    if(response != null && response.data !=null && response.statusCode==200 && response.data['data']['token']!=null){
      print(response.data['data']['token']);
      token=response.data['data']['token'];
      int fromUserId=response.data['data']['userId'];
      String userName=response.data['data']['userName'];

      Fluttertoast.showToast(msg: response.data['msg']);
      Navigator.of(context).push(MaterialPageRoute(builder: (context){
        return ChatListPage(token, fromUserId, userName);
      }));
    }else{
      Fluttertoast.showToast(msg: "Register Failed");
    }

  }
  void register() async{
    print("register");
    Dio dio=Dio(BaseOptions(baseUrl: GetIt.instance<AppConfig>().apiHost));
    dio.options.headers['content-Type'] = 'application/json';

    var response=await dio.post(
      "/register",
      //data: formData
      data: {
        'username':username_controller.text.toString(),
        'pass':password_controller.text.toString(),
      },
    );

    print("result: "+response.statusCode.toString());
    if(response != null && response.data !=null && response.statusCode==200){
      print(response.data['data']);
      Fluttertoast.showToast(msg: response.data['msg']);
    }else{
      Fluttertoast.showToast(msg: "Register Failed");
    }

  }

}

class Theme1 {
  /**
   * 登录界面，定义渐变的颜色
   */
  static const Color loginGradientStart = const Color(0xFF80D8FF);
  static const Color loginGradientEnd = const Color(0xFF40C4FF);

  static const LinearGradient primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}