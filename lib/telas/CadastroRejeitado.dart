import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'main.dart';

class CadastroRejeitado extends StatefulWidget {
  @override
  _CadastroRejeitadoState createState() => _CadastroRejeitadoState();
}

class _CadastroRejeitadoState extends State<CadastroRejeitado> {

  Future<bool> _mockCheckForSession()async{
    await Future.delayed(Duration(milliseconds: 5000),(){});

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    return true;
  }

  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then(
            (status) {

          if(status){

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: ( BuildContext context) => Login()
                )
            );
          }
        }
    );
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
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Seu Cadastrado foi rejeitado!",
                  style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20,),
                CircularProgressIndicator()
              ],
            )
        ),
      ),
    );
  }
}
