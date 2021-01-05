import 'package:fanny_tienda/src/bloc_old/productos_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/bloc_old/usuario_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
class CategoriasScrollviewWidget extends StatefulWidget{
  @override
  _CategoriasScrollviewWidgetState createState() => _CategoriasScrollviewWidgetState();
}
/*
  Scrollview de categorias para la lista de productos
*/
class _CategoriasScrollviewWidgetState extends State<CategoriasScrollviewWidget> {
  bool _primerBuild;

  BuildContext context;
  Size size;
  UsuarioBloc usuarioBloc;
  String token;
  ProductosBloc productosBloc;

  @override
  void initState() { 
    super.initState();
    _primerBuild = true;
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    usuarioBloc = Provider.usuarioBloc(context);
    token = usuarioBloc.token;
    productosBloc = Provider.productosBloc(context);
    if(_primerBuild){
      productosBloc.cargarCategorias();
      _primerBuild = false;
    }
      
    return Container(
      height: size.height * 0.15,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Container(
             padding: EdgeInsets.only(left: size.width * 0.07),
             child: Text(
              'Categorias',
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.05
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.003,
          ),
          _crearListView(),
        ],
      ),
    );
  }

  Widget _crearListView(){
    
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: productosBloc.categoriasStream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          List<Widget> listviewItems = _crearListviewItems(snapshot.data);
          return Container(
            height: size.height * 0.1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: listviewItems, 
            ),
          );
        }else{
          return Container(
            height: size.height * 0.1,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
            ),
          );
        }
        
      }
    );
  }

  List<Widget> _crearListviewItems(List<Map<String, dynamic>> categories){
    print(Icons.home.fontFamily);
    List<Widget> categoriesWidgets = [];
    for(int i = 0; i < categories.length; i++){
      categoriesWidgets.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
          width: size.width * 0.2,
          padding: EdgeInsets.all(size.width * 0.02),
          decoration: BoxDecoration(
            color: (i%2 == 0)? Theme.of(context).primaryColor : Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.circular(size.width * 0.008)
          ),
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                IconData(
                  int.parse(categories[i]['icon']),
                  fontFamily: 'MaterialIcons'
                ),
                color: Colors.white.withOpacity(0.9),
                size: size.width * 0.09,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width  * 0.25),
                child: Text(
                  categories[i]['name'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: size.width * 0.024,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      );
    }
    return categoriesWidgets;
  }
}