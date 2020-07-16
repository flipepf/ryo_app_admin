import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemListaUsuarios extends StatelessWidget {

  final Map<String, dynamic> usuario;
  ItemListaUsuarios(this.usuario);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white);//REDUZIR CÓDIGO

    if(usuario.containsKey("valor"))
      return ListTile(
        //##################################################INFORMAÇÕES DO USUÁRIO
        title: Text( usuario["nome"],
                     style: textStyle, ),
        subtitle: Text(usuario["email"],
                       style: textStyle, ),
        //#########################################################TEXTO A DIREITA
        trailing: Column( crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text("Pedidos: ${usuario["pedidos"]}",
                                  textAlign: TextAlign.right,
                                  style: textStyle, ),
                            Text("Gasto: R\$${usuario["valor"].toStringAsFixed(2)}",
                                  style: textStyle, )
                          ],
                      ),
        //######################################################################
      );
    else
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 20,
              child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    margin: EdgeInsets.symmetric(vertical: 4),
                  ),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey
              ),
            ),
            SizedBox(
              width: 50,
              height: 20,
              child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    margin: EdgeInsets.symmetric(vertical: 4),
                  ),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey
              ),
            )
          ],
        ),
      );
  }
}