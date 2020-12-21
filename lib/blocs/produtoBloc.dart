import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProdutoBloc extends BlocBase {

  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  String categoriaId;
  DocumentSnapshot produto;

  Map<String, dynamic> unsalvadData;
  //################################################################# CONSTRUTOR
  ProdutoBloc({this.categoriaId, this.produto}){
    if(produto != null){
      unsalvadData = Map.of(produto.data);
      //unsalvadData["imagem"] = List.of(produto.data["imagem"]);
      //unsalvadData["sizes"] = List.of(produto.data["sizes"]);

      _createdController.add(true);
    } else {
      unsalvadData = {
        "nome": null, "descricao": null, "valor": null, "imagem": null
      };

      _createdController.add(false);
    }

    _dataController.add(unsalvadData);
  }

  void salvaNome(String nome){
    unsalvadData["nome"] = nome;
  }

  void salvaDescricao(String descricao){
    unsalvadData["descricao"] = descricao;
  }

  void salvaValor(String valor){
    unsalvadData["valor"] = double.parse(valor);
  }

  void salvaImagem(String imagem){
    unsalvadData["imagem"] = imagem;
  }

  Future<bool> salvaProduto() async {
    _loadingController.add(true);

    try {
      if(produto != null){
        await _uploadImagem(produto.documentID);
        await produto.reference.updateData(unsalvadData);
      } else {
        DocumentReference dr = await Firestore.instance.collection("produtos").document(categoriaId).
        collection("items").add(Map.from(unsalvadData)..remove("imagem"));
        await _uploadImagem(dr.documentID);
        await dr.updateData(unsalvadData);
      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e){
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImagem(String produtoId) async {
    for(int i = 0; i < unsalvadData["imagem"].length; i++){
      if(unsalvadData["imagem"][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(categoriaId).
      child(produtoId).child(DateTime.now().millisecondsSinceEpoch.toString()).
      putFile(unsalvadData["imagem"][i]);

      StorageTaskSnapshot s = await uploadTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();

      unsalvadData["imagem"][i] = downloadUrl;
    }
  }

  void deleteProduto(){
    produto.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }

}