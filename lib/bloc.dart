import 'dart:async';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validators implements BaseBloc{

  final _emailController = StreamController<String>();
  final _passController = StreamController<String>();

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passChanged => _passController.sink.add;

  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get pass => _passController.stream.transform(passValidator);

  Stream<bool> get submitCheck => Rx.combineLatest2(email,pass, (e,p)=> true);

  submit(){

  }

  @override
  void dispose(){
    _emailController?.close();
    _passController?.close();
  }

}


abstract class BaseBloc{
  void dispose();
}



mixin Validators{
  var emailValidator = StreamTransformer<String,String>.fromHandlers(
      handleData:( email, sink){
      if(email.contains("@")){
        sink.add(email);
  }
      else{
        sink.addError("Email is not valid");
  }
  }
  );

  var passValidator = StreamTransformer<String,String>.fromHandlers(
      handleData:( pass, sink){
        if(pass.length>4){
          sink.add(pass);
        }
        else{
          sink.addError("Password length Should be greater than 4 chars");
        }
      }
  );
}