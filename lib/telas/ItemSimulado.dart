import 'package:flutter/material.dart';

import 'main.dart';

class ItemSimulado extends StatefulWidget {

  final String opcao, descricao, respostaCorreta, opcaoSelecionada;

  const ItemSimulado({
    @required this.opcao,
    @required this.descricao,
    @required this.respostaCorreta,
    @required this.opcaoSelecionada});

  @override
  _ItemSimuladoState createState() => _ItemSimuladoState();
}

class _ItemSimuladoState extends State<ItemSimulado> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      border: Border.all(color: widget.descricao == widget.opcaoSelecionada
                          ?widget.opcaoSelecionada == widget.respostaCorreta
                          ? Colors.blue.withOpacity(0.7)
                          : Colors.blue.withOpacity(0.7)
                          : Colors.grey,width: 1.4),
                      borderRadius: BorderRadius.circular(70)),
                  alignment: Alignment.center,
                  child: Text("${widget.opcao}", style: TextStyle(
                      color: widget.opcaoSelecionada == widget.descricao
                          ? widget.respostaCorreta == widget.opcaoSelecionada
                          ? Colors.blue.withOpacity(0.7)
                          : Colors.blue
                          : Colors.grey
                  ),),
                ),),
            SizedBox(width: 8,),
            Expanded(
              flex: 10,
              child:Container(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(widget.descricao,textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18, color: temaPadrao.accentColor,
                  ),
                ),
              )
            ),
          ],
        ),
      )
    );
  }
}
