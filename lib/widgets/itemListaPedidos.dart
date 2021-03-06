import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ryo_app_admin/widgets/pedidoHeader.dart';
import 'package:http/http.dart' as http;
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ryo_app_admin/blocs/usuarioBloc.dart';

class ItemListaPedidos extends StatelessWidget {
  final DocumentSnapshot pedido;

  ItemListaPedidos(this.pedido);

  final status = ["", "Em preparação", "Em transporte", "Entregue"];
  final fcmKey = "AAAAo42Z68Y:APA91bE9xNtbPLKaOSZE4HiZr6b1S_hRjHNVjALL-L9Hz-YwWnU84S4p-EzRSBHNlOUZV5G5_4XaINGbCekaCnTQUaEzVR34HZdYETfrSqsI4TuhNehlYPR-D5fAjBYSCF0GvlSSjPkA";

  @override
  Widget build(BuildContext context) {
    final _usuarioBloc = BlocProvider.of<UsuarioBloc>(context);
    final _usuario = _usuarioBloc.getUsuario(pedido.data["idUsuario"]);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(pedido.documentID),
          initiallyExpanded: pedido.data["status"]!=3,
          title: Text(
            "#${pedido.documentID.substring(pedido.documentID.length - 8, pedido.documentID.length)} - "
                "${status[pedido.data["status"]]}",
            style: TextStyle(color: pedido.data["status"] != 3 ? Colors.grey[850] : Colors.green),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left:16, right:16, top:0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //PedidoHeader(pedido),
                  PedidoHeader(pedido, _usuario["nome"].toString(), _usuario["endereço"].toString()),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: pedido.data["produtos"].map<Widget>((p){
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(p["produto"]["nome"]),
                        subtitle: Text(p["categoria"]), //+"/"+ p["produtoId"]),
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
                          if (pedido.data["status"] == 1) {
                            String DATA = "{\"notification\": {\"body\": \"Quase lá, seu pedido saiu para entregua!!!\",\"title\": \"Pedido: "+pedido.documentID+"\"}, \"priority\": \"high\", \"data\": {\"click_action\": \"FLUTTER_NOTIFICATION_CLICK\", \"id\": \"1\", \"status\": \"done\"}, \"to\": \""+_usuario["token"]+"\"}";
                            http.post("https://fcm.googleapis.com/fcm/send", body: DATA,
                            headers: {"Content-Type": "application/json", "Authorization": "key="+fcmKey });
                          }
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