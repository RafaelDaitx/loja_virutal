import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        //icone que fica na esquerda
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
        //vai pegar a imagem do banco
      ),
      title: Text(snapshot.data["title"]),
      //pegar o titulo do banco
      trailing: Icon(Icons.keyboard_arrow_right),
      //setinha no lado direito do produto
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CategoryScreen(snapshot)));
      },
    );
  }
}
