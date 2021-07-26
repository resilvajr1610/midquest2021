import 'package:flutter/material.dart';
import 'package:midquest2021/telas/questaoTemas.dart';

import 'QuestaoSimulado.dart';
import 'main.dart';

class Testes extends StatefulWidget {

  @override
  _TestesState createState() => _TestesState();
}

class _TestesState extends State<Testes> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16),
        child:SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Text("Simulado",
                    style: TextStyle(fontSize: 25,
                        color: temaPadrao.primaryColor)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 75, bottom: 10),
                child: RaisedButton(
                    child: Text(
                      "Iniciar simulado",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: temaPadrao.primaryColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => QuestaoSimulado()));
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text("São perguntas relacionadas a sua especialidade cadastrada no aplicativo.",
                    style: TextStyle(fontSize: 15,
                        color: temaPadrao.accentColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
