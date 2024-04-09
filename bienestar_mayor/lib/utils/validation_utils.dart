import 'package:email_validator/email_validator.dart';

class ValidationUtils{
  static String? validateTextNotEmpty(String? value, String textEmpty){
    if(value==null || value.isEmpty){
      return textEmpty;
    }else{
      return null;
    }
  }

  static String? validateEmail(String? value, String textEmpty, String textInvalidEmail){
    if(value==null || value.isEmpty){
      return textEmpty;
    }else if(!EmailValidator.validate(value.trim())){
      return textInvalidEmail;
    }else{
      return null;
    }
  }

}