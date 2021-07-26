import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midquest2021/model/FavoritosModel.dart';
import 'main.dart';

class ItemFavoritos extends StatelessWidget {

  FavoritosModel favoritosModel;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;

  ItemFavoritos(
      {
        @required this.favoritosModel,
        this.onTapItem,
        this.onPressedRemover
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(children:<Widget> [
                  Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          favoritosModel.perguntas,
                          style: TextStyle(
                            color: temaPadrao.accentColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              if(this.onPressedRemover != null)
          Expanded(
          flex: 1,
          child: FlatButton(
            color: Colors.white,
            padding: EdgeInsets.all(5),
            onPressed: this.onPressedRemover,
            child: Icon(Icons.star,color: temaPadrao.primaryColor,),
          )
      )
      ],
    ),
    ),
    ),
    );
  }
}
