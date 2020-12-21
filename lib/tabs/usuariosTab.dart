import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ryo_app_admin/blocs/usuarioBloc.dart';
import 'package:ryo_app_admin/widgets/itemListaUsuarios.dart';

class UsuariosTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _usuarioBloc = BlocProvider.of<UsuarioBloc>(context);
    return Column(
      children: <Widget>[
        //#################################################### CAIXA DE PESQUISA
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child:TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: "Pesquisar",
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.search, color: Colors.white,),
                border: InputBorder.none
            ),
            onChanged: _usuarioBloc.onChangedSearch,
          ),
        ),
        //####################################################
        Expanded(
          child: StreamBuilder<List>(
              stream: _usuarioBloc.outUsuarios,
              builder: (context, snapshot) {
                //######################## ENQUANTO NÃO HOUVER DADOS NO SNAPSHOT
                if(!snapshot.hasData)
                  return Center(child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(Colors.red),),);
                //############################################ SE RETORNAR VAZIO
                else if(snapshot.data.length == 0)
                  return Center(child: Text("Nenhum usuário encontrado!", style: TextStyle(color: Colors.red),),);
                else
                //############################## LISTA DE USUARIOS COM SEPARAÇÃO
                  return ListView.separated(
                    itemBuilder: (context, index){ return ItemListaUsuarios(snapshot.data[index]);},
                    separatorBuilder: (context, index){ return Divider(color: Colors.grey, ); }, // SEPARADOR
                    itemCount: snapshot.data.length
                  );
              }
          ),
        )
      ],
    );
  }
}
//}