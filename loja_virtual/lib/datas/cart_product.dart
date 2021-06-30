import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct{
  String categoryId;
  String category;
  String productId;
  int quantity;
  String size;

  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document){
    categoryId =document. documentID;
    category = document.data["category"];
    productId = document.data["pid"];
    quantity = document.data["quantity"];
    size = document.data["size"];
  }

  Map<String, dynamic> toMap(){
    return{
      "category": category,
      "pid": productId,
      "quantity": quantity,
      "size": size,
      "product": productData.toResumedMap()
    };
  }
}