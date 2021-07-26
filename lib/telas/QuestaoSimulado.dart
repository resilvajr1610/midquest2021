import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midquest2021/model/PerguntaModel.dart';
import 'package:midquest2021/model/Usuario.dart';
import 'ItemSimulado.dart';
import 'ResultadosSimulado.dart';
import 'main.dart';

class QuestaoSimulado extends StatefulWidget {
  @override
  _QuestaoSimuladoState createState() => _QuestaoSimuladoState();
}

int _total = 0;
int _corretas = 0;
int _incorretas = 0;
int _naoRespondidas = 0;
final _controller = StreamController<QuerySnapshot>.broadcast();
String _idUsuarioLogado;
String _temaRecuperado;
String _especialidadeRecuperado;
int _numQuestoes;
int _tempoSimulado;
int _numQuestao=1;
Usuario _usuario = Usuario();
int tempoContagemRegressiva = 0;
String _tempoDisplay = "";
QuerySnapshot _banco;


class _QuestaoSimuladoState extends State<QuestaoSimulado> {

  iniciar(){
    tempoContagemRegressiva = (_tempoSimulado*60);
    Timer.periodic(Duration(
      seconds: 1,
    ), (Timer t){
      if(tempoContagemRegressiva<1 ){
        t.cancel();
        _tempoDisplay = "";
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=> ResultadosSimulado(
              corretas: _corretas,
              incorretas: _incorretas,
              total: _total,
            )
        ));
      }
      else if(tempoContagemRegressiva <60){
        _tempoDisplay = tempoContagemRegressiva.toString();
        tempoContagemRegressiva = tempoContagemRegressiva - 1;
      }else if (tempoContagemRegressiva<3600){
        int m = tempoContagemRegressiva ~/60;
        int s = tempoContagemRegressiva - ( 60 *m);
        _tempoDisplay = m.toString() + ":" + s.toString();
        tempoContagemRegressiva = tempoContagemRegressiva -1;
      } else{
        int h = tempoContagemRegressiva ~/3600;
        int t = tempoContagemRegressiva - (3600 * h);
        int m = t ~/60;
        int s = t - (60 * m);
        _tempoDisplay = h.toString() + ":" + m.toString() + ":" + s.toString();
        tempoContagemRegressiva = tempoContagemRegressiva-1;
      }
    });
  }

  _recuperarSimulado()async{

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("simulado")
        .document("simulado")
        .get();

    Map<String,dynamic> dados = snapshot.data;

    if(dados["questoes"] != null){
      setState(() {
        String valor = dados["questoes"];
        _numQuestoes = int.parse(valor);
        _total = int.parse(valor);
      });
    }

    if(dados["tempo"] != null){
      setState(() {
        String valor = dados["tempo"];
        _tempoSimulado = int.parse(valor);
        iniciar();
      });
    }
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

  if(dados["especialidade"] != null){
  setState(() {
  _especialidadeRecuperado = dados["especialidade"];
  });
  }

  if(dados["tema"] != null){
  setState(() {
  _temaRecuperado = dados["tema"];
  });
  }
  _usuario = Usuario();
  _usuario.tema = _temaRecuperado;
  _usuario.especialidade = _especialidadeRecuperado;
  _adicionarListenerPerguntas(_usuario);
}

  _adicionarListenerPerguntas(Usuario usuario)async{

    Firestore db = Firestore.instance;
    Query query = db.collection("simuladoPergunta");

    if(_usuario.especialidade != null){
      query = query.where("especialidadePergunta",isEqualTo: _usuario.especialidade);
    }
    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados) {
      _banco = dados;
      dados.documents.shuffle();

      if(dados != null){
        setState(() {
          _controller.add(dados);
        });
      }
      //_total = dados.documents.length;
    });
  }
  var carregandoDados = Center(
    child: Column(children: <Widget>[
      Container(child: Text("Carregando perguntas")),
      CircularProgressIndicator()
    ],),
  );

  @override
  void initState() {
    super.initState();
    _total = 0;
    _numQuestoes =0;
    _numQuestao =1;
    _corretas = 0;
    _incorretas = 0;
    _naoRespondidas = 0;
    _recuperarDadosUsuario();
    _adicionarListenerPerguntas(_usuario);
    _recuperarSimulado();
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
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Tempo : " ,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20,
                      color: temaPadrao.accentColor,
                    )
                ),
                _tempoDisplay != null?
                Text(_tempoDisplay,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20,
                      color: temaPadrao.accentColor,
                    )
                ): CircularProgressIndicator(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Especialidade : " ,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20,
                      color: temaPadrao.accentColor,
                    )
                ),
                _especialidadeRecuperado != null?
                Text(_especialidadeRecuperado,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20,
                      color: temaPadrao.accentColor,
                    )
                ): CircularProgressIndicator(),
              ],
            ),
            SizedBox(height:10 ,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Total de perguntas : " ,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20,
                      color: temaPadrao.accentColor,
                    )
                ),
                _especialidadeRecuperado != null?
                Text(_numQuestao.toString()+ " / " + _numQuestoes.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20,
                      color: temaPadrao.accentColor,
                    )
                ): CircularProgressIndicator(),
              ],
            ),
            SizedBox(height:10 ,),
            Expanded(
              child: StreamBuilder(
                stream: _controller.stream,
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

                      QuerySnapshot querySnapshot = snapshot.data;
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: querySnapshot.documents.length = 1,
                          itemBuilder: (context,indice){

                            List<DocumentSnapshot> perguntas = querySnapshot.documents.toList();
                            DocumentSnapshot documentSnapshot = perguntas[indice];
                            PerguntaModel perguntamodel = PerguntaModel.fromDocumentSnapshot(documentSnapshot);

                            return QuizPlayTile(
                              perguntaModel: perguntamodel,
                              index: indice,
                            );
                          }
                      );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: temaPadrao.primaryColor,
        child: Icon(Icons.check),
        onPressed: (){
          _numQuestao < _numQuestoes?
          _adicionarListenerPerguntas(_usuario):
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=> ResultadosSimulado(
                corretas: _corretas,
                incorretas: _incorretas,
                total: _numQuestoes,
              )
          ));
        },
      ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {

  final PerguntaModel perguntaModel;
  final int index;

  const QuizPlayTile({this.perguntaModel, this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {

  String opcaoSelecionada = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      child: widget.perguntaModel.urlPergunta !=null
                          ? Image.network(
                        widget.perguntaModel.urlPergunta,
                        width: 100,
                        height: 100,
                      ) : Container(
                        child:  Container(),
                      )
                  ),
                  SizedBox(height:10 ,),
                  Text("${widget.perguntaModel.perguntas}",style: TextStyle(
                      color: temaPadrao.accentColor,fontSize: 20,
                      fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,),
                  SizedBox(height: 12,),
                  GestureDetector(
                    onTap: (){
                      if(!widget.perguntaModel.respondida){
                        if(widget.perguntaModel.resposta1 == widget.perguntaModel.respostaCorreta){
                          opcaoSelecionada = widget.perguntaModel.resposta1;
                          widget.perguntaModel.respondida = true;
                          _corretas = _corretas + 1;
                          _naoRespondidas = _naoRespondidas -1;
                          setState(() {
                            _numQuestao = _numQuestao + 1;
                            widget.perguntaModel.resposta1;
                          });
                        }else{
                          opcaoSelecionada = widget.perguntaModel.resposta1;
                          widget.perguntaModel.respondida = true;
                          _incorretas = _incorretas +1;
                          _naoRespondidas = _naoRespondidas -1;
                          setState(() {
                            _numQuestao = _numQuestao + 1;
                            widget.perguntaModel.resposta1;
                          });
                        }
                      }
                    },
                    child: ItemSimulado(
                      respostaCorreta: widget.perguntaModel.respostaCorreta,
                      descricao: widget.perguntaModel.resposta1,
                      opcao: "A",
                      opcaoSelecionada: opcaoSelecionada,
                    ),
                  ),
                  SizedBox(height: 4,),
                  GestureDetector(
                    onTap: (){
                      if(!widget.perguntaModel.respondida){
                        if(widget.perguntaModel.resposta2 == widget.perguntaModel.respostaCorreta){
                          opcaoSelecionada = widget.perguntaModel.resposta2;
                          widget.perguntaModel.respondida = true;
                          _corretas = _corretas + 1;
                          _naoRespondidas = _naoRespondidas -1;
                          setState(() {
                            _numQuestao = _numQuestao + 1;
                            widget.perguntaModel.resposta2;
                          });
                        }else{
                          opcaoSelecionada = widget.perguntaModel.resposta2;
                          widget.perguntaModel.respondida = true;
                          _incorretas = _incorretas +1;
                          _naoRespondidas = _naoRespondidas -1;
                          setState(() {
                            _numQuestao = _numQuestao + 1;
                            widget.perguntaModel.resposta2;
                          });
                        }
                      }
                    },
                    child: ItemSimulado(
                      respostaCorreta: widget.perguntaModel.respostaCorreta,
                      descricao: widget.perguntaModel.resposta2,
                      opcao: "B",
                      opcaoSelecionada: opcaoSelecionada,
                    ),
                  ),
                  SizedBox(height: 4,),
                  GestureDetector(
                    onTap: (){
                      if(!widget.perguntaModel.respondida){
                        if(widget.perguntaModel.resposta3 == widget.perguntaModel.respostaCorreta){
                          opcaoSelecionada = widget.perguntaModel.resposta3;
                          widget.perguntaModel.respondida = true;
                          _corretas = _corretas + 1;
                          _naoRespondidas = _naoRespondidas -1;
                          setState(() {
                            _numQuestao = _numQuestao + 1;
                            widget.perguntaModel.resposta3;
                          });
                        }else{
                          opcaoSelecionada = widget.perguntaModel.resposta3;
                          widget.perguntaModel.respondida = true;
                          _incorretas = _incorretas +1;
                          _naoRespondidas = _naoRespondidas -1;
                          setState(() {
                            _numQuestao = _numQuestao + 1;
                            widget.perguntaModel.resposta3;
                          });
                        }
                      }
                    },
                    child: ItemSimulado(
                      respostaCorreta: widget.perguntaModel.respostaCorreta,
                      descricao: widget.perguntaModel.resposta3,
                      opcao: "C",
                      opcaoSelecionada: opcaoSelecionada,
                    ),
                  ),
                  SizedBox(height: 4,),
                  GestureDetector(
                    onTap: (){
                      if(!widget.perguntaModel.respondida){
                        if(widget.perguntaModel.resposta4 == widget.perguntaModel.respostaCorreta){
                          opcaoSelecionada = widget.perguntaModel.resposta4;
                          widget.perguntaModel.respondida = true;
                          _corretas = _corretas + 1;
                          _naoRespondidas = _naoRespondidas -1;
                          setState(() {
                            _numQuestao = _numQuestao + 1;
                            widget.perguntaModel.resposta4;
                          });
                        }else{
                          opcaoSelecionada = widget.perguntaModel.resposta4;
                          widget.perguntaModel.respondida = true;
                          _incorretas = _incorretas +1;
                          _naoRespondidas = _naoRespondidas -1;
                          setState(() {
                            _numQuestao = _numQuestao + 1;
                            widget.perguntaModel.resposta4;
                          });
                        }
                      }
                    },
                    child: ItemSimulado(
                      respostaCorreta: widget.perguntaModel.respostaCorreta,
                      descricao: widget.perguntaModel.resposta4,
                      opcao: "D",
                      opcaoSelecionada: opcaoSelecionada,
                    ),
                  ),
                  SizedBox(height: 4,),
                  GestureDetector(
                    onTap: (){
                      if(!widget.perguntaModel.respondida){
                        if(widget.perguntaModel.resposta5 == widget.perguntaModel.respostaCorreta){
                          opcaoSelecionada = widget.perguntaModel.resposta5;
                          widget.perguntaModel.respondida = true;
                          _corretas = _corretas + 1;
                          _naoRespondidas = _naoRespondidas -1;
                          setState(() {
                            _numQuestao = _numQuestao + 1;
                            widget.perguntaModel.resposta5;
                          });
                        }else{
                          opcaoSelecionada = widget.perguntaModel.resposta5;
                          widget.perguntaModel.respondida = true;
                          _incorretas = _incorretas +1;
                          _naoRespondidas = _naoRespondidas -1;
                          setState(() {
                            _numQuestao = _numQuestao + 1;
                            widget.perguntaModel.resposta5;
                          });
                        }
                      }
                    },
                    child: ItemSimulado(
                      respostaCorreta: widget.perguntaModel.respostaCorreta,
                      descricao: widget.perguntaModel.resposta5,
                      opcao: "E",
                      opcaoSelecionada: opcaoSelecionada,
                    ),
                  ),
                  SizedBox(height:10 ,),
                ],
              ),
            )
          )
      )
    );
  }
}

