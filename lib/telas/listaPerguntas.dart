import 'package:flutter/material.dart';

import 'main.dart';

class listaPerguntas extends StatefulWidget {

  final String opcao, descricaoResposta,respostaCorreta, opcaoSelecionada;
  const listaPerguntas({Key key,@required this.opcao,@required this.descricaoResposta,@required this.respostaCorreta,@required this.opcaoSelecionada}) : super(key: key);

  @override
  _listaPerguntasState createState() => _listaPerguntasState();
}

class _listaPerguntasState extends State<listaPerguntas> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: widget.descricaoResposta ==widget.opcaoSelecionada
                ?widget.opcaoSelecionada == widget.respostaCorreta ?
              Colors.green.withOpacity(0.7)
                  : Colors.red.withOpacity(0.7): Colors.grey)
            ),
            child: Text("${widget.opcao}",style: TextStyle(
                color: widget.opcaoSelecionada == widget.descricaoResposta?
                widget.respostaCorreta == widget.opcaoSelecionada? Colors.green.withOpacity(0.7):
                    Colors.red
                    :Colors.grey),
            ),
          ),
          SizedBox(width: 8,),
          Text(widget.descricaoResposta,style: TextStyle(fontSize: 17, color: temaPadrao.primaryColor),)
        ],
      ),
    );
  }
}
