import 'package:fanny_tienda/src/bloc_old/pedidos_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:fanny_tienda/src/widgets/header_widget.dart';
import 'package:flutter/material.dart';
class VentasPage extends StatelessWidget {
  static final route = 'ventas';
  BuildContext context;
  Size size;
  PedidosBloc pedidosBloc;

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    String token = Provider.usuarioBloc(context).token;
    int tiendaId = Provider.tiendaBloc(context).tienda.id;
    pedidosBloc = Provider.pedidosBloc(context);
    pedidosBloc.cargarPedidosAnterioresPorClienteOTienda(token, 'tienda', tiendaId);
    return Scaffold(
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
            height: size.height * 0.01
          ),
          Text(
            'Ventas',
            style: TextStyle(
              fontSize: size.width * 0.065,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
          _crearListviewVentas()
        ],
      ),
    );
  }

  Widget _crearListviewVentas(){
    return Container(
      height: size.height * 0.71,
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: pedidosBloc.pedidosHistorialTiendaStream,
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
    return Container(
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
            'Forma de pago:\nElectrónico',
            style: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.04,
   
            ),
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
    );
  }
}