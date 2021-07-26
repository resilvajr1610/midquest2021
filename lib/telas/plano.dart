import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midquest2021/telas/main.dart';

class Plano extends StatefulWidget {

  @override
  _PlanoState createState() => _PlanoState();
}

class _PlanoState extends State<Plano> {

  int selecionadoRadio=0;
  int _val = 0;

    setSelecionadoRadio(int valor){
    setState(() {
      selecionadoRadio = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: temaPadrao.primaryColor,
        title: Image.asset(
          "assets/imagens/logoOficial.png",
          alignment: Alignment.center,
          width: 450,
          height: 150,
        ),
      ),
      body: GestureDetector(
        onTap: null,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Planos",
                      style: TextStyle(fontSize: 25,
                          color: temaPadrao.primaryColor)),
                ),
                Card(
                  color: temaPadrao.secondaryHeaderColor,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(children:<Widget> [
                      RadioListTile(
                          value: 1,
                          autofocus: true,
                          groupValue: selecionadoRadio,
                          title: Text("Mensal",style: TextStyle(color: temaPadrao.primaryColor,fontSize: 25),),
                          activeColor: temaPadrao.primaryColor,
                          selected: true,
                          onChanged: (val){
                            setSelecionadoRadio(_val);
                          }),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: temaPadrao.secondaryHeaderColor,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(children:<Widget> [
                      RadioListTile(
                          value: 2,
                          groupValue: selecionadoRadio,
                          title: Text("Trimestral",style: TextStyle(color: temaPadrao.primaryColor,fontSize: 25)),
                          activeColor: temaPadrao.primaryColor,
                          selected: true,
                          onChanged: (val){
                            setSelecionadoRadio(_val);
                          }),
                    ],
                    ),
                  ),
                ),
                Card(
                  color: temaPadrao.secondaryHeaderColor,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(children:<Widget> [
                      RadioListTile(
                          value: 3,
                          groupValue: selecionadoRadio,
                          title: Text("Anual",style: TextStyle(color: temaPadrao.primaryColor,fontSize: 25)),
                          activeColor: temaPadrao.primaryColor,
                          selected: true,
                          onChanged: (val){
                            setSelecionadoRadio(_val);
                          }),
                    ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
