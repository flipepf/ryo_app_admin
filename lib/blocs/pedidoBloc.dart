import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum Ordem {CONCLUIDOS_INICIO, CONCLUIDOS_FIM}

class PedidoBloc extends BlocBase {

  final _pedidosController = BehaviorSubject<List>();

  Stream<List> get outPedidos => _pedidosController.stream;
  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _pedidos = [];
  Ordem _ordem;

  PedidoBloc(){
    _addPedidosListener();
  }
  //############################################################################
  void _addPedidosListener(){
    _firestore.collection("pedidos").snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((change){ //ACESSA AS MUDANÇAS DO DOCUMENTO E PARA CADA MUDANÇA CHAMA A FUNÇÃO PASSANDO A MUDANÇA
        String pid = change.document.documentID;

        switch(change.type){
          case DocumentChangeType.added: //CASO A MUDANÇA SEJA UM PEDIDO NOVO
            _pedidos.add(change.document); //ARMAZENA O NOVO DOCUMENTO NA LISTA _pedidos
            break;
          case DocumentChangeType.modified: //CASO A ALTERAÇÃO SEJA A EDIÇÃO DE UM PEDIDO
            _pedidos.removeWhere((pedido) => pedido.documentID == pid); //REMOVE A POSIÇÃO EM QUE DocumentID É IGUAL A pid
            _pedidos.add(change.document); //E ADICIONA O NOVO COM A ALTERAÇÃO
            break;
          case DocumentChangeType.removed:
            _pedidos.removeWhere((pedido) => pedido.documentID == pid); //REMOVE A POSIÇÃO EM QUE DocumentID É IGUAL A pid
            break;
        }
      });
      _ordena();
    });
  }
  //############################################################################
  void setOrdem(Ordem ordem){
    _ordem = ordem;
    _ordena();
  }

  void _ordena(){
    switch(_ordem){
      case Ordem.CONCLUIDOS_FIM:
        _pedidos.sort((a,b) {
          int sa = a.data["status"];
          int sb = b.data["status"];
          if (sa > sb) return 1;
          else if (sa < sb) return -1;
          else return 0;
        });
        break;
      case Ordem.CONCLUIDOS_INICIO:
        _pedidos.sort((a,b) {
          int sa = a.data["status"];
          int sb = b.data["status"];
          if (sa < sb) return 1;
          else if (sa > sb) return -1;
          else return 0;
        });
        break;
    }
    _pedidosController.add(_pedidos);
  }
  //############################################################################
  @override
  void dispose() {
    _pedidosController.close();
  }
}