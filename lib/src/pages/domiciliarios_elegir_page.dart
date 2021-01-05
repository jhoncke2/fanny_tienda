import 'package:fanny_tienda/src/bloc_old/domiciliarios_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/models/domiciliarios_model.dart';
import 'package:fanny_tienda/src/pages/domiciliario_create_page.dart';
import 'package:fanny_tienda/src/pages/solicitud_de_pedidos_page.dart';
import 'package:fanny_tienda/src/providers/push_notifications_provider.dart';
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class DomiciliariosElegirPage extends StatelessWidget {
  static final route = 'domiciliarios_elegir';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  BuildContext context;
  Size size;
  DomiciliariosBloc domiciliariosBloc;

  Map<String, dynamic> pedido;
  
  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    domiciliariosBloc = Provider.domiciliariosBloc(context);
    domiciliariosBloc.cargarDomiciliarios(Provider.usuarioBloc(context).token);
    pedido = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      body: _crearElementos(),
    );
  }

  Widget _crearElementos(){
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            color: Colors.grey.withOpacity(0.9),
            iconSize: size.width * 0.055,
            icon: Icon(
              Icons.arrow_back_ios
            ),
            onPressed: (){
              Navigator.of(context).pushNamed(SolicitudDePedidosPage.route);
            },
          ),
          Text(
            'Elige un domiciliario para que entregue el pedido',
            style: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.045
            ),
          ),     
          Container(
            height: size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                  width: size.width * 0.001
              ),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(size.width * 0.02),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: size.width * 0.01,
                  spreadRadius: size.width * 0.01,
                  offset: Offset(
                    size.width * 0.005,
                    size.height * 0.002
                  )
                )
              ]
            ),
            child: StreamBuilder(
              stream: domiciliariosBloc.domiciliariosStream,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.active){
                  if(snapshot.hasData){
                    return ListView(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      children: ((snapshot.data as List).cast<DomiciliarioModel>()).map((DomiciliarioModel domiciliario){
                        return _crearDomiciliarioCard(domiciliario);
                      }).toList(),
                    );
                  }else{
                    return Container();
                  }
                }else{
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearDomiciliarioCard(DomiciliarioModel domiciliario){
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: size.width * 0.0005
                )
              )
            ),
            
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FadeInImage(
                  image:(domiciliario.photoUrl != null)? NetworkImage(domiciliario.photoUrl) : AssetImage('assets/placeholder_images/user_icon.png'),
                  placeholder: AssetImage('assets/placeholder_images/user_icon.png'),
                  height: size.height * 0.05,
                  width: size.width * 0.1,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: size.width * 0.08,
                ),
                Text(
                  domiciliario.name,
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Colors.black
                  ),
                )

              ],
            ),
          ),
          (!domiciliario.activo?
            Container(
              color: Colors.white.withOpacity(0.5),
              height: size.height * 0.1,
              width: size.width * 0.8,
            )
            :Container()
          ),
        ],
      ),
      onTap: (){
        Provider.pushNotificationsProvider(context).sendPushNotification(
          domiciliario.mobileToken, 
          PushNotificationsProvider.notificationTypes[3], 
          {
            'pedido_id':pedido['id'],
            'cliente_mobile_token':pedido['cliente']['mobile_token'],
            'nombre_cliente':pedido['cliente']['name'],
            'tienda_mobile_token': Provider.usuarioBloc(context).usuario.mobileToken,
            'nombre_tienda':Provider.usuarioBloc(context).usuario.name,
            'direccion_domicilio':'${pedido['direccion']['ciudad']}, ${pedido['direccion']['direccion']}'
          }    
        );
        Navigator.of(context).pushNamed(SolicitudDePedidosPage.route);
      },
    );
  }

  Widget _crearBotonAgregarDomiciliario(){
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.075, vertical: size.height * 0.008),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.05)
      ),
      //color: Colors.grey.withOpacity(0.5),
      color: Theme.of(context).primaryColor,
      child: Text(
        'Agregar nuevo domiciliario',
        style: TextStyle(
          fontSize: size.width * 0.048,
          color: Colors.white.withOpacity(0.95)
        ),
      ),
      onPressed: (){
        Navigator.of(context).pushNamed(DomiciliarioCreatePage.route);
      },
    );
  }
}