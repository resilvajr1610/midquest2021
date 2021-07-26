import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midquest2021/model/RouteGenerator.dart';
import 'package:midquest2021/telas/favoritos.dart';
import 'package:midquest2021/telas/inicio.dart';
import 'package:midquest2021/telas/main.dart';
import 'package:midquest2021/telas/perfil.dart';
import 'package:midquest2021/telas/temas.dart';
import 'package:midquest2021/telas/testes.dart';
import 'login.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> itensMenu = ["Sair"];
  int _indiceAtual = 0;
  //String resultado = "";
  String _emailUsuario = "";

  _escolhaMenuItem(String itemEscolhido){

    switch (itemEscolhido){
      case "Sair":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login()
        )
    );
  }

  Future _recuperarDadosUsuario()async{

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();

    setState(() {
      _emailUsuario = usuarioLogado.email;
    });
  }

  Future _verificarUsuarioLogado()async{

    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseUser usuarioLogado = await auth.currentUser();

    if(usuarioLogado ==null){
      Navigator.pushReplacementNamed(context, RouteGenerator.ROTA_LOGIN);
    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    _recuperarDadosUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> telas = [
      Inicio(),
      Temas(),
      Testes(),
      Favoritos(),
      Perfil()
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: temaPadrao.primaryColor,
        title: Image.asset(
          "assets/imagens/logoOficial.png",
          alignment: Alignment.center,
          width: 450,
          height: 150,
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
              icon: Icon(Icons.view_headline,color: Colors.white),
              onSelected: _escolhaMenuItem,
              itemBuilder: (context){
                return itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                      value: item,
                      child: Text(item));
                }).toList();
              }
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: telas[_indiceAtual],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (indice){
          setState(() {
            _indiceAtual = indice;
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: temaPadrao.primaryColor,
        items: [
          BottomNavigationBarItem(
            //backgroundColor: Colors.orange,
              title: Text("Home"),
              icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
            //backgroundColor: Colors.red,
              title: Text("Temas"),
              icon: Icon(Icons.how_to_reg_sharp)
          ),
          BottomNavigationBarItem(
            //backgroundColor: Colors.blue,
              title: Text("Simulado"),
              icon: Icon(Icons.assignment_outlined)
          ),
          BottomNavigationBarItem(
            //backgroundColor: Colors.green,
              title: Text("Favoritos"),
              icon: Icon(Icons.star)
          ),
          BottomNavigationBarItem(
            //backgroundColor: Colors.green,
              title: Text("Perfil"),
              icon: Icon(Icons.person)
          ),
        ],
      ),
    );
  }
}
