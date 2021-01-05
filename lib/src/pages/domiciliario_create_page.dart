import 'dart:io';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/models/domiciliarios_model.dart';
import 'package:fanny_tienda/src/pages/confirmar_codigo_domiciliario_page.dart';
import 'package:fanny_tienda/src/providers/push_notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:fanny_tienda/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:fanny_tienda/src/widgets/header_widget.dart';
import 'package:fanny_tienda/src/utils/generic_utils.dart' as utils;
class DomiciliarioCreatePage extends StatefulWidget {
  static final route = 'domiciliario_create';
  @override
  _DomiciliarioCreatePageState createState() => _DomiciliarioCreatePageState();
}

class _DomiciliarioCreatePageState extends State<DomiciliarioCreatePage> {
  BuildContext context;
  Size size;

  File _avatar;
  String _name;
  String _email;
  int _phone;
  String _tipoVehiculo;
  String _placa;

  File _copiaCedula1;
  File _copiaCedula2;
  int _numeroDeCedulasAdjuntas;

  @override
  void initState() { 
    super.initState();
    _numeroDeCedulasAdjuntas = 0;
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: _crearElementos(),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Widget _crearElementos(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.06,
            ),
            HeaderWidget(),
            Container(
              height: size.height * 0.76,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.0
              ),
              child: ListView(
                children: <Widget>[         
                  _crearTitulo(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _crearAvatar(),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  _crearEspacioDato('name', 'Nombre completo'),
                  _crearEspacioDato('phone', 'Correo'),
                  _crearEspacioDato('phone', 'Número de celular'),
                  _crearEspacioDato('tipo_vehiculo', 'Tipo de vehículo'),
                  _crearEspacioDato('placa', 'Placa'),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _crearAdjuntarImagen(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _crearBotonSubmmit()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearTitulo(){
    return Center(
      child: Text(
        'Domiciliario',
        style: TextStyle(
          color: Colors.black.withOpacity(0.8),
          fontWeight: FontWeight.bold,
          fontSize: size.width * 0.07
        ),
      ),
    );
  }

  Widget _crearAvatar(){
    return Center(
      child: GestureDetector(
        child: ClipOval(
          child: ((_avatar == null) ? Image.asset(
            'assets/placeholder_images/user_icon.png',
            width: size.width * 0.3,
            height: size.height * 0.15,
            fit: BoxFit.cover
          )
          :Image.file(
            _avatar,
            width: size.width * 0.3,
            height: size.height * 0.15,
            fit: BoxFit.cover
          )),
        ),
        onTap: (){
          _adjuntarImagen('avatar');
       },
      ),
    );
  }

  Widget _crearEspacioDato(String nombreDato, String dato){
    String datoInicial = '';
    switch(nombreDato){
      case 'name':
        datoInicial = _name??'';
        break;
      case 'email':
        datoInicial = _email??'';
        break;
      case 'phone':
        datoInicial = (_phone!=null)?_phone.toString():'';
        break;
      case 'tipo_vehiculo':
        datoInicial = _tipoVehiculo??'';
        break;
      case 'placa':
        datoInicial = _placa??'';
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          dato,
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.normal
          ),
        ),
        SizedBox(
          height: size.height * 0.005,
        ),
        Container(
          width: size.width * 0.8,
          height: size.height * 0.047,
          child: TextFormField(
            initialValue: datoInicial,
            style: TextStyle(
              color: Colors.black
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: size.height * 0.0025,
                horizontal: size.width * 0.025
              ),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.25),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.001,
                  color: Colors.green.withOpacity(0.9),
                ),
                  borderRadius: BorderRadius.circular(
                  size.width * 0.1
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.85),
                  width: size.width * 0.0001
                ),
                borderRadius: BorderRadius.circular(
                  size.width * 0.1
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.85),
                  width: size.width * 0.0001
                ),
                borderRadius: BorderRadius.circular(
                  size.width * 0.1
                ),
              )
            ),
            onChanged: (String newValue){
              switch(nombreDato){
                case 'name':
                  _name = newValue;
                  break;
                case 'email':
                  _email = newValue;
                  break;
                case 'phone':
                  _phone = int.parse(newValue);
                  break;
                case 'tipo_vehiculo':
                  _tipoVehiculo = newValue;
                  break;
                case 'placa':
                  _placa = newValue;
                  break;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _crearAdjuntarImagen(){
    return Row(
      children: <Widget>[
        Text(
          'Adjuntar copias de cédula ',
          style: TextStyle(
            
            fontSize: size.width * 0.04,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        SizedBox(
          width: size.width * 0.03,
        ),
        ((_numeroDeCedulasAdjuntas >= 1)?
        Image.file(
          _copiaCedula1,
          width: size.width * 0.08,
          height: size.height * 0.03,
          fit: BoxFit.cover
        )
        :Container()),
        SizedBox(
          width: size.width * 0.02,
        ),
        ((_numeroDeCedulasAdjuntas == 2)?
        Image.file(
          _copiaCedula2,
          width: size.width * 0.08,
          height: size.height * 0.03,
          fit: BoxFit.cover
        )
        :Container()),
        SizedBox(
          width: size.width * 0.02,
        ),
        (
          (_numeroDeCedulasAdjuntas < 2)?
          IconButton(
            icon: Icon(
              Icons.insert_drive_file,
              color: Colors.grey.withOpacity(0.8),
              size: size.width * 0.085,
            ),
            onPressed: (){
              _adjuntarImagen((_numeroDeCedulasAdjuntas == 0)? 'cedula1' : 'cedula2');
              _numeroDeCedulasAdjuntas++;
            }
          )
          : Container()
        )
      ],
    );
  }

  void _adjuntarImagen( String tipoImagen)async{
    try{
      Map<String, File> imagenMap = {};
      await utils.tomarFotoDialog(context, size, imagenMap);
      if(imagenMap['imagen'] != null){
        switch(tipoImagen){
          case 'avatar':
            _avatar = imagenMap['imagen'];
            break;
          case 'cedula1':
            _copiaCedula1 = imagenMap['imagen'];
            break;
          case 'cedula2':
            _copiaCedula2 = imagenMap['imagen'];
            break;
        }
      }
    }catch(err){
      print(err);
    }
    setState(() {
      
    });
  }

  Widget _crearBotonSubmmit(){
    return Center(
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.04),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.055,
          vertical: size.height * 0.002
        ),
        color: Colors.grey.withOpacity(0.62),
        child: Text(
          'Aceptar',
          style: TextStyle(
            fontSize: size.width * 0.05,
            color: Colors.black.withOpacity(0.8)
          ),
        ),
        onPressed: (){
          _guardarDatos();
        },
      ),
    );
  }

  Future<void> _guardarDatos()async{
    print('guardando:\n$_name\n$_email\n$_phone\n$_tipoVehiculo\n$_placa');
    DomiciliarioModel domiciliario = DomiciliarioModel();
    domiciliario.numeroCelular = _phone;
    domiciliario.tipoVehiculo = _tipoVehiculo;
    domiciliario.placa = _placa;
    Map<String, dynamic> domiciliarioCreateResponse = await Provider.domiciliariosBloc(context).crearDomiciliario(
      Provider.usuarioBloc(context).token, 
      domiciliario,
      _avatar,
      _copiaCedula1,
      _copiaCedula2
    );
    if(domiciliarioCreateResponse['status'] == 'ok'){
      await Provider.pushNotificationsProvider(context).sendPushNotification(
        domiciliarioCreateResponse['domiciliario']['data_domiciliario']['mobile_token'],
        PushNotificationsProvider.notificationTypes[4], 
        {
          'nombre_tienda':Provider.usuarioBloc(context).usuario.name,
        }
      );
      Navigator.of(context).pushNamed(ConfirmarCodigoDomiciliarioPage.route, arguments: {
        'id':domiciliarioCreateResponse['domiciliario']['id'],
        'mobile_token':domiciliarioCreateResponse['domiciliario']['data_domiciliario']['mobile_token']
      });
    }
  }
}