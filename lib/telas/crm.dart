import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:midquest2021/model/Usuario.dart';
import 'package:flutter/services.dart';
import 'package:midquest2021/telas/perfil.dart';
import 'main.dart';
import 'dart:io';

class CRM extends StatefulWidget {

  @override
  _CRMState createState() => _CRMState();
}

class _CRMState extends State<CRM> {

  TextEditingController _controllerCRM = TextEditingController();
  TextEditingController _controllerEspecialidade = TextEditingController();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _mensagemErro = "";
  String _idUsuarioLogado;
  String _urlImagemRecuperadaFrente;
  String _urlImagemRecuperadaVerso;
  bool _subindoImagemFrente = false;
  bool _subindoImagemVerso = false;
  File _imagemFrente;
  File _imagemVerso;
  var valorSelecionado;

  Future _recuperarImagensFrente(String origemImagem)async{

    File imagemSelecionada;
    switch (origemImagem){
      case "galeriaFrente" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagemFrente = imagemSelecionada;
      if(_imagemFrente != null){
        _subindoImagemFrente = true;
        _uploadImagemFrente();
      }
    });
  }
  Future _recuperarImagensVerso(String origemImagem)async{

    File imagemSelecionada;
    switch (origemImagem){
      case "galeriaVerso" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagemVerso = imagemSelecionada;
      if(_imagemVerso != null){
        _subindoImagemVerso = true;
        _uploadImagemVerso();
      }
    });
  }

  Future _uploadImagemFrente()async{
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("crm")
        .child(_idUsuarioLogado + "_crmFrente.jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagemFrente);
    //Controlar o progresso
    task.events.listen((StorageTaskEvent storageEvent) {

      if(storageEvent.type == StorageTaskEventType.progress){
        setState(() {
          _subindoImagemFrente = true;
        });
      }else if(storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _subindoImagemFrente = false;
        });
      }
    });
    //recuperarURLimagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagemFrente(snapshot);
    });
  }

  Future _uploadImagemVerso()async{
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("crm")
        .child(_idUsuarioLogado + "_crmVerso.jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagemVerso);
    //Controlar o progresso
    task.events.listen((StorageTaskEvent storageEvent) {

      if(storageEvent.type == StorageTaskEventType.progress){
        setState(() {
          _subindoImagemVerso = true;
        });
      }else if(storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _subindoImagemVerso = false;
        });
      }
    });
    //recuperarURLimagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagemVerso(snapshot);
    });
  }

  Future _recuperarUrlImagemFrente(StorageTaskSnapshot snapshot)async{

    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestoreFrente(url);

    setState(() {
      _urlImagemRecuperadaFrente = url;
    });
  }

  Future _recuperarUrlImagemVerso(StorageTaskSnapshot snapshot)async{

    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestoreVerso(url);

    setState(() {
      _urlImagemRecuperadaVerso = url;
    });
  }
  _atualizarUrlImagemFirestoreFrente(String url){

    Firestore db = Firestore.instance;
    Map<String,dynamic> dadosAtualizar = {
      "urlCRMFrente" : url
    };

    db.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizar);
  }

  _atualizarUrlImagemFirestoreVerso(String url){

    Firestore db = Firestore.instance;
    Map<String,dynamic> dadosAtualizar = {
      "urlCRMVerso" : url
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

    if(dados["urlCRMFrente"] != null){
      _urlImagemRecuperadaFrente = dados["urlCRMFrente"];
    }

    if(dados["urlCRMVerso"] != null){
      _urlImagemRecuperadaFrente = dados["urlCRMVerso"];
    }
  }

  _validarCampos() {
    //recuperar dados dos campos
    String crm = _controllerCRM.text;
    String especialidade = valorSelecionado;

    if(crm.isNotEmpty){
      if(especialidade.isNotEmpty){
        if(_urlImagemRecuperadaFrente!=null && _urlImagemRecuperadaVerso!=null){
          setState(() {
            _mensagemErro = "";
          });
          Usuario usuario = Usuario();
          usuario.crm = crm;
          usuario.especialidade = especialidade;

          _cadastrarCrm(usuario);
        }else{
          setState(() {
            _mensagemErro = "Coloque as fotos da sua CRM";
          });
        }
      }else{
        setState(() {
          _mensagemErro = "Preencha sua especialidade";
        });
      }

    }else{
      setState(() {
        _mensagemErro = "Preencha seu CRM";
      });
    }
  }

  _cadastrarCrm(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;
    String crm = _controllerCRM.text;
    String especialidade = valorSelecionado;

    //salvar dados do usuario
    Firestore db = Firestore.instance;
    Map<String,dynamic> dadosAtualizar = {
      "crm" : crm,
      "especialidade" : especialidade
    };
    db.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizar);

    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Perfil()));
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerEspecialidades()async{

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("especialidades")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
    _adicionarListenerEspecialidades();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Image.asset(
                    "assets/imagens/logoOficial.png",
                    color: temaPadrao.primaryColor,
                    width: 280,
                    height: 80,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("CRM",
                      style: TextStyle(fontSize: 15,
                          color: temaPadrao.accentColor)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                      controller: _controllerCRM,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                          focusedBorder: InputBorder.none,
                          hintText: "CRM",
                          filled: true,
                          fillColor: temaPadrao.secondaryHeaderColor,
                          enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                              borderSide: BorderSide(color: Colors.white,width: 0))
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Especialidade",
                      style: TextStyle(fontSize: 15,
                          color: temaPadrao.accentColor)),
                ),
                Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: temaPadrao.secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: temaPadrao.secondaryHeaderColor,width: 1,
                      )
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream:_controller.stream,
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                        Text("Carregando");
                      }else {
                        List<DropdownMenuItem> espItems = [];
                        for (int i = 0; i < snapshot.data.documents.length;i++){
                          DocumentSnapshot snap=snapshot.data.documents[i];
                          espItems.add(
                              DropdownMenuItem(
                                child: Text(
                                  snap.documentID,
                                  style: TextStyle(color: temaPadrao.accentColor),
                                ),
                                value: "${snap.documentID}",
                              )
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton(
                              items:espItems,
                              onChanged:(valor){
                                setState(() {
                                  valorSelecionado = valor;
                                });
                              },
                              value: valorSelecionado,
                              isExpanded: false,
                              hint: new Text(
                                "Escolha uma especialidade",
                                style: TextStyle(color: temaPadrao.accentColor ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Container(padding:EdgeInsets.all(8) ,),
                Container(
                  alignment: Alignment.center,
                  child: Text("Adicione aqui foto do seu CRM",
                      style: TextStyle(fontSize: 15,
                          color: temaPadrao.accentColor)),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("frente",style: TextStyle(
                          fontSize: 15, color: temaPadrao.accentColor
                        ),
                        ),
                        padding: EdgeInsets.only(right: 60),
                      ),
                      Container(
                        child: Text("verso",style: TextStyle(
                          fontSize: 15, color: temaPadrao.accentColor),
                        )
                      )
                    ],
                  ),
                ),
                Padding(
                    child: Container(
                      child: SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            //frente
                            GestureDetector(
                              onTap: (){
                                _recuperarImagensFrente("galeriaFrente");
                              },
                              child: _urlImagemRecuperadaFrente != null
                                ? Image.network(
                                _urlImagemRecuperadaFrente,
                                width: 100,
                                height: 100,
                              )
                                : Card(
                                color: temaPadrao.secondaryHeaderColor,
                                child: FlatButton(
                                  padding:EdgeInsets.all(32) ,
                                  child: Icon(Icons.add_photo_alternate,color: temaPadrao.accentColor),
                                  onPressed: (){
                                    _recuperarImagensFrente("galeriaFrente");
                                  },
                                ),
                              ),
                            ),
                            //verso
                            GestureDetector(
                              onTap: (){
                                _recuperarImagensVerso("galeriaVerso");
                              },
                              child: _urlImagemRecuperadaVerso != null
                                  ? Image.network(
                                  _urlImagemRecuperadaVerso,
                                width: 100,
                                height: 100,
                              )
                                  : Card(
                                color: temaPadrao.secondaryHeaderColor,
                                child: FlatButton(
                                  padding:EdgeInsets.all(32) ,
                                  child: Icon(Icons.add_photo_alternate,color: temaPadrao.accentColor),
                                  onPressed: (){
                                    _recuperarImagensVerso("galeriaVerso");
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    padding:EdgeInsets.all(2) ,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Continuar",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      color: temaPadrao.primaryColor,
                      elevation: 5,
                      padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)
                      ),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child:  _subindoImagemFrente
                      ?CircularProgressIndicator()
                      : Container(),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child:  _subindoImagemVerso
                      ?CircularProgressIndicator()
                      : Container(),
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
