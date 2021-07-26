import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midquest2021/model/FavoritosModel.dart';

import 'main.dart';

class ExibirPerguntas extends StatefulWidget {

  FavoritosModel favoritosModel;
  ExibirPerguntas(this.favoritosModel);

  @override
  _ExibirPerguntasState createState() => _ExibirPerguntasState();
}

class _ExibirPerguntasState extends State<ExibirPerguntas> {

  FavoritosModel _favoritos;
  bool _subindoImagem;
  String _idUsuarioLogado;

  @override
  void initState() {
    super.initState();
    setState(() {
      _subindoImagem == true;
    });
    _favoritos = widget.favoritosModel;
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

    setState(() {
      _subindoImagem == false;
    });
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
      body: Stack(children: <Widget>[
        ListView(children: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child:
                      Text("Pergunta",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25,
                            color: temaPadrao.primaryColor,
                            fontWeight:FontWeight.bold,
                          )
                      )
                  ),
                  GestureDetector(
                      child: _favoritos.urlPergunta !=null
                          ? Image.network(
                        _favoritos.urlPergunta,
                        width: 100,
                        height: 100,
                      ) : Container(
                        child:  Container(),
                      )
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pergunta",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                _favoritos.perguntas,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "Resposta A",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Container(padding: EdgeInsets.only(right: 10),),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                _favoritos.resposta1,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "Resposta B",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Container(padding: EdgeInsets.only(right: 10),),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                _favoritos.resposta2,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "Resposta C",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Container(padding: EdgeInsets.only(right: 10),),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                _favoritos.resposta3,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "Resposta D",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Container(padding: EdgeInsets.only(right: 10),),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                _favoritos.resposta4,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "Resposta E",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Container(padding: EdgeInsets.only(right: 10),),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                _favoritos.resposta5,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "Explicação resposta",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Container(padding: EdgeInsets.only(right: 10),),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text( _favoritos.explicaoResposta != ""?
                                _favoritos.explicaoResposta: "Pergunta sem explicação",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
          )
        ],),
      ],),
    );
  }
}
