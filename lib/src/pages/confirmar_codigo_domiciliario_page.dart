import 'package:fanny_tienda/src/bloc_old/confirmation_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/pages/domiciliarios_page.dart';
import 'package:fanny_tienda/src/providers/push_notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:fanny_tienda/src/utils/generic_utils.dart' as utils;
class ConfirmarCodigoDomiciliarioPage extends StatefulWidget {
  static final route = 'confirmar_codigo_domiciliario';
  @override
  _ConfirmarCodigoDomiciliarioPageState createState() => _ConfirmarCodigoDomiciliarioPageState();
}

class _ConfirmarCodigoDomiciliarioPageState extends State<ConfirmarCodigoDomiciliarioPage> {
  BuildContext context;
  Size size;
  ConfirmationBloc confirmationBloc;
  int _domiciliarioId;
  String _domiciliarioMobileToken;
  String _codigoValue;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  PersistentBottomSheetController _bottomSheetController;

  
  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    confirmationBloc = Provider.confirmationBloc(context);
    size = MediaQuery.of(context).size;
    if(_domiciliarioId == null || _domiciliarioMobileToken == null){
      Map<String, dynamic> domiciliarioInformation = ModalRoute.of(context).settings.arguments;
      if(domiciliarioInformation != null){
        _domiciliarioId = domiciliarioInformation['id'];
        _domiciliarioMobileToken = domiciliarioInformation['mobile_token'];
      }
      
    }
      
    return Scaffold(
      key: _scaffoldKey,
      body: _crearElementos(),
    );
  }

  Widget _crearElementos(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Para completar la inscripción del domiciliario, ingresa el código que ha sido enviado al celular de él.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.05,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: size.height * 0.035,
            ),
            _crearInputIntroducirCodigo(),
            SizedBox(
              height: size.height * 0.075,
            ),
            _crearBotonSubmit(),
            SizedBox(
              height: size.height * 0.03,
            ),
            _crearBotonReenviarCodigo(),
          ],
        ),
      ),
    );
  }

  Widget _crearInputIntroducirCodigo(){
    return Container(
      width: size.width * 0.7,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Código',
          icon: Icon(
            Icons.confirmation_number,
          ),
        ),
        onChanged: (String newValue){
          _codigoValue = newValue;
        },
      ),
    );
  }

  Widget _crearBotonSubmit(){
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.075, vertical: size.height * 0.008),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.05)
      ),
      //color: Colors.grey.withOpacity(0.5),
      color: Theme.of(context).primaryColor,
      child: Text(
        'Enviar',
        style: TextStyle(
          fontSize: size.width * 0.048,
          color: Colors.white.withOpacity(0.95)
        ),
      ),
      onPressed: (){
        _confirmarCode();
      },
    );
  }

  Widget _crearBotonReenviarCodigo(){
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.067, vertical: size.height * 0.0085),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.05)
      ),
      //color: Colors.grey.withOpacity(0.5),
      color: Theme.of(context).primaryColor,

      child: Text(
        'Reenviar código',
        style: TextStyle(
          fontSize: size.width * 0.048,
          color: Colors.white.withOpacity(0.95)
        ),
      ),
      onPressed: (){
        _resetCode();
      },
    );
  }

  void _confirmarCode()async{
    Map<String, dynamic> confirmarCodeResponse = await confirmationBloc.enviarCodigoValidarDomiciliario(Provider.usuarioBloc(context).token, _domiciliarioId, _codigoValue);
    if(confirmarCodeResponse['status'] == 'ok'){
      Map<String, dynamic> pushResponse = await Provider.pushNotificationsProvider(context)
      .sendPushNotification(
        _domiciliarioMobileToken, 
        PushNotificationsProvider.notificationTypes[6], 
        {
          'nombre_tienda':Provider.usuarioBloc(context).usuario.name
        }
      );
      Navigator.of(context).pushNamed(DomiciliariosPage.route, arguments: 'codigo_confirmado');
    }
  }

  void _resetCode()async{
    Map<String, dynamic> confirmarCodeResponse = await confirmationBloc.resetCodeDomiciliario(Provider.usuarioBloc(context).token, _domiciliarioId);
    if(confirmarCodeResponse['status'] == 'ok'){
      Map<String, dynamic> pushResponse = await Provider.pushNotificationsProvider(context)
      .sendPushNotification(
        _domiciliarioMobileToken, 
        PushNotificationsProvider.notificationTypes[5], 
        {
          'nombre_tienda':Provider.usuarioBloc(context).usuario.name
        },       
      );
       utils.showBottomSheetByScaffoldState(_scaffoldKey, size, 'Un nuevo código de confirmación ha sido enviado al domiciliario. Comunicate con él');
      
    }
    
  }
}