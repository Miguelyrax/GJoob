import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:master_jobz/helpers/environment.dart';
import 'package:master_jobz/models/auth_response.dart';
import 'package:master_jobz/models/capacitacion_response.dart';

import 'package:master_jobz/models/empleo_response.dart';
import 'package:master_jobz/models/habilidad_response.dart';
import 'package:master_jobz/models/usuario.dart';
import 'package:master_jobz/models/usuario_response.dart';

class Auth with ChangeNotifier{
  Usuario? usuario;

  final _storage = FlutterSecureStorage();

  static Future<String?> getToken() async{
  final _storage = FlutterSecureStorage();
  final token = await _storage.read(key: 'token');
  return token;
  }
  
  Future<bool> login(String user, String password)async{
  final url = Uri.parse('${Environment.baseURL}/auth/');
  final data = {
    "email":user,
    "password":password
  };
  final resp = await http.post(url, headers: {
    'Content-type':'application/json'
  },
  body: jsonEncode(data));

  if(resp.statusCode == 200){
    final authResponse = authResponseFromJson(resp.body);
    usuario = authResponse.usuario;
    await guardarToken(authResponse.token); 
    return true;
  }
  return false;
}
  Future<bool> register(String nombre, String apellido,String email,String password,)async{
  final url = Uri.parse('${Environment.baseURL}/auth/register/');
  final data = {
    "nombre":nombre,
    "apellido":apellido,
    "email":email,
    "password":password,
  };
  final resp = await http.post(url, headers: {
    'Content-type':'application/json'
  },
  body: jsonEncode(data));
  if(resp.statusCode == 200){
    final authResponse = authResponseFromJson(resp.body);
    usuario = authResponse.usuario;
    await guardarToken(authResponse.token); 
    return true;
  }
  return false;
}
  Future<bool> renew()async{
  final url = Uri.parse('${Environment.baseURL}/auth/renew');
  final String? token = await _storage.read(key: 'token');
  final resp = await http.get(url, headers: {
    'Content-type':'application/json',
    'x-token': token.toString()
  } 
  );
  
  if(resp.statusCode == 200){
    final authResponse = authResponseFromJson(resp.body);
    usuario = authResponse.usuario;
    await guardarToken(authResponse.token); 
    return true;
  }
  return false;
}

  Future guardarToken(String token) async{
    return await _storage.write(key: 'token', value: token);
 
  }
  Future logout() async{
    return await _storage.delete(key: 'token');
  }

  Future newHabilidad(String habilidad)async{
    final data = {
      "habilidad":habilidad
    };
    final url = Uri.parse('${Environment.baseURL}/habilidad/');
    final String? token = await _storage.read(key: 'token');
    final resp = await http.post(url, headers: {
      'Content-type':'application/json',
      'x-token':token.toString()
    },
    body: jsonEncode(data));

    if(resp.statusCode == 200){
      final habilidadResponse = habilidadResponseFromJson(resp.body);
      usuario!.habilidades.add(habilidadResponse.habilidad);
      notifyListeners();
      return true;
    }
    return false;
  }
  Future editHabilidad(String habilidad,String id)async{
    final data = {
      "habilidad":habilidad
    };
    final url = Uri.parse('${Environment.baseURL}/habilidad/$id');
    final String? token = await _storage.read(key: 'token');
    final resp = await http.put(url, headers: {
      'Content-type':'application/json',
      'x-token':token.toString()
    },
    body: jsonEncode(data));

    if(resp.statusCode == 200){
      final habilidadResponse = habilidadResponseFromJson(resp.body);
      usuario!.habilidades.add(habilidadResponse.habilidad);
      notifyListeners();
      return true;
    }
    return false;
  }
  Future deleteHabilidad(String id)async{

    final url = Uri.parse('${Environment.baseURL}/habilidad/$id');
    final String? token = await _storage.read(key: 'token');
    final resp = await http.delete(url, headers: {
      'Content-type':'application/json',
      'x-token':token.toString()
    });

    if(resp.statusCode == 200){
      usuario!.habilidades.removeWhere((element) => element.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }
  Future newEmpleo(String empresa, String cargo, String description, DateTime inicio, DateTime termino)async{
    final data = {
      "empresa":empresa,
      "cargo":cargo,
      "description":description,
      "inicio":inicio.toIso8601String(),
      "final":termino.toIso8601String(),
    };
    final url = Uri.parse('${Environment.baseURL}/empleo/');
    final String? token = await _storage.read(key: 'token');
    final resp = await http.post(url, headers: {
      'Content-type':'application/json',
      'x-token':token.toString()
    },
    body: jsonEncode(data));

    if(resp.statusCode == 200){
      final empleoResponse = empleoResponseFromJson(resp.body);
      usuario!.empleos.add(empleoResponse.empleo);
      notifyListeners();
      return true;
    }
    return false;
  }
  Future editEmpleo(String empresa, String cargo, String description,DateTime inicio, DateTime termino, String id)async{
    final data = {
      "empresa":empresa,
      "cargo":cargo,
      "description":description,
      "inicio":inicio.toIso8601String(),
      "final":termino.toIso8601String(),
    };
    final url = Uri.parse('${Environment.baseURL}/empleo/$id');
    final String? token = await _storage.read(key: 'token');
    final resp = await http.put(url, headers: {
      'Content-type':'application/json',
      'x-token':token.toString()
    },
    body: jsonEncode(data));
    if(resp.statusCode == 200){
      final empleoResponse = empleoResponseFromJson(resp.body);
      int index = usuario!.empleos.indexWhere((element) => element.id == id);
      this.usuario!.empleos[index] = empleoResponse.empleo;
      
      notifyListeners();
      return true;
    }
    return false;
  }
  
  Future deleteEmpleo(String id)async{

    final url = Uri.parse('${Environment.baseURL}/empleo/$id');
    final String? token = await _storage.read(key: 'token');
    final resp = await http.delete(url, headers: {
      'Content-type':'application/json',
      'x-token':token.toString()
    });

    if(resp.statusCode == 200){
      usuario!.empleos.removeWhere((element) => element.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }
  Future newEducacion(String educacion, String tema, DateTime inicio, DateTime termino)async{
    final data = {
      "establecimiento":educacion,
      "tema":tema,
      "inicio":inicio.toIso8601String(),
      "final":termino.toIso8601String()
    };
    final url = Uri.parse('${Environment.baseURL}/educacion/');
    final String? token = await _storage.read(key: 'token');
    final resp = await http.post(url, headers: {
      'Content-type':'application/json',
      'x-token':token.toString()
    },
    body: jsonEncode(data));
    if(resp.statusCode == 200){
      final capacitacionResponse = capacitacioneResponseFromJson(resp.body);
      usuario!.capacitaciones.add(capacitacionResponse.educacion);
      notifyListeners();
      return true;
    }
    return false;
  }
  Future editEducacion(String educacion, String tema,DateTime inicio, DateTime termino, String id)async{
    final data = {
      "establecimiento":educacion,
      "tema":tema,
      "inicio":inicio.toIso8601String(),
      "final":termino.toIso8601String()
    };
    final url = Uri.parse('${Environment.baseURL}/educacion/$id');
    final String? token = await _storage.read(key: 'token');
    final resp = await http.put(url, headers: {
      'Content-type':'application/json',
      'x-token':token.toString()
    },
    body: jsonEncode(data));
    if(resp.statusCode == 200){
      final capacitacionResponse = capacitacioneResponseFromJson(resp.body);
      int index = usuario!.capacitaciones.indexWhere((element) => element.id == id);
      this.usuario!.capacitaciones[index] = capacitacionResponse.educacion;
      notifyListeners();
      return true;
    }
    return false;
  }
  
  Future deleteEducacion(String id)async{

    final url = Uri.parse('${Environment.baseURL}/educacion/$id');
    final String? token = await _storage.read(key: 'token');
    final resp = await http.delete(url, headers: {
      'Content-type':'application/json',
      'x-token':token.toString()
    });

    if(resp.statusCode == 200){
      usuario!.capacitaciones.removeWhere((element) => element.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }
  Future editUsuario(String nombre, String id, String apellido, String email, String telefono, String profesion)async{
    final data = {
      "nombre":nombre,
      "apellido":apellido,
      "email":email,
      "telefono":telefono,
      "profesion":profesion
    };
    final url = Uri.parse('${Environment.baseURL}/usuarios/$id');
    final String? token = await _storage.read(key: 'token');
    final resp = await http.put(url, headers: {
      'Content-type':'application/json',
      'x-token':token.toString()
    },
    body: jsonEncode(data)
    );
    if(resp.statusCode == 200){
      final usuarioResponse = usuarioResponseFromJson(resp.body);
      usuario = usuarioResponse.usuario;
      notifyListeners();
      return true;
      
    }
    return false;
  }

}

