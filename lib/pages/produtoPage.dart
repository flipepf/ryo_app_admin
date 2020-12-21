import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ryo_app_admin/blocs/produtoBloc.dart';
//import 'package:gerente_loja/validators/produto_validator.dart';
//import 'package:gerente_loja/widgets/images_widget.dart';
//import 'package:gerente_loja/widgets/produto_sizes.dart';

class ProdutoPage extends StatelessWidget {
//class ProdutoPage extends StatefulWidget {

  final String categoriaId;
  final DocumentSnapshot produto;

 /* ProdutoPage({this.categoriaId, this.produto});

  @override
  _ProdutoPageState createState() => _ProdutoPageState(categoriaId, produto);
}

class _ProdutoPageState extends State<ProdutoPage> with ProdutoValidator {

  final ProdutoBloc _produtoBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProdutoPageState(String categoriaId, DocumentSnapshot produto) :
        _produtoBloc = ProdutoBloc(categoriaId: categoriaId, produto: produto);*/

  final ProdutoBloc _produtoBloc;
  
  ProdutoPage({this.categoriaId, this.produto}) :
        _produtoBloc = ProdutoBloc(categoriaId: categoriaId, produto: produto);

  @override
  Widget build(BuildContext context) {
    //##################################################### DECORAÇÃO DOS CAMPOS
    InputDecoration _buildDecoration(String label){
      return InputDecoration(labelText: label, labelStyle: TextStyle(color: Colors.grey) );
    }
    //################################## DEFININDO  O ESTILO DOS CAMPOS DE TEXTO
    final _estiloCampo = TextStyle( color: Colors.white, fontSize: 16 );
    //##########################################################################
    return Scaffold(
      //key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      //########################################################################
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _produtoBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? "Editar Produto" : "Criar Produto");
            }
        ),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _produtoBloc.outCreated,
            initialData: false,
            builder: (context, snapshot){
              if(snapshot.data)
                return StreamBuilder<bool>(
                    stream: _produtoBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: snapshot.data ? null : (){
                          _produtoBloc.deleteProduto();
                          Navigator.of(context).pop();
                        },
                      );
                    }
                );
              else return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _produtoBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  //onPressed: snapshot.data ? null : salvaProduto,
                );
              }
          ),
        ],
      ),
      //########################################### CAMPOS  CADASTRO DE PRODUTOS
      body: Stack(
        children: <Widget>[
          Form(
            //key: _formKey,
            child: StreamBuilder<Map>(
                stream: _produtoBloc.outData,
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      //################################################# IMAGEM
                      Text(
                        "Imagem",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12
                        ),
                      ),
                      /*ImagesWidget(
                        context: context,
                        initialValue: snapshot.data["images"],
                        onSaved: _produtoBloc.saveImages,
                        validator: validateImages,
                      ),*/
                      //########################################################
                      TextFormField(
                        initialValue: snapshot.data["nome"],
                        style: _estiloCampo,
                        decoration: _buildDecoration("Nome"),
                        onSaved: _produtoBloc.salvaNome,
                        //validator: validateTitle,
                      ),
                      //########################################################
                      TextFormField(
                        initialValue: snapshot.data["descricao"],
                        style: _estiloCampo,
                        maxLines: 6, //CAMPO MAIOR QUE OS DEMAIS
                        decoration: _buildDecoration("Descrição"),
                        onSaved: _produtoBloc.salvaDescricao,
                        //validator: validateDescription,
                      ),
                      //########################################################
                      TextFormField(
                        initialValue: snapshot.data["valor"]?.toStringAsFixed(2),
                        style: _estiloCampo,
                        decoration: _buildDecoration("Valor"),
                        keyboardType: TextInputType.numberWithOptions(decimal: true), //TECLADO NUMÉRICO
                        onSaved: _produtoBloc.salvaValor,
                        //validator: validatePrice,
                      ),
                      SizedBox(height: 16,),
                   ],
                  );
                }
            ),
          ),
          StreamBuilder<bool>(
              stream: _produtoBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
/*
  void salvaProduto() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text("Salvando produto...", style: TextStyle(color: Colors.white),),
            duration: Duration(minutes: 1),
            backgroundColor: Colors.pinkAccent,
          )
      );

      bool success = await _produtoBloc.salvaProduto();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(success ? "Produto salvo!" : "Erro ao salvar produto!", style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.pinkAccent,
          )
      );
    }
  }*/

}
