import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ryo_app_admin/blocs/usuarioBloc.dart';

import 'package:http/http.dart' as http;

class PedidoHeader extends StatelessWidget {

  final DocumentSnapshot pedido;
  PedidoHeader(this.pedido);

  @override
  Widget build(BuildContext context) {

    final _usuarioBloc = BlocProvider.of<UsuarioBloc>(context);
    final _usuario = _usuarioBloc.getUsuario(pedido.data["idUsuario"]);

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("${_usuario["nome"]}"),
              Text("${_usuario["endereço"]}")
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text("Produtos: R\$${pedido.data["valorProdutos"].toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w500),),
            Text("Total: R\$${pedido.data["valorTotal"].toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w500),)
          ],
        )
      ],
    );
  }
}