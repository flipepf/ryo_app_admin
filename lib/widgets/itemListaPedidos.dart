import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ryo_app_admin/widgets/pedidoHeader.dart';

class ItemListaPedidos extends StatelessWidget {

  final DocumentSnapshot pedido;

  ItemListaPedidos(this.pedido);

  final status = ["", "Em preparação", "Em transporte", "Entregue"];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(pedido.documentID),
          initiallyExpanded: pedido.data["status"]!=3,
          title: Text(
            "#${pedido.documentID.substring(pedido.documentID.length - 7, pedido.documentID.length)} - "
                "${status[pedido.data["status"]]}",
            style: TextStyle(color: pedido.data["status"] != 3 ? Colors.grey[850] : Colors.green),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left:16, right:16, top:0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  PedidoHeader(pedido),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: pedido.data["produtos"].map<Widget>((p){
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(p["produto"]["nome"]),
                        subtitle: Text(p["categoria"] +"/"+ p["produtoId"]),
                        trailing: Text(
                          p["quantidade"].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          //DELETA O PEDIDO NA COLEÇÃO DO USUARIOS
                          Firestore.instance.collection("usuarios").document(pedido["idUsuario"])
                              .collection("pedidos").document(pedido.documentID).delete();
                          pedido.reference.delete(); //DELETA O PEDIDO NA COLEÇÃO PEDIDOS
                        },
                        textColor: Colors.red,
                        child: Text("Excluir"),
                      ),
                      FlatButton(
                        onPressed: pedido.data["status"] > 1 ? (){
                          pedido.reference.updateData({"status": pedido.data["status"] - 1});
                        } : null,
                        textColor: Colors.grey[850],
                        child: Text("Regredir"),
                      ),
                      FlatButton(
                        onPressed: pedido.data["status"] < 3 ? (){
                          pedido.reference.updateData({"status": pedido.data["status"] + 1});
                        } : null,
                        textColor: Colors.green,
                        child: Text("Avançar"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}