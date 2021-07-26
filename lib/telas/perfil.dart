import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:midquest2021/model/Usuario.dart';
import 'package:midquest2021/telas/login.dart';
import 'package:midquest2021/telas/main.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'home.dart';
import 'package:http/http.dart';

class Perfil extends StatefulWidget {

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  File _imagem;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;
  String _idOneSignalADM;
  String _mensagemErro = "";
  String _tokenId;

  Future _recuperarImagens(String origemImagem)async{

    File imagemSelecionada;
    switch (origemImagem){
      case "camera" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      if(_imagem != null){
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem()async{
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("perfil")
        .child(_idUsuarioLogado + ".jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);
    //Controlar o progresso
    task.events.listen((StorageTaskEvent storageEvent) {

      if(storageEvent.type == StorageTaskEventType.progress){
        setState(() {
          _subindoImagem = true;
        });
      }else if(storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _subindoImagem = false;
        });
      }
    });
    //recuperarURLimagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot)async{

    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _atualizarUrlImagemFirestore(String url){

    Firestore db = Firestore.instance;
    Map<String,dynamic> dadosAtualizar = {
      "urlImagem" : url,
    };

    db.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizar);
  }

  _recuperarDadosUsuario()async{

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
        .document(_idUsuarioLogado)
        .get();

    Map<String,dynamic> dados = snapshot.data;

    if(dados["urlImagem"] != null){
      _urlImagemRecuperada = dados["urlImagem"];
      setState((){});
    }
  }

  _recuperarDadosAdm()async{

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("token")
        .document("token")
        .get();

    Map<String,dynamic> dados = snapshot.data;
    setState(() {
      _idOneSignalADM = dados["idOneSignal"];
      print("token : "+ _idOneSignalADM);
    });
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
    _recuperarDadosAdm();
  }

  _notificacao()async{
    var status = await OneSignal.shared.getDeviceState();
    _tokenId = status.userId;
    sendNotification([_tokenId],"Seja bem-vindo ao MedQuest!","MedQuest");
    sendNotification([_idOneSignalADM],"Novo Usuário Cadastrado!","MedQuestADM");


    Firestore db = Firestore.instance;

    Map<String,dynamic> dadosAtualizar = {
      "tokenId" : _tokenId
    };
    db.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(5),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text("Seu Perfil",
                      style: TextStyle(fontSize: 25,
                          color: temaPadrao.primaryColor,fontWeight:FontWeight.bold)),
                ),
                CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                    _urlImagemRecuperada != null
                        ? NetworkImage(_urlImagemRecuperada)
                        :NetworkImage("assets/imagens/logoOficial.png")
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Câmera"),
                      onPressed: (){
                        _recuperarImagens("camera");
                      },
                    ),
                    FlatButton(
                      child: Text("Galeria"),
                      onPressed: (){
                        _recuperarImagens("galeria");
                      },
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child:  _subindoImagem
                      ?CircularProgressIndicator()
                      : Container(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Finalizar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: temaPadrao.primaryColor,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () async {
                      if(_urlImagemRecuperada!=null){
                        setState(() {
                          _mensagemErro = "";
                        });
                        _notificacao();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home()
                            )
                        );
                      }else{
                        setState(() {
                          _mensagemErro = " coloque sua foto de perfil";
                        });
                      }

                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
