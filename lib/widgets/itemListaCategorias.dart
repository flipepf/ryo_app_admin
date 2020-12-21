import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ryo_app_admin/pages/produtoPage.dart';

class ItemListaCategorias extends StatelessWidget {

  final DocumentSnapshot categoria;

  ItemListaCategorias(this.categoria);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: (){/*
              showDialog(context: context,
                  builder: (context) => EditCategoryDialog(
                    categoria: categoria,
                  )
              );*/
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(categoria.data["icon"]),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text(
            categoria.data["nome"],
            style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              future: categoria.reference.collection("items").getDocuments(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return Container();
                return Column(
                  children: snapshot.data.documents.map((doc){
                    //####################################### LISTA DOS PRODUTOS
                    return ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(doc.data["imagem"]), backgroundColor: Colors.transparent,),
                      title: Text(doc.data["nome"]),
                      trailing: Text("R\$${doc.data["valor"].toStringAsFixed(2)}"
                      ),
                      //########################################################
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ProdutoPage( 
                              categoriaId: categoria.documentID,
                              produto: doc, //PASSA O DOC QUE É O PRODUTO A SER EDITADO
                            ))
                        );
                      },
                    );
                  }).toList()..add( //.add PERMITE QUE POSSA SER ADICIONADO OUTRO WIDGET AO FINAL DA LISTA
                      //######################################## BOTÃO ADICIONAR
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.add, color: Colors.pinkAccent,),
                        ),
                        title: Text("Adicionar"),
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ProdutoPage( categoriaId: categoria.documentID,))
                          );
                        },
                      )
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
