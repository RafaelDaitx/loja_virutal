import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/cart_model.dart';
import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        //especificando a user model para controle de login do usuário
        //tudo que está abaixo dele, pode ser modificado pelo user model se tiver alteraçõs
        child:ScopedModelDescendant<UserModel>(
      //toda vez que faz login, ele recerreag todo app
      //para puxar as informações corretas do usuario
          builder: (context, child, model){
            return ScopedModel<CartModel>(
              model: CartModel(model),
              child: MaterialApp(
                title: "Flutter's Home",
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    primaryColor: Color.fromARGB(255, 4, 125, 141)),
                debugShowCheckedModeBanner: false,
                home: HomeScreen(),
              ),
            );
          }
        )
    );
  }
}
