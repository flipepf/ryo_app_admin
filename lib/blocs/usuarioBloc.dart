import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioBloc extends BlocBase {

  final _usuariosController = BehaviorSubject<List>();
  Stream<List> get outUsuarios => _usuariosController.stream;
  Map<String, Map<String, dynamic>> _usuarios = {};//DOIS MAP PARA PASSAR OS DADOS DO USUARIOS O PRIMEIRO ARMAZENA O ID FACILITA A BUSCA
  Firestore _firestore = Firestore.instance;

  //CONSTRUTOR ADICIONA UM LISTENER PARA SER CHAMAADO A CADA AÇÃO COM USUARIO (ADIÇÃO, EXCLUSÃO ALTERAÇÃO, ETC..
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
  //############################################################################
  List<Map<String, dynamic>> _filter(String search){
    List<Map<String, dynamic>> filteredUsuarios = List.from(_usuarios.values.toList());
    filteredUsuarios.retainWhere((user){
      return user["nome"].toUpperCase().contains(search.toUpperCase());
    });
    return filteredUsuarios;
  }

  void _addUsuariosListener(){
    _firestore.collection("usuarios").snapshots().listen((snapshot){ //OBTEM APENAS OS DADOS QUANDO HOUVE MODIFICAÇÃO DOS DADOS
      snapshot.documentChanges.forEach((change){ //PARA CADA MUDANÇA CHAMA FUNÇÃO ANONIMA PASSANDO A MUDANÇA

        String uid = change.document.documentID; //RECEBE O ID DO USUARIO MODIFICADO

        switch(change.type){ //SELECIONA DE ACORDO COM O TIPO DA MUDANÇA
          case DocumentChangeType.added:
            _usuarios[uid] = change.document.data; //ATUALIZA O MAP ADICIONANDO O NOVO USUARIO
            _calculaPedidos(uid);
            break;
          case DocumentChangeType.modified:
            _usuarios[uid].addAll(change.document.data); //ATUALIZA AS INFORMAÇÕES DO USUARIO QUE FOI MODIFICADO NO MAP - SOMENTE A INFORMAÇÃO QUE FOI MODIFICADA
            _usuariosController.add(_usuarios.values.toList());
            break;
          case DocumentChangeType.removed:
            _usuarios.remove(uid);
            _unsubscribeToPedidos(uid);
            _usuariosController.add(_usuarios.values.toList());
            break;
        }

      });
    });
  }
  //############################################################################
  void _calculaPedidos(String uid){
    _usuarios[uid]["subscription"] = _firestore.collection("usuarios").document(uid)
        .collection("pedidos").snapshots().listen((pedidos) async {

      int numPedidos = pedidos.documents.length;// DEFINE A QUANTIDADE DOS PEDIDOS

      double valor = 0.0;

      for(DocumentSnapshot p in pedidos.documents){
        DocumentSnapshot pedido = await _firestore.collection("pedidos").document(p.documentID).get();

        if(pedido.data == null) continue;

        valor += pedido.data["valorTotal"];
      }
      _usuarios[uid].addAll({"valor": valor, "pedidos": numPedidos}
      );
      _usuariosController.add(_usuarios.values.toList());
    });
  }

  void _unsubscribeToPedidos(String uid){
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