import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    //degradê do botao de menu
    Widget _buildDrawerBack() => Container(
            decoration: BoxDecoration(
                //degradê
                gradient: LinearGradient(
                    colors: [
              Color.fromARGB(255, 203, 203, 241),
              Colors.white,
            ],
                    begin: Alignment.topCenter, // onde começa o degradê
                    end: Alignment.bottomCenter // onde termiona o degradê
                    )));

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0, // altura do header do menuzinho
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      //posição somente desse texto
                      top: 8.0,
                      left: 0.0,
                      child: Text(
                        "Projetos\nDesign",
                        style: TextStyle(
                            fontSize: 34.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                       //se o user não estiver logado, mostre nada (""), se não, mostre o nome dele após o ola
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn() ?
                                  "Entre ou cadastre-se >" : "Sair",
                         //se estiver logado, mostre entre, se não estiver mostre sair
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  if(!model.isLoggedIn())
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context)=> LoginScreen()),
                                  );
                                  else
                                    model.signOut();
                                },
                              ),
                            ],
                          );
                        }
                      )
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.list, "Projetos", pageController, 1),
              DrawerTile(Icons.contact_mail_outlined, "Sobre", pageController, 2),
              DrawerTile(Icons.playlist_add_check, "Projetos solicitados", pageController, 3),
            ],
          ),
        ],
      ),
    );
  }
}
