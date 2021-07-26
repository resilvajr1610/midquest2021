import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midquest2021/telas/CadastroPendente.dart';
import 'package:midquest2021/telas/main.dart';
import 'CadastroRejeitado.dart';
import 'package:http/http.dart';

import 'Pagamento.dart';
class Inicio extends StatefulWidget {

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  String _idUsuarioLogado;
  int _corretas;
  int _incorretas;
  int _totalPerguntas;
  String _resultado;
  String _status;
  String _pagamento;

  _recuperarDadosUsuario()async{

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
        .document(_idUsuarioLogado)
        .get();

    Map<String,dynamic> dados = snapshot.data;

    if(dados["pagamento"] != null ){
      setState(() {
        _pagamento = dados["pagamento"];
      });
    }

    if(dados["corretas"] != null){
      _corretas = dados["corretas"];
    }
    if(dados["incorretas"] != null){
      _incorretas = dados["incorretas"];
    }
      _status = dados["status"];
    print(_status);

    if(_status == "pendente"){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CadastroPendente()));
    }
    if(_status == "rejeitado"){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CadastroRejeitado()));
    }
    if(dados["dataVencimento"] == null ){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Pagamento()));
    }
    DateTime dateTime = DateTime.parse(dados["dataVencimento"]);
    if(dateTime.difference(DateTime.now()).inDays <0 ){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Pagamento()));
    }

    print("Dif entre datas : " + dateTime.difference(DateTime.now()).inDays.toString());

    int corretas = _corretas;
    int incorretas = _incorretas;
    _calcular(corretas,incorretas);
  }

  _calcular(int corretas,int incorretas){
    int teste = _corretas + _incorretas;
    double total = _corretas/teste*100;
    var formatador = NumberFormat("#.#","pt_BR");
    _resultado = formatador.format(total);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pagamento != null ?
        GestureDetector(
          onTap: null,
          child: _corretas != null ?
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 30),
                    alignment: Alignment.center,
                    child: Text("Resultado do ultimo simulado :",
                        style: TextStyle(fontSize: 20,
                            color: temaPadrao.accentColor)),
                  ),
                  Card(
                    color: temaPadrao.secondaryHeaderColor,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:<Widget> [
                          Text("Acertos : " + _corretas.toString(),style: TextStyle(
                              color: Colors.green,fontSize: 20),),
                          SizedBox(height: 10),
                          Text("Erros : "+ _incorretas.toString(),style: TextStyle(
                              color: Colors.red,fontSize: 20)),
                          SizedBox(height: 10),
                          Text(_corretas!= 0? "acertos : " + _resultado + " %":
                                                  "acertos : 0% ", style: TextStyle(
                              color: temaPadrao.accentColor,fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ):Container(
            child: Center(
              child: Text("Você ainda não respodeu o simulado!"),
            ),
          ),
        ):Container()
      )
    );
  }
}
