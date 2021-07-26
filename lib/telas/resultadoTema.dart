import 'package:flutter/material.dart';
import 'home.dart';
import 'main.dart';

class resultadoTema extends StatefulWidget {
  final int corretas,incorretas,total;

  const resultadoTema({@required this.corretas,@required this.incorretas,@required this.total});

  @override
  _resultadoTemaState createState() => _resultadoTemaState();
}

class _resultadoTemaState extends State<resultadoTema> {
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
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 40),
              child: Text("Resultado Tema",
                  style: TextStyle(fontSize: 25,
                      color: temaPadrao.primaryColor,fontWeight:FontWeight.bold)),
            ),
            Container(
              height: MediaQuery.of(context).size.height/1.5,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Text("Total ${widget.corretas}/${widget.total}",style: TextStyle(fontSize: 25,color: temaPadrao.accentColor),),
                    SizedBox(height: 8),
                    Text("Acertos ${widget.corretas}",style: TextStyle(
                        color: Colors.green,fontWeight: FontWeight.bold,fontSize: 30),),
                    Text("Erros ${widget.incorretas}",style: TextStyle(
                        color: Colors.red,fontWeight: FontWeight.bold,fontSize: 30)),
                    SizedBox(height: 40),
                    Padding(
                        padding: EdgeInsets.only(top: 26, bottom: 20),
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
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Home()));
                            })
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
