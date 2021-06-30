import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("products").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Center(child:  CircularProgressIndicator(),);
        else{

          /*pega o listTile e divide elas, pegando do banco os dados
          e inserindo uma cor para a divisão, e transformando em lista*/
          var dividedTiles = ListTile.divideTiles(tiles: snapshot.data.documents.map(
                  (doc){
                return CategoryTile(doc);
                //transforma em lista[toList] os itens do CatregoryTIle
              }
          ).toList(),
          color: Colors.grey[500]).toList();

          return ListView(
                children: dividedTiles
                    //passando o risco de divisão do s widgets
          );
        }

    },
    );
  }
}
