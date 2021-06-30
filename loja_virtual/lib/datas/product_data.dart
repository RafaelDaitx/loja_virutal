import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData{

  String category;
  String id;

  String title;
  String description;

  double prize;

  List images;
  List size;

  ProductData.fromDocument(DocumentSnapshot snapshot){
    /*pegando o documento do banco e convertendo para os
     tipos de variáveis definidos acima*/
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    prize = snapshot.data["price"];
    images = snapshot.data["images"];
    size = snapshot.data["size"];
  }

  Map< String, dynamic> toResumedMap(){
    return {
      "title": title,
      "description": description,
      "prize": prize
    };
  }

}