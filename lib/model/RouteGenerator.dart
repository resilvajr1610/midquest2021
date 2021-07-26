import 'package:flutter/material.dart';
import 'package:midquest2021/telas/ExibirPerguntas.dart';
import 'package:midquest2021/telas/cadastro.dart';
import 'package:midquest2021/telas/home.dart';
import 'package:midquest2021/telas/login.dart';
import 'package:midquest2021/telas/questaoTemas.dart';

class RouteGenerator{

  static const String ROTA_HOME = "/home";
  static const String ROTA_LOGIN = "/login";
  static const String ROTA_CADASTRO = "/cadastro";
  static const String ROTA_CONFIGURACOES = "/configuracoes";
  static const String ROTA_MENSAGENS = "/mensagens";
  static const String QUESTAO_TEMAS = "/questoes";


  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name){
      case "/" :
        return MaterialPageRoute(
          builder: (_) => Login()
        );
        case ROTA_LOGIN :
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case ROTA_CADASTRO :
        return MaterialPageRoute(
            builder: (_) => Cadastro()
        );
      case QUESTAO_TEMAS :
        return MaterialPageRoute(
            builder: (_) => questaoTemas()
        );
      case ROTA_HOME :
        return MaterialPageRoute(
            builder: (_) => Home()
        );
      case "/perguntas" :
        return MaterialPageRoute(
            builder: (_) => ExibirPerguntas(args)
        );
      default:
        _erroRota();
    }
  }
  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
        builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text("Tela não encontrada")
          ),
          body: Center(
            child: Text("Tela não encontrada"),
          ),
        );
        }
    );
  }
}