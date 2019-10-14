import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ryo_app_admin/validators/loginValidators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//ESTADOS DO LOGIN
enum LoginState {IDLE, LOADING, SUCCESS, FAIL}

class LoginBloc extends BlocBase with LoginValidators{

  final _emailController = BehaviorSubject<String>(); //CONTROLADOR PARA EMAIL
  final _passwordController = BehaviorSubject<String>(); //CONTROLADOR PARA SENHA
  final _stateController = BehaviorSubject<LoginState>(); //COMNTROLADOR DO ESTADO DA AUTENTICAÇÃO DO USUÁRIO

  Stream<String> get outEmail => _emailController.stream.transform(validaEmail);
  Stream<String> get outPassword => _passwordController.stream.transform(validaPassword);
  Stream<bool> get outSubmitValid => Observable.combineLatest2(
      outEmail, outPassword, (a, b) => true
  );
  Stream<LoginState> get outState => _stateController.stream;

  Function(String) get changeEmail => _emailController.sink.add; //TUDO O QUE FOR ENVIADO A FUNÇÃO changeEmail SERÁ ENVIADO AO _emailController.sink.add
  Function(String) get changePassword => _passwordController.sink.add;
  //############################################################################
  StreamSubscription _streamSubscription;
  // MÉTODO CONSTRUTOR QUE SERÁ USADO QUANDO OCORRER ALTERAÇÃO DE ESTADO (USUARIO LOGADO E DESLOGADO)
  LoginBloc(){
    _streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) async { //QUANDO O ESTADO DA AUTORIZAÇÃO MUDAR PASSANDO O USUARIO ATUAL
      if(user != null){
        if(await verifyPrivileges(user)){
          _stateController.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }
  //############################################################################
  void submit(){
    final email = _emailController.value;
    final password = _passwordController.value;

    _stateController.add(LoginState.LOADING);
  //FIREBASE AUTENTICA O USUARIO
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).catchError((e){
      _stateController.add(LoginState.FAIL);
    });
  }
  //######################### VERIFICAR SE O USUARIO POSSUI PRIVILEGIOS DE ADMIN
  Future<bool> verifyPrivileges(FirebaseUser user) async {
    return await Firestore.instance.collection("admins").document(user.uid).get().then((doc){
      if(doc.data != null){
        return true;
      } else {
        return false;
      }
    }).catchError((e){
      return false;
    });
  }
  //############################################################################
  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _streamSubscription.cancel();
  }
}