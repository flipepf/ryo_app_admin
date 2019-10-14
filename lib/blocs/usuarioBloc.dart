import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioBloc extends BlocBase {

  final _usuariosController = BehaviorSubject<List>();

  Stream<List> get outUsuarios => _usuariosController.stream;

  Map<String, Map<String, dynamic>> _usuarios = {};

  Firestore _firestore = Firestore.instance;

  UsuarioBloc(){
    _addUsuariosListener();
  }

  void onChangedSearch(String search){
    if(search.trim().isEmpty){
      _usuariosController.add(_usuarios.values.toList());
    } else {
      _usuariosController.add(_filter(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String search){
    List<Map<String, dynamic>> filteredUsuarios = List.from(_usuarios.values.toList());
    filteredUsuarios.retainWhere((user){
      return user["nome"].toUpperCase().contains(search.toUpperCase());
    });
    return filteredUsuarios;
  }

  void _addUsuariosListener(){
    _firestore.collection("usuarios").snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((change){

        String uid = change.document.documentID;

        switch(change.type){
          case DocumentChangeType.added:
            _usuarios[uid] = change.document.data;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _usuarios[uid].addAll(change.document.data);
            _usuariosController.add(_usuarios.values.toList());
            break;
          case DocumentChangeType.removed:
            _usuarios.remove(uid);
            _unsubscribeToOrders(uid);
            _usuariosController.add(_usuarios.values.toList());
            break;
        }

      });
    });
  }
  //############################################################################
  void _subscribeToOrders(String uid){
    _usuarios[uid]["subscription"] = _firestore.collection("usuarios").document(uid)
        .collection("pedidos").snapshots().listen((pedidos) async {

      int numOrders = pedidos.documents.length;

      double money = 0.0;

      for(DocumentSnapshot d in pedidos.documents){
        DocumentSnapshot pedido = await _firestore.collection("pedidos").document(d.documentID).get();

        if(pedido.data == null) continue;
        
        money += pedido.data["valorTotal"];
      }

      _usuarios[uid].addAll({"money": money, "pedidos": numOrders}
      );

      _usuariosController.add(_usuarios.values.toList());
    });
  }

  void _unsubscribeToOrders(String uid){
    _usuarios[uid]["subscription"].cancel();
  }
  //############################################################################
  Map<String, dynamic> getUsuario(String uid){
    return _usuarios[uid];
  }
  //############################################################################
  @override
  void dispose() {
    _usuariosController.close();
  }

}