import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ryo_app_admin/blocs/pedidoBloc.dart';
import 'package:ryo_app_admin/blocs/usuarioBloc.dart';
import 'package:ryo_app_admin/tabs/pedidosTab.dart';
import 'package:ryo_app_admin/tabs/produtosTab.dart';
import 'package:ryo_app_admin/tabs/usuariosTab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //############################################################################
  PageController _pageController;
  int _page = 0;

  UsuarioBloc _usuarioBloc;
  PedidoBloc _pedidoBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _usuarioBloc = UsuarioBloc();
    _pedidoBloc = PedidoBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  //############################################################################
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      //########################################################################
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: (pagina) {
          _pageController.animateToPage(pagina,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("Pedidos")),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Produtos")),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Clientes")),
        ],
      ),
      //######################################################################
      body: SafeArea( //SAFE AREA PARA DESCONSIDERAR A AREA DO TOPO DA TELA (DEVIDO A NÃO TER APPBAR)
        child: BlocProvider<UsuarioBloc>(
          bloc: _usuarioBloc,
          child: BlocProvider<PedidoBloc>(
            bloc: _pedidoBloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (pagina) {
                setState(() {
                  _page = pagina;
                });
              },
              children: <Widget>[
                PedidosTab(),
                ProdutosTab(),
                UsuariosTab()
              ]
            )
          ),
        ),
      ),
      floatingActionButton: _buildBotao(),
    );
  }
  //############################################################################
  Widget _buildBotao(){
    switch(_page){
      case 2:
        return null;
      case 0:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.red,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(Icons.arrow_downward, color: Colors.red),
              backgroundColor: Colors.white,
              label: "Concluidos Abaixo",
              labelStyle: TextStyle(fontSize: 14),
              onTap: (){
                _pedidoBloc.setOrdem(Ordem.CONCLUIDOS_FIM);
              }
            ),
            SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Colors.red),
                backgroundColor: Colors.white,
                label: "Concluidos Acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: (){
                  _pedidoBloc.setOrdem(Ordem.CONCLUIDOS_INICIO);
                }
            )
          ],
        );
    }
  }
}