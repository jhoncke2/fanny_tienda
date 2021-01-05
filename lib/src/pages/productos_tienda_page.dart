import 'package:fanny_tienda/src/bloc_old/productos_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/bloc_old/tienda_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_tienda/src/models/productos_model.dart';
import 'package:fanny_tienda/src/pages/producto_create_page.dart';
import 'package:fanny_tienda/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:fanny_tienda/src/widgets/header_widget.dart';
import 'package:fanny_tienda/src/widgets/productos/producto_tienda_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductosTiendaPage extends StatelessWidget {
  static final route = 'productos_tienda';

  BuildContext context;
  Size size;
  UsuarioBloc usuarioBloc;
  ProductosBloc productosBloc;
  TiendaBloc tiendaBloc;
  
  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    productosBloc = Provider.productosBloc(context);
    usuarioBloc = Provider.usuarioBloc(context);
    tiendaBloc = Provider.tiendaBloc(context);
    
    size = MediaQuery.of(context).size;

    productosBloc.cargarProductosTienda(tiendaBloc.tienda.id);


    return Scaffold(
      body: _crearElementos(context, size, productosBloc),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Widget _crearElementos(BuildContext context, Size size, ProductosBloc productosBloc){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: size.height * 0.065,
          ),
          HeaderWidget(),
          SizedBox(
            height: size.height * 0.03,
          ),
          _crearTitulo(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          _crearBotonAgregar(context, size),
          SizedBox(
            height: size.height * 0.015,
          ),
          _crearListviewProductos(size, productosBloc),
        ],
      ),
    );
  }

  Widget _crearTitulo(Size size){
    return Text(
      'Productos',
      style: TextStyle(
        color: Colors.black.withOpacity(0.8),
        fontSize: size.width * 0.06,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _crearBotonAgregar(BuildContext context, Size size, ){
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.04),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.006
      ),
      color: Theme.of(context).primaryColor.withOpacity(0.85),
      child: Text(
        'Crear nuevo producto',
        style: TextStyle(
          fontSize: size.width * 0.05,
          color: Colors.white.withOpacity(0.8)
        ),
      ),
      onPressed: (){
        _crearProducto(context);
      },
    );
  }

  Widget _crearListviewProductos(Size size, ProductosBloc productosBloc){
    return StreamBuilder(
      stream: productosBloc.productosTiendaStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.hasData){
          List<Widget> items = snapshot.data.map((ProductoModel producto){
            return ProductoTiendaCardWidget(producto);
          }).toList();

          return Container(
            height: size.height * 0.58,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.12
              ),
              children: items,
            ),
          );
        }else{
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  void _crearProducto(BuildContext context){
    Navigator.of(context).pushNamed(ProductoCreatePage.route);
  }

}


/*
Widget _crearFiltros(BuildContext context, Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: size.height * 0.0, bottom: 0.0),
          margin: EdgeInsets.only(right: size.height * 0.035),
          height: size.height * 0.055,
          width: size.width * 0.5,
          decoration: BoxDecoration(
           // borderRadius: BorderRadius.circular(10.0),
           borderRadius:BorderRadius.only(
             topLeft: Radius.circular(8.0),
             topRight: Radius.circular(8.0),

           ),
            color: Colors.white
            //color: Theme.of(context).backgroundColor,
          ),
          child: TextField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              suffixIcon: Icon(
                Icons.search, 
              ),
              hintText: 'Buscar',
            ),
            onChanged: (String value){
              
            },
          ),
        ),
      ],
    );
  }
*/