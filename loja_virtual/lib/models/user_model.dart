import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends Model {
//model de cadastro de usuário

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser; //usuário
  Map<String, dynamic> userData = Map();

  bool isLoading = false;
  static UserModel of(BuildContext context)=>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  //com o {} no map, torna-se opcional, mas são obrigatórios se estiverem preenchidos
  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true; //carregando
    notifyListeners(); //notificando o ususário que está carregando

    _auth
        .createUserWithEmailAndPassword(
      email: userData["email"],
      password: pass,
    )
        .then((user) async {
      //tentando criar o usuário passando email e senha
      firebaseUser = user;
      await _saveUserData(userData); //salva no banco
      //se funcionar, vai chamar o onSucess
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      //se tiver erro, vai chamr o onFaill
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn(
      {@required String,
      @required email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

 _auth.signInWithEmailAndPassword(email: email, password: pass).then(
     (user) async{
      firebaseUser=user;

      await _loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
     }).catchError((e){
      isLoading=false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverpass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  //salva os dados do usuário
  Future<Null> _saveUserData(Map<String, dynamic> userData) {
    this.userData = userData;
    Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurrentUser() async{
    if(firebaseUser ==null)
      firebaseUser = await _auth.currentUser();
    if(firebaseUser !=null){
      if(userData["name"] ==null){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }
}
