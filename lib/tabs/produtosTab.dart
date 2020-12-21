import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ryo_app_admin/widgets/itemListaCategorias.dart';

class ProdutosTab extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("produtos").getDocuments(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(Colors.red),),);
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return ItemListaCategorias(snapshot.data.documents[index]);
          }
        );
      }
    );
  }
}