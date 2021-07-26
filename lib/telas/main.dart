import 'package:flutter/material.dart';
import 'package:midquest2021/model/RouteGenerator.dart';
import 'package:midquest2021/telas/perfil.dart';
import 'package:midquest2021/telas/splash.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final ThemeData temaPadrao = ThemeData(
    primaryColor:Color(0xff61aef5),
    secondaryHeaderColor: Color(0xffF1F5F4),
    accentColor:Color(0xff748d9b),
);

void main() {
      runApp(MaterialApp(
      theme: temaPadrao,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute:RouteGenerator.generateRoute,
      home: Splash(),
      //0xff61aef5
      //0xffa0a0a0
      //0xff748d9b
      //0xfff1f5f4
    ));
    OneSignal.shared.setAppId('f7a2d074-1661-4b62-8956-4dc0d5d052e2');
}