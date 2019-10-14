import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:ryo_app_admin/blocs/pedidoBloc.dart';
import 'package:ryo_app_admin/widgets/itemListaPedidos.dart';

class PedidosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _pedidoBloc = BlocProvider.of<PedidoBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        stream: _pedidoBloc.outPedidos,
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Center(child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(Colors.red),),);
          else if(snapshot.data.length == 0)
            return Center(child: Text("Nenhum pedido encontrado!", style: TextStyle(color: Colors.red),),);
          //####################################################################
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index){
              return ItemListaPedidos(snapshot.data[index]);
            }
          );
        }
      )
    );
  }
}
