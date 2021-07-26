import 'package:firebase_auth/firebase_auth.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midquest2021/model/Usuario.dart';
import 'package:midquest2021/telas/splash.dart';
import 'dart:convert';
import 'main.dart';

class Pagamento extends StatefulWidget {
  @override
  _PagamentoState createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {

    String _mensal;
    String _trimestral;
    String _anual;
    String _idPagamentoMensal;
    String _idPagamentoTrimestral;
    String _idPagamentoAnual;
    String _idUsuarioLogado;
    String _publicKey = "APP_USR-45f147a6-4487-41c7-9615-a1b7a2e7918d";

    @override
    void initState() {
      super.initState();
      _recuperarDadosPlanos();

      /*var hoje = DateTime.now();
      var vencMes = DateTime.now().add(const Duration(days: 30));
      var vencTri = DateTime.now().add(const Duration(days: 90));
      var vencAno = DateTime.now().add(const Duration(days: 365));
      print("Ano : "+vencTri.toString());*/
    }

    Future<void> _getMensal(double mensal)async{
      var res = await http.post("https://api.mercadopago.com/checkout/preferences?access_token=TEST-2830808265180597-071819-836e7650fa5c9b968a4b36cfb9a46934-10733880",
          body: jsonEncode(
              {
                "items": [
                  {
                    "title": "MedQuest",
                    "description": "Acesso Mensal MedQuest",
                    "quantity": 1,
                    "currency_id": "ARS",
                    "unit_price": mensal
                  }
                ],
                "payer": {
                  "email": "medquest@medquest.com"
                }
              }
          )
      );
      //print(res.body);
      var json = jsonDecode(res.body);
      _idPagamentoMensal = json['id'];
    }

    Future<void> _getTrimestral(double trimestral)async{
      var res = await http.post("https://api.mercadopago.com/checkout/preferences?access_token=TEST-2830808265180597-071819-836e7650fa5c9b968a4b36cfb9a46934-10733880",
          body: jsonEncode(
              {
                "items": [
                  {
                    "title": "MedQuest",
                    "description": "Acesso Trimestral MedQuest",
                    "quantity": 1,
                    "currency_id": "ARS",
                    "unit_price": trimestral
                  }
                ],
                "payer": {
                  "email": "medquest@medquest.com"
                }
              }
          )
      );
      //print(res.body);
      var json = jsonDecode(res.body);
      _idPagamentoTrimestral = json['id'];
    }

    Future<void> _getAnual(double anual)async{
      var res = await http.post("https://api.mercadopago.com/checkout/preferences?access_token=TEST-2830808265180597-071819-836e7650fa5c9b968a4b36cfb9a46934-10733880",
          body: jsonEncode(
              {
                "items": [
                  {
                    "title": "MedQuest",
                    "description": "Acesso Anual MedQuest",
                    "quantity": 1,
                    "currency_id": "ARS",
                    "unit_price": anual
                  }
                ],
                "payer": {
                  "email": "medquest@medquest.com"
                }
              }
          )
      );
      //print(res.body);
      var json = jsonDecode(res.body);
      _idPagamentoAnual = json['id'];
    }

    _recuperarDadosPlanos()async{
      Firestore db = Firestore.instance;
      DocumentSnapshot snapshot = await
      db.collection("planos")
          .document("planos")
          .get();

      Map<String,dynamic> dados = snapshot.data;

      setState(() {
        double valorMensal = double.parse(dados["mensal"]);
        double valorTrimestral = double.parse(dados["trimestral"]);
        double valorAnual = double.parse(dados["anual"]);
        _mensal = dados["mensal"].toString();
        _anual = dados["anual"].toString();
        _trimestral =dados["trimestral"].toString();
        _mensal = _mensal.replaceAll(".", ",");
        _trimestral = _trimestral.replaceAll(".", ",");
        _anual = _anual.replaceAll(".", ",");
        _getMensal(valorMensal);
        _getTrimestral(valorTrimestral);
        _getAnual(valorAnual);
      });
    }

    _salvarPagamento(String pagamento)async{

      Usuario usuario = Usuario();

      if(pagamento=="mensal"){
        var vencMes = DateTime.now().add(const Duration(days: 30));
        usuario.dataVencimento = vencMes.toString();
      }
      if(pagamento=="trimestral"){
        var vencMes = DateTime.now().add(const Duration(days: 90));
        usuario.dataVencimento = vencMes.toString();
      }
      if(pagamento=="anual"){
        var vencMes = DateTime.now().add(const Duration(days: 365));
        usuario.dataVencimento = vencMes.toString();
      }

      usuario.pagamento = pagamento;
      usuario.dataPagamento = DateTime.now().toString();
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser usuarioLogado = await auth.currentUser();
      _idUsuarioLogado = usuarioLogado.uid;
      Firestore db = Firestore.instance;
      Map<String,dynamic> dadosAtualizar = {
        "pagamento" : pagamento,
        "dataVencimento" : usuario.dataVencimento,
        "dataPagamento" : usuario.dataPagamento
      };
      db.collection("usuarios")
          .document(_idUsuarioLogado)
          .updateData(dadosAtualizar);

      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Splash()));
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(15),
                child: Text("Planos",
                    style: TextStyle(fontSize: 25,
                        color: temaPadrao.primaryColor,fontWeight:FontWeight.bold)),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 30,left: 30),
                child: Text("Escolha um dos planos abaixo para acessar o aplicativo.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15,
                        color: temaPadrao.accentColor)),
              ),
              Padding(
                  padding: EdgeInsets.only(right: 30,left: 30,top: 5,bottom: 5),
                  child: GestureDetector(
                    child: Card(
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15),
                          color: temaPadrao.secondaryHeaderColor,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(right: 30,left: 30),
                                    child: Text("Mensal : "+_mensal,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20,
                                            color: temaPadrao.accentColor)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              ElevatedButton(
                                onPressed: () async {
                                  PaymentResult result =
                                  await MercadoPagoMobileCheckout.startCheckout(
                                    _publicKey,
                                    _idPagamentoMensal,
                                  );
                                  print(result.toString());
                                  _salvarPagamento("mensal");
                                },
                                child: Text("Contratar"),
                              ),
                            ],
                          )
                      ),
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(right: 30,left: 30,top: 5,bottom: 5),
                  child: GestureDetector(
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(15),
                          color: temaPadrao.secondaryHeaderColor,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(right: 30,left: 30),
                                    child: Text("Trimestral : "+_trimestral,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(fontSize: 20,
                                            color: temaPadrao.accentColor)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              ElevatedButton(
                                onPressed: () async {
                                  PaymentResult result =
                                  await MercadoPagoMobileCheckout.startCheckout(
                                    _publicKey,
                                    _idPagamentoTrimestral,
                                  );
                                  //print(result.toString());
                                  _salvarPagamento("trimestral");
                                },
                                child: Text("Contratar"),
                              ),
                            ],
                          )
                      ),
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(right: 30,left: 30,top: 5,bottom: 5),
                  child: GestureDetector(
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(20),
                          color: temaPadrao.secondaryHeaderColor,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(right: 30,left: 30),
                                    child: Text("Anual : "+_anual,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(fontSize: 20,
                                            color: temaPadrao.accentColor)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              ElevatedButton(
                                onPressed: () async {
                                  PaymentResult result =
                                  await MercadoPagoMobileCheckout.startCheckout(
                                    _publicKey,
                                    _idPagamentoAnual,
                                  );
                                  //print(result.toString());
                                  _salvarPagamento("anual");
                                },
                                child: Text("Contratar"),
                              ),
                            ],
                          )
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      )
    );
  }
}
