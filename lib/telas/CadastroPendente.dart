import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'login.dart';
import 'main.dart';
import 'package:http/http.dart';

class CadastroPendente extends StatefulWidget {
  @override
  _CadastroPendenteState createState() => _CadastroPendenteState();
}

class _CadastroPendenteState extends State<CadastroPendente> {
  String _idUsuarioLogado;


  _recuperarDadosUsuario()async{

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
        .document(_idUsuarioLogado)
        .get();

    Map<String,dynamic> dados = snapshot.data;
    String token = dados["tokenId"];
    String status = dados["status"];
    String nome = dados["nome"];
    String sobre = dados["sobreNome"];

    if(token !=null){
      switch (status){
        case "liberado":
          var status = await OneSignal.shared.getDeviceState();
          String tokenId = status.userId;
          setState(() {
            sendNotification([tokenId],"MedQuest",nome +" "+sobre+" seu cadastro foi liberado");
          });
          break;
        case "rejeitado":
          var status = await OneSignal.shared.getDeviceState();
          String tokenId = status.emailAddress;
          setState(() {
            sendNotification([tokenId],nome +" "+sobre+" seu cadastro foi rejeitado","MedQuest");
          });
          break;
      }
    }
  }
  Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading) async{

    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>
      {
        "app_id": "f7a2d074-1661-4b62-8956-4dc0d5d052e2",//kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList,//tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color":"0xff61aef5",

        "small_icon":"https://firebasestorage.googleapis.com/v0/b/medquest-81996.appspot.com/o/logo%2FlogoOficial1.png?alt=media&token=8ee9bad8-8c33-4c33-b8b5-94741cba2c9a",

        "large_icon":"https://firebasestorage.googleapis.com/v0/b/medquest-81996.appspot.com/o/logo%2FlogoOficial1.png?alt=media&token=8ee9bad8-8c33-4c33-b8b5-94741cba2c9a",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        backgroundColor: temaPadrao.primaryColor,
        title: Image.asset(
          "assets/imagens/logoOficial.png",
          alignment: Alignment.center,
          width: 450,
          height: 150,
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Seu Cadastrado está sendo analisado!",
                style: TextStyle(color: temaPadrao.accentColor,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
              Image.asset(
                "assets/imagens/logoOficial.png",
                alignment: Alignment.center,
                color: temaPadrao.primaryColor,
                width: 450,
                height: 150,
              ),
              GestureDetector(
                onTap: (){
                  FirebaseAuth auth = FirebaseAuth.instance;
                  auth.signOut();
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text("Sair",style: TextStyle(fontSize:20,color: temaPadrao.primaryColor),)
              )
            ],
          )
        ),
      ),
    );
  }
}
