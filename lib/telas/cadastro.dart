import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midquest2021/model/Usuario.dart';
import 'package:midquest2021/telas/crm.dart';
import 'package:midquest2021/telas/main.dart';

class Cadastro extends StatefulWidget {

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerSobreNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerRepetirSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    //recuperar dados dos campos
    String nome = _controllerNome.text;
    String sobreNome = _controllerSobreNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String repetirSenha = _controllerRepetirSenha.text;

    if(nome.isNotEmpty){
      if(sobreNome.isNotEmpty){
        if (email.isNotEmpty) {
          if (senha.isNotEmpty && senha.length>=6) {
            if(repetirSenha == senha && repetirSenha.isNotEmpty){
              setState(() {
                _mensagemErro = "";
              });
              Usuario usuario = Usuario();
              usuario.nome = nome;
              usuario.sobreNome = sobreNome;
              usuario.email = email;
              usuario.senha = senha;

              _cadastrarUsuario(usuario);
            }else{
              setState(() {
                _mensagemErro = "Senhas não são iguais";
              });
            }
          } else {
            setState(() {
              _mensagemErro = "Preencha uma senha maior que 6 caracteres";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "Preencha seu email";
          });
        }
      }else{
        setState(() {
          _mensagemErro = "Preencha seu sobrenome";
        });
      }

    }else{
      setState(() {
        _mensagemErro = "Preencha seu nome";
      });
    }
  }

  _cadastrarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){

      //salvar dados do usuario
      Firestore db = Firestore.instance;
      db.collection("usuarios")
          .document(firebaseUser.uid)
          .setData(usuario.toMap());

      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CRM()));

    }).catchError((error){
      setState(() {
        _mensagemErro = "Erro ao cadastrar usuario";
      });
    });
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    FirebaseUser usuarioLogado = await auth.currentUser();

    if (usuarioLogado != null) {
    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.all(5),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Image.asset(
                    "assets/imagens/logoOficial.png",
                    color: temaPadrao.primaryColor,
                    width: 280,
                    height: 80,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25,bottom: 4),
                  child: Text("Nome",
                  style: TextStyle(fontSize: 15,
                  color: temaPadrao.accentColor)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                      controller: _controllerNome,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32,5, 32, 5),
                          focusedBorder: InputBorder.none,
                          hintText: "Nome",
                          filled: true,
                          fillColor: temaPadrao.secondaryHeaderColor,
                          enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                              borderSide: BorderSide(color: Colors.white,width: 0))
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25,bottom: 4),
                  child: Text("Sobrenome",
                      style: TextStyle(fontSize: 15,
                          color: temaPadrao.accentColor)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                      controller: _controllerSobreNome,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                          focusedBorder: InputBorder.none,
                          hintText: "Sobrenome",
                          filled: true,
                          fillColor: temaPadrao.secondaryHeaderColor,
                          enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                              borderSide: BorderSide(color: Colors.white,width: 0))
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25,bottom: 4),
                  child: Text("E-mail",
                      style: TextStyle(fontSize: 15,
                          color: temaPadrao.accentColor)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                          focusedBorder: InputBorder.none,
                          hintText: "E-mail",
                          filled: true,
                          fillColor: temaPadrao.secondaryHeaderColor,
                          enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                              borderSide: BorderSide(color: Colors.white,width: 0))
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25,bottom: 4),
                  child: Text("Senha",
                      style: TextStyle(fontSize: 15,
                          color: temaPadrao.accentColor)),
                ),
                TextField(
                    controller: _controllerSenha,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Senha",
                        filled: true,
                        fillColor: temaPadrao.secondaryHeaderColor,
                        enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                            borderSide: BorderSide(color: Colors.white,width: 0))
                    )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.white,height: 0,),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25,bottom: 4),
                  child: Text("Repetir senha",
                      style: TextStyle(fontSize: 15,
                          color: temaPadrao.accentColor)),
                ),
                TextField(
                    controller: _controllerRepetirSenha,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Repetir Senha",
                        filled: true,
                        fillColor: temaPadrao.secondaryHeaderColor,
                        enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                            borderSide: BorderSide(color: Colors.white,width: 0))
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Continuar",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      color: temaPadrao.primaryColor,
                      elevation: 5,
                      padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)
                      ),
                      onPressed: () {

                        _validarCampos();
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

