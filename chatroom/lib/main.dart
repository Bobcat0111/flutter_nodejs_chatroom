
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mychat/config/app_config.dart';
import 'package:mychat/page/chat_detail_page.dart';
import 'package:mychat/page/login.dart';
import 'package:mychat/util/socket_manager.dart';
import 'dart:ui';

import 'model/user_result.dart';

void main() {
  GetIt.instance.registerSingleton<SocketManager>(SocketManager());
  GetIt.instance.registerSingleton<AppConfig>(AppConfig());
  AppConfig appConfig=GetIt.instance<AppConfig>();
  appConfig.enviroment=Enviroment.PROD;
  if(window.physicalSize.aspectRatio>1){
    appConfig.isBigScreen=true;
  }else{
    appConfig.isBigScreen=false;
  }
  runApp(MyApp());
}

void _setTargetPlatformForDesktop(){
  TargetPlatform targetPlatform;
  if(Platform.isMacOS){
    targetPlatform=TargetPlatform.iOS;
  }else if(Platform.isLinux || Platform.isWindows){
    targetPlatform=TargetPlatform.android;
  }else{
    targetPlatform=TargetPlatform.fuchsia;
  }
  if(targetPlatform!=null){
    debugDefaultTargetPlatformOverride=targetPlatform;
  }
}

class MyApp extends StatelessWidget {



  @override
  void initState(){

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        const Locale('en',''),
        const Locale('zh',''),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: SafeArea(child: LoginPage(title: "login",)),
    );
  }
}

