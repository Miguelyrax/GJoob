

import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {

    GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String usuario = '';
  String password = '';
  String nombre = '';
  String apellido = '';
  String email = '';
  String password2 = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value){
    this._isLoading = value;
    notifyListeners();
  }

  bool isValidForm(){

    return formKey.currentState?.validate() ?? false;

  }


}