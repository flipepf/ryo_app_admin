import 'dart:async';

class LoginValidators {

  final validaEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      if(email.contains("@")){
        sink.add(email);
      } else {
        sink.addError("Insira um email válido!");
      }
    }
  );

  final validaPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        if(password.length >= 4){
          sink.add(password);
        } else {
          sink.addError("Senha deve conter pelo menos 4 caracteres!");
        }
      }
  );
}