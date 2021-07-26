import 'package:cloud_firestore/cloud_firestore.dart';

class temaModel{

  String _id;
  String _especialidadePergunta;
  String _temaPergunta;

  temaModel();

  temaModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){

    this.id = documentSnapshot.documentID;
    this.especialidadePergunta = documentSnapshot["especialidadePergunta"];
    this.temaPergunta = documentSnapshot["temaPergunta"];
  }

  temaModel.gerarId(){
    Firestore db = Firestore.instance;
    CollectionReference perguntas = db.collection("perguntas");
    this.id = perguntas.document().documentID;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "especialidadePergunta" : this.especialidadePergunta,
      "temaPergunta" : this.temaPergunta,
    };
    return map;
  }

  String get temaPergunta => _temaPergunta;

  set temaPergunta(String value) {
    _temaPergunta = value;
  }

  String get especialidadePergunta => _especialidadePergunta;

  set especialidadePergunta(String value) {
    _especialidadePergunta = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}