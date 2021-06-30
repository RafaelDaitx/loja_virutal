import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/about_tile.dart';

class AboutTab extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //estou obtendo so documentos do banco
    return FutureBuilder<QuerySnapshot>(
    future: Firestore.instance.collection("places").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Center(
          child: CircularProgressIndicator(),
          );
        else
          return ListView(
            children: snapshot.data.documents.map((doc) =>AboutTile(doc)).toList(),
          );
      },
    );
  }
}
