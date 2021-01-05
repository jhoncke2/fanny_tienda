import 'dart:io';

import 'package:fanny_tienda/src/models/domiciliarios_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class DomiciliariosProvider{
  final String _baseDomiciliariosRoute = 'https://codecloud.xyz/api/domiciliarios';
  Future<Map<String, dynamic>> cargarDomiciliarios(String token)async{
    try{
      final response = await http.get(
        _baseDomiciliariosRoute,
        headers: {
          'Authorization':'Bearer $token'
        },
      );
      List<Map<String, dynamic>> decodedResponse = (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      return {
        'status':'ok',
        'domiciliarios':decodedResponse
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> crearDomiciliario(String token, DomiciliarioModel domiciliario, File photo, File ccFrontal, File ccAtras)async{
    Map<String, String> headers = {
      'Authorization':'Bearer $token',
      'Content-Type':'application/x-www-form-urlencoded'
    };
    var request = http.MultipartRequest('POST', Uri.parse('$_baseDomiciliariosRoute'));
    request.files.add(
      http.MultipartFile(
        'photo',
        photo.readAsBytes().asStream(),
        photo.lengthSync(),
        filename: photo.path.split('/').last
      )
    );
    request.files.add(
      http.MultipartFile(
        'cc_frontal',
        ccFrontal.readAsBytes().asStream(),
        ccFrontal.lengthSync(),
        filename: ccFrontal.path.split('/').last
      )
    );
    request.files.add(
      http.MultipartFile(
        'cc_atras',
        ccAtras.readAsBytes().asStream(),
        ccAtras.lengthSync(),
        filename: ccAtras.path.split('/').last
      )
    );
    request.fields.addAll(domiciliario.toJson());
    request.headers.addAll(headers);
    try{
      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'domiciliario':decodedResponse
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }  
    
  }
}