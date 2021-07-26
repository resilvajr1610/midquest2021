import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midquest2021/model/Usuario.dart';
import 'home.dart';
import 'main.dart';

class ResultadosSimulado extends StatefulWidget {
  final int corretas,incorretas,total;

  const ResultadosSimulado({
    @required this.corretas,
    @required this.incorretas,
    @required this.total,
  });

  @override
  _ResultadosSimuladoState createState() => _ResultadosSimuladoState();
}

class _ResultadosSimuladoState extends State<ResultadosSimulado> {

  String _idUsuarioLogado;
  Usuario _usuario = Usuario();
  int _naoRespondidas=0;

  _salvarResultado(int corretas, int incorretas,int naoRespondida){

    int totalErros = incorretas+naoRespondida;

    _usuario = Usuario();
    _usuario.corretas = corretas;
    _usuario.incorretas = totalErros;

    Firestore db = Firestore.instance;
    Map<String,dynamic> dadosAtualizar = {
      "corretas" : corretas,
      "incorretas" : totalErros,
    };
    db.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizar);

    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Home()));

  }

  _recuperarDadosUsuario()async{

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
        .document(_idUsuarioLogado)
        .get();
  }

  @override
  void initState() {
    super.initState();
    _naoRespondidas = widget.total-widget.corretas-widget.incorretas;
    print("não respondidas : " + _naoRespondidas.toString());
    print("total : " + _naoRespondidas.toString());
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
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 10),
              child: Text("Resultado Simulado",
                  style: TextStyle(fontSize: 25,
                      color: temaPadrao.primaryColor,fontWeight:FontWeight.bold)),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20),
              child: Text("Tempo Esgotado!",
                  style: TextStyle(fontSize: 20,
                      color: temaPadrao.accentColor)),
            ),
            SizedBox(height: 24),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 0,bottom: 0),
                    child: Text("Resultados:",
                        style: TextStyle(fontSize: 20,
                            color: temaPadrao.accentColor)),
                  ),
                  Card(
                    color: temaPadrao.secondaryHeaderColor,
                      child: Container(
                        padding: EdgeInsets.only(left: 40,right: 40,top: 20,bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Acertos : ${widget.corretas}",style: TextStyle(
                                color: Colors.green,fontSize: 20),),
                            SizedBox(height: 6),
                            Text("Erros : ${widget.incorretas+_naoRespondidas}",style: TextStyle(
                                color: Colors.red,fontSize: 20)),
                            SizedBox(height: 6),
                          ],
                        ),
                      )
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 16, bottom: 10),
                child: RaisedButton(
                    child: Text(
                      "Voltar para tela inicial",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    color: temaPadrao.primaryColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {
                      _salvarResultado(widget.corretas,widget.incorretas,_naoRespondidas);
                    })
            ),
          ],
        ),
      )
    );
  }
}
