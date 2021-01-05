import 'dart:io';
class DomiciliariosModel {
  List<DomiciliarioModel> _domiciliarios = new List();

  /* ***********************************************
   *    Pruebas
   *********************************************** */

   /* ***********************************************
   *    fin datos prueba
   *********************************************** */
   
  DomiciliariosModel.fromJsonList(List<dynamic> jsonList){
    if(jsonList==null)
      return;
    jsonList.forEach((element) {
      final domiciliarioActual = DomiciliarioModel.fromJsonMap(element);
      _domiciliarios.add(domiciliarioActual);
    });
  }

  List<DomiciliarioModel> get domiciliarios{
    return _domiciliarios;
  }

}

class DomiciliarioModel{
  int id;
  String name;
  String email;
  int numeroCelular;
  String tipoVehiculo;
  String placa;
  File cedulaCara1;
  File cedulaCara2;
  String cedulaCaraUrl1;
  String cedulaCaraUrl2;
  String photoUrl;
  String mobileToken;
  bool activo;

  DomiciliarioModel({
    this.id,
    this.name,
    this.email,
    this.numeroCelular,
    this.tipoVehiculo,
    this.placa,
    this.cedulaCara1,
    this.cedulaCara2,
    this.photoUrl,
    this.mobileToken,
    this.activo
  });

  DomiciliarioModel.fromJsonMap(Map<String, dynamic> jsonObject){
    id = jsonObject['id'];
    name = jsonObject['name'];
    email = jsonObject['email'];
    numeroCelular = jsonObject['phone'];
    tipoVehiculo = jsonObject['tipo_vehiculo'];
    placa = jsonObject['placa'];
    _formatAvatar(jsonObject['avatar']);
    cedulaCaraUrl1 = jsonObject['cc_frontal'];
    cedulaCaraUrl2 = jsonObject['cc_atras'];
    mobileToken = jsonObject['mobile_token'];
    activo = (jsonObject['activo'] == 0)? false : true;
  }

  Map<String, String> toJson(){
    Map<String, String> jsonObject = {};
    //jsonObject['nombre'] = nombre;
    //jsonObject['email'] = email;
    jsonObject['phone'] = numeroCelular.toString();
    jsonObject['tipo_vehiculo'] = tipoVehiculo;
    jsonObject['placa'] = placa;
    return jsonObject;
  }

  void _formatAvatar(String avatar){
    if(avatar != null)
      this.photoUrl = 'https://codecloud.xyz/$avatar';
  }

}
