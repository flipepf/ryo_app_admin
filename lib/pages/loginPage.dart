import 'package:flutter/material.dart';
import 'package:ryo_app_admin/blocs/loginBloc.dart';
import 'package:ryo_app_admin/widgets/caixaTexto.dart';
import 'package:ryo_app_admin/pages/homePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _loginBloc = LoginBloc(); //DECLARANDO O BLOC, SÓ SERÁ UTILIZADO NESTA TELA, POR ISSO NÃO É NECESSÁRIO COLOCÁ-LO DENTRO DE UM PROVIDER
  //########################################### ADICIONA UM LISTENER AO outState
  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state){
      switch(state){
        case LoginState.SUCCESS: //SE O ESTADO FOR SUCESSO MUDA PARA A PAGINA PRINCIPAL
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context)=>HomePage())
          );
          break;
        case LoginState.FAIL: //SE FOR FALHA EXIBE UM ALERTA
          showDialog(context: context, builder: (context)=>AlertDialog(
            title: Text("Erro"),
            content: Text("Você não possui os privilégios necessários"),
          ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }
  //############################################################################
  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
//##############################################################################
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,
        builder: (context, snapshot) {
          print(snapshot.data);
          switch(snapshot.data){
            case LoginState.LOADING:
              return Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.red),),);
            case LoginState.FAIL:
            case LoginState.SUCCESS:
            case LoginState.IDLE:
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(),
                SingleChildScrollView( //TECLADO NÃO TOMAR TODA A TELA
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.stretch, //ESTICA TUDO NO EIXO HORIZONTAL
                      children: <Widget>[
                        Icon(
                          Icons.supervisor_account,
                          color: Colors.red,
                          size: 160,
                        ),
                        CaixaTexto(
                          icon: Icons.person_outline,
                          hint: "Usuário",
                          obscure: false,
                          stream: _loginBloc.outEmail,
                          onChanged: _loginBloc.changeEmail,
                        ),
                        CaixaTexto(
                          icon: Icons.lock_outline,
                          hint: "Senha",
                          obscure: true,
                          stream: _loginBloc.outPassword,
                          onChanged: _loginBloc.changePassword,
                        ),
                        SizedBox(height: 32,),
                        StreamBuilder<bool>(
                            stream: _loginBloc.outSubmitValid,
                            builder: (context, snapshot) {
                              return SizedBox(
                                height: 50,
                                child: RaisedButton(
                                  color: Colors.red,
                                  child: Text("Entrar"),
                                  onPressed: snapshot.hasData ? _loginBloc.submit : null, //DESABILITA O BOTÃO SE A STREAM NÃO TIVER DADOS
                                  textColor: Colors.white,
                                  disabledColor: Colors.red.withAlpha(140),
                                ),
                              );
                            }
                        )
                      ],
                    ),
                  )
                ),
              ],
            );
          }
        }
      ),
    );
  }
}