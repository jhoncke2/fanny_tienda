import 'package:fanny_tienda/src/bloc_old/productos_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/models/productos_model.dart';
import 'package:flutter/material.dart';
import 'package:fanny_tienda/src/pages/producto_activar_programado_page.dart';
// ignore: must_be_immutable
class ProductoTiendaCardWidget extends StatefulWidget {

  ProductoModel producto;
  ProductoTiendaCardWidget(this.producto);

  @override  
  _ProductoTiendaCardWidgetState createState() => _ProductoTiendaCardWidgetState();
}

class _ProductoTiendaCardWidgetState extends State<ProductoTiendaCardWidget> {
  BuildContext context;
  Size size;

  ProductosBloc productosBloc;

  bool _activoTemporal;
  @override
  void initState() { 
    super.initState();
    _activoTemporal = true;
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    productosBloc = Provider.productosBloc(context);
    if(widget.producto.tipo == 'normal')
      return _crearProductoVentaDiaria();
    else
      return _crearProductoProgramado();
  }

  Widget _crearProductoVentaDiaria(){
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.04
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: size.width * 0.001
          )
        )
      ),
      width: size.width * 0.7,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Row(
             children: <Widget>[
               FadeInImage(
                 placeholder: AssetImage('assets/placeholder_images/productos_gifs/gif_cargando_4.gif'),
                 image: NetworkImage(widget.producto.photos[0]['url']),
                 height: size.height * 0.15,
                 width: size.width * 0.45,
                 fit: BoxFit.fill,
               ),
               Switch(
                 value: widget.producto.activo,
                 inactiveThumbColor: Colors.white,
                 activeColor: Colors.white,
                 focusColor: Colors.white,
                 activeTrackColor: Theme.of(context).primaryColor,
                 inactiveTrackColor: Colors.grey.withOpacity(0.6),
                 onChanged: (bool newValue){
                   widget.producto.activo = newValue;
                   setState(() {
                     
                   });
                   _activarODesactivarProducto();
                 },
               )
             ],
           ),
           SizedBox(
             height: size.height * 0.005,
           ),
           Text(
             (widget.producto.tipo == 'normal')? 'Producto de venta diaria': widget.producto.tipo,
             style: TextStyle(
               fontSize: size.width * 0.047,
               color: Colors.black.withOpacity(0.9)
             ),
           ),
           Text(
             widget.producto.name,
             style: TextStyle(
               fontSize: size.width * 0.045,
               color: Colors.black.withOpacity(0.9)
             ),
           ),
           Text(
             'Cantidad disponible: ${(widget.producto.stock??10)}',
             style: TextStyle(
               fontSize: size.width * 0.041,
               color: Colors.black.withOpacity(0.9)
             ),
           )
         ],
       ),
    );
  }

  Future<void> _activarODesactivarProducto()async{
    Map<String, dynamic> activarODesactivarResponse = await productosBloc.activarODesactivarProducto(
      Provider.usuarioBloc(context).token, 
      widget.producto.id
    );
    if(activarODesactivarResponse['status'] == 'ok')
      productosBloc.cargarProductosTienda(Provider.tiendaBloc(context).tienda.id);
    else{
      widget.producto.activo = !widget.producto.activo;
      setState(() {
        
      });
    }
  }

  Widget _crearProductoProgramado(){
    return Container(
      height: size.height * 0.335,
      width: size.width * 0.7,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _crearCardProductoProgramado(),
          _crearBotonesEditarYEliminar(),
        ],
      ),
    );
  }

  Widget _crearCardProductoProgramado(){
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.04
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: size.width * 0.001
          )
        )
      ),
      width: size.width * 0.7,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Row(
             children: <Widget>[
               FadeInImage(
                 placeholder: AssetImage('assets/placeholder_images/productos_gifs/gif_cargando_4.gif'),
                 image: NetworkImage(widget.producto.photos[0]['url']),
                 height: size.height * 0.15,
                 width: size.width * 0.45,
                 fit: BoxFit.fill,
               )
             ],
           ),
           SizedBox(
             height: size.height * 0.005,
           ),
           Text(
             (widget.producto.tipo == 'normal')? 'Producto de venta diaria': widget.producto.tipo,
             style: TextStyle(
               fontSize: size.width * 0.047,
               color: Colors.black.withOpacity(0.9)
             ),
           ),
           Text(
             widget.producto.name,
             style: TextStyle(
               fontSize: size.width * 0.045,
               color: Colors.black.withOpacity(0.9)
             ),
           ),
           Text(
             'Cantidad disponible: ${(widget.producto.stock??10)}',
             style: TextStyle(
               fontSize: size.width * 0.041,
               color: Colors.black.withOpacity(0.9)
             ),
           )
         ],
       ),
    );
  }

  Widget _crearBotonesEditarYEliminar(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              color: Theme.of(context).secondaryHeaderColor,
              iconSize: size.width * 0.085,
              icon: Icon(
                Icons.edit,
              ),
              onPressed: (){
                Navigator.of(context).pushNamed(ProductoActivarProgramadoPage.route, arguments: widget.producto);
              },
            ),
            SizedBox(
              width: size.height * 0.005,
            ),
            Container(
              width: size.width * 0.001,
              height: size.height * 0.04,
              color: Colors.black,
            ),
            SizedBox(
              width: size.height * 0.005,
            ),
            IconButton(
              color: Colors.redAccent,
              iconSize: size.width * 0.085,
              icon: Icon(
                Icons.delete_outline
              ),
              onPressed: (){

              },
            )
          ],
        ),
        Container(

        )
      ],
    );
  }
}