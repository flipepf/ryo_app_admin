import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:ryo_app_admin/blocs/pedidoBloc.dart';
import 'package:ryo_app_admin/blocs/usuarioBloc.dart';
import 'package:ryo_app_admin/tabs/pedidosTab.dart';
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
                Container(color: Colors.blue),
                UsuariosTab(),
              ]
            )
          ),
        ),
      ),
    );
  }
}