import 'dart:io';

import 'package:fanny_tienda/src/models/domiciliarios_model.dart';
import 'package:fanny_tienda/src/providers/domiciliarios_provider.dart';
import 'package:rxdart/rxdart.dart';

class DomiciliariosBloc{
  DomiciliariosProvider _domiciliariosProvider = new DomiciliariosProvider();

  BehaviorSubject<List<DomiciliarioModel>> _domiciliariosController = BehaviorSubject();

  Stream<List<DomiciliarioModel>> get domiciliariosStream => _domiciliariosController.stream;

  Future<Map<String, dynamic>> crearDomiciliario(String token, DomiciliarioModel domiciliario, File photo, File ccFrontal, File ccAtras)async{
    Map<String, dynamic> domiciliarioResponse = await _domiciliariosProvider.crearDomiciliario(token, domiciliario, photo, ccFrontal, ccAtras);
    return domiciliarioResponse;
  }
  Future<Map<String, dynamic>> cargarDomiciliarios(String token)async{
    Map<String, dynamic> domiciliariosResponse = await _domiciliariosProvider.cargarDomiciliarios(token);
    if(domiciliariosResponse['status'] == 'ok'){
      List<DomiciliarioModel> domiciliariosList = (domiciliariosResponse['domiciliarios'].map((Map<String, dynamic> domiciliarioMap){
        Map<String, dynamic> domiciliario = domiciliarioMap['original']['data_domiciliario'];
        domiciliario['id'] = domiciliarioMap['original']['id'];
        domiciliario['placa'] = domiciliarioMap['original']['placa'];
        domiciliario['tipo_vehiculo'] = domiciliarioMap['original']['tipo_vehiculo'];
        domiciliario['activo'] = domiciliarioMap['original']['activo'];
        return DomiciliarioModel.fromJsonMap(domiciliario);
      }).toList()).cast<DomiciliarioModel>();
      _domiciliariosController.sink.add(domiciliariosList);
    }else{
      print('ocurrió uin error cargando: ${domiciliariosResponse['message']}');
    }
    return domiciliariosResponse;
  }

  void dispose(){
    _domiciliariosController.close();
  }
}