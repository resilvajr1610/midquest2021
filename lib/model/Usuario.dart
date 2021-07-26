import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario{

  String _idUsuario;
  String _nome;
  String _sobreNome;
  String _email;
  String _senha;
  String _crm;
  String _especialidade;
  String _tema;
  String _urlFotoPerfil;
  String _urlFotoCRMFrente;
  String _urlFotoCRMVerso;
  String _status = "pendente";
  int _corretas;
  int _incorretas;
  String _tokenId;
  String _pagamento;
  String _dataVencimento;
  String _dataPagamento;

  Usuario();

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "idUsuario" : this.idUsuario,
      "nome" : this.nome,
      "sobreNome" : this.sobreNome,
      "email" : this.email,
      "crm" : this.crm,
      "status" : this.status,
      "especialidade" : this.especialidade,
      "corretas" : this.corretas,
      "incorretas" : this.incorretas,
      "tokenId" : this.tokenId,
      "pagamento" : this.pagamento,
      "dataVencimento" : this.dataVencimento,
      "dataPagamento" : this.dataPagamento,
    };
    return map;
  }

  String get dataPagamento => _dataPagamento;

  set dataPagamento(String value) {
    _dataPagamento = value;
  }

  String get dataVencimento => _dataVencimento;

  set dataVencimento(String value) {
    _dataVencimento = value;
  }

  String get pagamento => _pagamento;

  set pagamento(String value) {
    _pagamento = value;
  }

  String get tokenId => _tokenId;

  set tokenId(String value) {
    _tokenId = value;
  }

  int get corretas => _corretas;

  set corretas(int value) {
    _corretas = value;
  }

  String get tema => _tema;

  set tema(String value) {
    _tema = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get urlFotoPerfil => _urlFotoPerfil;

  set urlFotoPerfil(String value) {
    _urlFotoPerfil = value;
  }

  String get crm => _crm;

  set crm(String value) {
    _crm = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get sobreNome => _sobreNome;

  set sobreNome(String value) {
    _sobreNome = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get especialidade => _especialidade;

  set especialidade(String value) {
    _especialidade = value;
  }

  String get urlFotoCRMFrente => _urlFotoCRMFrente;

  set urlFotoCRMFrente(String value) {
    _urlFotoCRMFrente = value;
  }

  String get urlFotoCRMVerso => _urlFotoCRMVerso;

  set urlFotoCRMVerso(String value) {
    _urlFotoCRMVerso = value;
  }

  int get incorretas => _incorretas;

  set incorretas(int value) {
    _incorretas = value;
  }
}