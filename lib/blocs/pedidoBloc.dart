import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class PedidoBloc extends BlocBase {

  final _pedidosController = BehaviorSubject<List>();

  Stream<List> get outPedidos => _pedidosController.stream;
  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _pedidos = [];

  PedidoBloc(){
    _addPedidosListener();
  }

  void _addPedidosListener(){
    _firestore.collection("pedidos").snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((change){ //ACESSA AS MUDANÇAS DO DOCUMENTO E PARA CADA MUDANÇA CHAMA A FUNÇÃO PASSANDO A MUDANÇA
        String pid = change.document.documentID;

        switch(change.type){
          case DocumentChangeType.added: //CASO A MUDANÇA SEJA UM PEDIDO NOVO
            _pedidos.add(change.document); //ARMAZENA O NOVO DOCUMENTO NA LISTA _pedidos
            break;
          case DocumentChangeType.modified: //CASO A ALTERAÇÃO SEJA A EDIÇÃO DE UM PEDIDO
            _pedidos.removeWhere((pedido) => pedido.documentID == pid); //REMOVE A POSIÇÃO EM QUE DocumentID É iGUAL A pid
            _pedidos.add(change.document); //E ADICIONA O NOVO COM A ALTERAÇÃO
            break;
          case DocumentChangeType.removed:
            _pedidos.removeWhere((pedido) => pedido.documentID == pid); //REMOVE A POSIÇÃO EM QUE DocumentID É iGUAL A pid
            break;
        }
      });
      _pedidosController.add(_pedidos);//_sort();
    });
  }

  @override
  void dispose() {
    _pedidosController.close();
  }
}