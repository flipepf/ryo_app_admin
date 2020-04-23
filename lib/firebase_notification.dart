import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ryo_app_admin/blocs/usuarioBloc.dart';
import 'package:http/http.dart' as http;

class FirebaseNotifications {

  final DocumentSnapshot pedido;

  FirebaseNotifications(this.pedido);

  void criaNotificacao() {

    //usuario = Firestore.instance.collection("usuarios").document(pedido["idUsuario"]).get().toMap();


  }

}
