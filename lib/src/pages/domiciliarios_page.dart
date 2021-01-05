import 'package:fanny_tienda/src/bloc_old/domiciliarios_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/models/domiciliarios_model.dart';
import 'package:fanny_tienda/src/pages/domiciliario_create_page.dart';
import 'package:fanny_tienda/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:fanny_tienda/src/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:fanny_tienda/src/utils/generic_utils.dart' as utils;
// ignore: must_be_immutable
class DomiciliariosPage extends StatelessWidget {
  static final route = 'domiciliarios';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  BuildContext context;
  Size size;
  DomiciliariosBloc domiciliariosBloc;
  
  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    domiciliariosBloc = Provider.domiciliariosBloc(context);
    domiciliariosBloc.cargarDomiciliarios(Provider.usuarioBloc(context).token);
    Widget scaffold = Scaffold(
      key: _scaffoldKey,
      body: _crearElementos(),
      bottomNavigationBar: BottomBarWidget(),
    );
    _lanzarBottomSheet();
    return scaffold;
  }

  void _lanzarBottomSheet()async{
    if(ModalRoute.of(context).settings.arguments == 'codigo_confirmado')
    {
      Future.delayed(const Duration(milliseconds: 1000), (){
        utils.showBottomSheetByScaffoldState(_scaffoldKey, size, 'Felicidades, has contratado a un nuevo domiciliario');
      });
    }
  }

  Widget _crearElementos(){
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.06,
          ),
          HeaderWidget(),
          SizedBox(
            height: size.height * 0.01,
          ),
          Container(
            height: size.height * 0.66,
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
          SizedBox(
            height: size.height * 0.03,
          ),
          _crearBotonAgregarDomiciliario()
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