import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midquest2021/model/FavoritosModel.dart';
import 'package:midquest2021/model/PerguntaModel.dart';
import 'package:midquest2021/telas/main.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'ItemFavoritos.dart';

class Favoritos extends StatefulWidget {

  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  FavoritosModel _favoritosModel = FavoritosModel();
  String _idUsuarioLogado;
  double favoritos = 0;
  String _especialidadeUsuario;
  int _favoritos;

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
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

    _especialidadeUsuario = dados["especialidade"];

    String especialidade = _especialidadeUsuario;
    bool carregando = false;
    //print("espc : " + especialidade);

    _adicionarListenerPerguntas(especialidade);
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerPerguntas(String especialidade)async{

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("favoritosPergunta")
        .document(_idUsuarioLogado)
        .collection(especialidade)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);

      setState(() {
        _favoritos = dados.documents.length;
        print("Quantidade : "+_favoritos.toString());
      });
    });
  }

  _removerPerguntas(String idPergunta,String especialidade){
    Firestore db = Firestore.instance;
    db.collection("favoritosPergunta")
        .document(_idUsuarioLogado)
        .collection(especialidade)
        .document(idPergunta)
        .delete().then((_){

      db.collection("favoritosPergunta")
          .document(_idUsuarioLogado)
          .collection(especialidade)
          .document(idPergunta)
          .delete();
    });
    _recuperarDadosUsuario();
  }

  var carregandoDados = Center(
    child: Column(children: <Widget>[
      Container(child: Text("Carregando perguntas")),
      CircularProgressIndicator()
    ],),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Favoritos",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 25,
                color: temaPadrao.primaryColor,
                fontWeight:FontWeight.bold,
              )
          ),
          SizedBox(height: 10,),
          _favoritos != 0?
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
                        itemCount: querySnapshot.documents.length,
                        itemBuilder: (_,indice){
                          List<DocumentSnapshot> perguntas = querySnapshot.documents.toList();
                          DocumentSnapshot documentSnapshot = perguntas[indice];
                          FavoritosModel favoritosModel = FavoritosModel.fromDocumentSnapshot(documentSnapshot);
                          return ItemFavoritos(
                            favoritosModel: favoritosModel,
                            onTapItem: (){Navigator.pushNamed(
                                      context,
                                      "/perguntas",
                                      arguments: favoritosModel
                                  );},
                            onPressedRemover: (){
                                    showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            title: Text("Confirmar"),
                                            content: Text("Deseja remover da lista de favoritos?"),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  "Cancelar",
                                                  style: TextStyle(
                                                      color: Colors.grey
                                                  ),
                                                ),
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                color: Colors.red,
                                                child: Text(
                                                  "Remover pergunta",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),
                                                ),
                                                onPressed: (){
                                                  _removerPerguntas(favoritosModel.id,_especialidadeUsuario);
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        }
                                    );
                                  },
                          );
                        }
                    );
                }
                return Container();
              },
            ),
          ):Center(
            heightFactor: 10,
              child: Text("Nenhuma pergunta selecionada como favorita",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: temaPadrao.accentColor,fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}
