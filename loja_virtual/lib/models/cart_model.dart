import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel user;
  
  List<CartProduct> products = [];
  String  couponCode;
  int discountPorcentage = 0;

  bool isLoading = false;

  CartModel(this.user){
    if(user.isLoggedIn())
      _loadCartItems();
//se o usuário estiver logado, carregue os itens do carrinho
  }


  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);

    Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("cart").add(cartProduct.toMap()).then((doc){
      cartProduct.categoryId = doc.documentID;
    });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").document(cartProduct.categoryId).delete();

    products.remove(cartProduct);

    notifyListeners();
  }


  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;
//diminuir a quantidade no carrinho, vai diminuir o número na tela,e abaixo vai atualiazar
    //no carrinho do usuário selecionado a quantidade
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .document(cartProduct.categoryId).updateData(cartProduct.toMap());

    notifyListeners();
  }


  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .document(cartProduct.categoryId).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupom(String couponCode, int discountPorcentage){
    this.couponCode = couponCode;
    this.discountPorcentage = discountPorcentage;
  }

  void updadtePrice(){
    notifyListeners();
  }

  Future<String> finishOrder() async {
    if(products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    
   DocumentReference refOrder =  await Firestore.instance.collection("orders").add({
      "clientId": user.firebaseUser.uid,
      "products": products.map((cartProduct)=> cartProduct.toMap()).toList(),
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shipPrice,
      "status": 1
    });

   await Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("orders").document(refOrder.documentID).setData({"orderID": refOrder.documentID});

   QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("cart").getDocuments();

   for(DocumentSnapshot doc in query.documents){
     doc.reference.delete();
     //selete os produtos do carrinho no banco
   }

   products.clear();

   couponCode = null;
   discountPorcentage = 0;
   isLoading = false;
   notifyListeners();

   return refOrder.documentID;

  }

  double getProductsPrice(){
  double price = 0.0;
  for(CartProduct total in products){
    if(total.productData != null)
      price += total.quantity * total.productData.prize;
  //pega a quantidade e multiplica pelo preço
  }
  return price;
  }

  double getDiscount(){
  return getProductsPrice() * discountPorcentage / 100;
  //pega o valor do produto, multiplica pelo quantidade de desconto e divide por 100
  }

  double getShipPrice(){
  return 9.99;
  }

  void _loadCartItems() async{
   QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .getDocuments();
   
   products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

   notifyListeners();
  }
}