import 'package:fanny_tienda/src/bloc_old/domiciliarios_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/pedidos_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/models/domiciliarios_model.dart';
import 'package:fanny_tienda/src/pages/domiciliarios_elegir_page.dart';
import 'package:fanny_tienda/src/providers/push_notifications_provider.dart';
import 'package:fanny_tienda/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:fanny_tienda/src/widgets/header_widget.dart';
import 'package:fanny_tienda/src/utils/generic_utils.dart' as utils;
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class SolicitudDePedidosPage extends StatelessWidget {
  static final route = 'solicitud_de_pedidos';
  BuildContext context;
  Size size;
  PedidosBloc pedidosBloc;
  DomiciliariosBloc domiciliariosBloc;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    String token = Provider.usuarioBloc(context).token;
    int tiendaId = Provider.tiendaBloc(context).tienda.id;
    pedidosBloc = Provider.pedidosBloc(context);
    pedidosBloc.cargarPedidosAnterioresPorClienteOTienda(token, 'tienda', tiendaId);
    domiciliariosBloc = Provider.domiciliariosBloc(context);
    return Scaffold(
      key: _scaffoldKey,
      body: _crearElementos(),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Widget _crearElementos(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.06,
          ),
          HeaderWidget(),
          SizedBox(
            height: size.height * 0.015
          ),
          Text(
            'Solicitud de pedidos',
            style: TextStyle(
              fontSize: size.width * 0.065,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
          _crearListviewPedidos()
        ],
      ),
    );
  }

  Widget _crearListviewPedidos(){
    return Container(
      height: size.height * 0.7,
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: pedidosBloc.pedidosSinRevisarTiendaStream,
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              List<Widget> columnasProductosPedidos=[];
              List<Map<String, dynamic>> pedidos = snapshot.data;
              for(int i = 0; i < pedidos.length; i++){
                columnasProductosPedidos.add(_crearPedidoWidget(snapshot.data[i], i));
              }
              return ListView(
                children: columnasProductosPedidos,
              );
            }else
              return Container();
          }else{
            return Container();
          }
        },
      )
    );
  }

  Widget _crearPedidoWidget(Map<String, dynamic> pedido, int pedidoIndex){
    return GestureDetector(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Pedido #${pedidoIndex+1}',
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: size.width * 0.043,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: size.height * 0.008
            ),
            Row(
              children: <Widget>[
                Column(
                  children: ((pedido['products'] as List).cast<Map<String, dynamic>>()).map((Map<String, dynamic> producto){
                    return _crearInformacionProducto(producto);
                  }).toList(),
                )
              ],
            ),
            Container(
              height: size.height * 0.0005,
              color: Colors.black,
            ),
            SizedBox(
              height: size.height * 0.008,
            ),
            Text(
              'Nombre cliente:\nElsa Camuelas',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
   
              ),
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
            Container(
              height: size.height * 0.0003,
              color: Colors.black,
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
            Text(
              'Dirección:\nAv. calle 40 # 13 - 73',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
   
              ),
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
            Container(
              height: size.height * 0.0003,
              color: Colors.black,
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
            Text(
              'Forma de pago:\n${Provider.tiendaBloc(context).tienda.tipoDePago}',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.04,
   
              ),
            ),
            SizedBox(
              height: size.height * 0.008,
            ),
            SizedBox(
              height: size.height * 0.008,
            ),
            Container(
              height: size.height * 0.0005,
              color: Colors.black,
            ),
            SizedBox(
              height: size.height * 0.05,
            )
            
          ],
        ),
      ),
      onTap: (){
        //_mostrarDomiciliariosList('${pedido['direccion']['ciudad']}, ${pedido['direccion']['direccion']}');
        Navigator.of(context).pushNamed(DomiciliariosElegirPage.route, arguments: pedido);
      },
    );
  }

  void _mostrarDomiciliariosList(String direccion)async{
    showDialog(
      context: context,
      builder: (BuildContext appContext){
        return Dialog(
          child: Container(
            child: Column(
              children: <Widget>[
                Text(
                  'Elige un domiciliario',
                ),
                Container(
                  height: size.height * 0.45,
                  child: StreamBuilder(
                    stream: domiciliariosBloc.domiciliariosStream,
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.connectionState == ConnectionState.active){
                        if(snapshot.hasData){
                          return ListView(
                            children: ((snapshot.data as List).cast<DomiciliarioModel>()).map((DomiciliarioModel domiciliario){
                                return _crearDomiciliarioCard(domiciliario, direccion);
                              }
                            ).toList()
                          );
                        }else{
                          return Container();
                        }
                      }else{
                        return Container();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _crearDomiciliarioCard(DomiciliarioModel domiciliario, String direccion){
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
                  image: NetworkImage(domiciliario.photoUrl),
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
      onTap: ((domiciliario.activo)?
        (){
           utils.showBottomSheetByScaffoldState(_scaffoldKey, size, 'se ha enviado la solicitud de pedido al domiciliario.');
           Provider.pushNotificationsProvider(context).sendPushNotification(
             domiciliario.mobileToken, 
             PushNotificationsProvider.notificationTypes[3], 
             {
               'nombre_tienda':Provider.usuarioBloc(context).usuario.name,
               'direccion_domicilio':direccion
             }
            );
        }
      : null
      ),
    );
  }

  Widget _crearInformacionProducto(Map<String, dynamic> producto){
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: size.width * 0.001
              )
            )
          ),
          height: size.height * 0.058,
          width: size.width * 0.4,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: size.height * 0.058,
              maxWidth: size.width * 0.4
            ),
            child: Text(
              'Nombre de producto:\n${producto['data_product'].name}',
              style: TextStyle(
                fontSize: size.width * 0.034
              ),
            ),
          ),
        ),
        Container(
          color: Colors.black,
          height: size.height * 0.035
          ,
          width: size.width * 0.001,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: size.width * 0.001
              )
            )
          ),
          height: size.height * 0.058,
          width: size.width * 0.23,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: size.height * 0.058,
              maxWidth: size.width * 0.23
            ),
            child: Text(
              'Cantidad:\n${producto['cantidad']}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.034
              ),
            ),
          ),
        ),
        Container(
          color: Colors.black,
          height: size.height * 0.035
          ,
          width: size.width * 0.001,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: size.width * 0.001
              )
            )
          ),
          height: size.height * 0.058,
          width: size.width * 0.25,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: size.height * 0.058,
              maxWidth: size.width * 0.25
            ),
            child: Text(
              'Valor:\n${producto['precio']}',
              style: TextStyle(
                fontSize: size.width * 0.034
              ),
            ),
          ),
        ),
      ],
    );
  }
}