import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midquest2021/model/Usuario.dart';
import 'package:midquest2021/telas/main.dart';
import 'package:midquest2021/telas/questaoTemas.dart';

import 'QuestaoSimulado.dart';

class Temas extends StatefulWidget {

  @override
  _TemasState createState() => _TemasState();
}

class _TemasState extends State<Temas> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  var valorSelecionado;
  String _mensagemErro = "";
  String _idUsuarioLogado;
  String _status;
  String _especialidadeUsuario;
  Usuario _usuario = Usuario();

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
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

    _status = dados["status"];
    _especialidadeUsuario = dados["especialidade"];

    String especialidade = _especialidadeUsuario;
    bool carregando = false;
    //print("espc : " + especialidade);

    _adicionarListenerTemas(especialidade);
  }

  _cadastrarTema(){

    FirebaseAuth auth = FirebaseAuth.instance;
    String tema = valorSelecionado;

    //salvar dados do usuario
    Firestore db = Firestore.instance;
    Map<String,dynamic> dadosAtualizar = {
      "tema" : tema,
    };
    db.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizar);

    Navigator.push(context,MaterialPageRoute(builder: (context) => questaoTemas()));
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerTemas(String especialidade)async{

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("lista"+especialidade)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
    //print("recp : " + especialidade);
  }

  var carregandoDados = Center(
    child: Column(children: <Widget>[
      CircularProgressIndicator()
    ],),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("Temas",
                  style: TextStyle(fontSize: 25,
                      color: temaPadrao.primaryColor)),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 40,bottom: 40),
                child:SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: temaPadrao.secondaryHeaderColor,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: temaPadrao.secondaryHeaderColor,width: 1,
                            )
                        ),
                        child:StreamBuilder<QuerySnapshot>(
                          stream:_controller.stream,
                          builder: (context,snapshot){

                            switch (snapshot.connectionState){
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return carregandoDados;
                                break;
                              case ConnectionState.active:
                              case ConnectionState.done:

                              if(snapshot.hasError)
                                return Text("Erro ao carregar dados!");
                            }

                            List<DropdownMenuItem> espItems = [];
                            for (int i = 0; i < snapshot.data.documents.length;i++){
                              DocumentSnapshot snap=snapshot.data.documents[i];
                              espItems.add(
                                  DropdownMenuItem(
                                    child: Text(
                                      snap.documentID,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: temaPadrao.accentColor,fontSize: 9),
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
                                    "Escolha um tema",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: temaPadrao.accentColor ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 10),
                        child: RaisedButton(
                            child: Text(
                              "Iniciar",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: temaPadrao.primaryColor,
                            elevation: 5,
                            padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)
                            ),
                            onPressed: () {
                              (valorSelecionado !=null)?
                              _cadastrarTema()
                                  :setState(() {
                                _mensagemErro = "Selecione um tema";
                              });
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("São perguntas relacionadas a sua especialidade cadastrada no aplicativo.",
                            style: TextStyle(fontSize: 15,
                                color: temaPadrao.accentColor)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 35),
                        child: Center(
                          child: Text(
                            _mensagemErro,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}
