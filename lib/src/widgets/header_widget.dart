import 'package:fanny_tienda/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/pedidos_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/bloc_old/shared_preferences_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_tienda/src/models/lugares_model.dart';
import 'package:fanny_tienda/src/pages/direccion_create_page.dart';
import 'package:flutter/material.dart';
class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  BuildContext context; 
  Size size;
  UsuarioBloc usuarioBloc;
  String token;
  LugaresBloc lugaresBloc;
  SharedPreferencesBloc sharedPreferencesBloc;
  PedidosBloc pedidosBloc;
  bool _widgetBuilded;
  bool _direccionTemporalInicialExiste;
  
  @override
  void initState() { 
    _direccionTemporalInicialExiste = false;
    _widgetBuilded = false;
    print('state inited');
    super.initState(); 
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    sharedPreferencesBloc = Provider.sharedPreferencesBloc(context);
    lugaresBloc = Provider.lugaresBloc(context);
    usuarioBloc = Provider.usuarioBloc(context);
    token = usuarioBloc.token;
    pedidosBloc = Provider.pedidosBloc(context);
    
    if(!_widgetBuilded){
      _initDatos();
      _widgetBuilded = true;
    }
    
    print('building');
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          _crearPopUpDirecciones(size, lugaresBloc, token),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: size.width * 0.0005,
                height: size.height * 0.045,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey.withOpacity(0.65),
                      width: 1
                    )
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: size.width * 0.055),
                child: Image.asset(
                  'assets/iconos/logo_fanny_simple.jpeg',
                  fit: BoxFit.fill,
                  width: size.width * 0.085,
                  height: size.height * 0.085,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _crearPopUpDirecciones(Size size, LugaresBloc lugaresBloc, String token){
    return StreamBuilder(
      stream: lugaresBloc.lugaresStream,
      builder: (BuildContext context, AsyncSnapshot<List<LugarModel>> snapshot){
        if(snapshot.hasData){
          List<LugarModel> lugares = snapshot.data;
          LugarModel lugarElegido;
          List<PopupMenuEntry<int>> popupItems = [];
          for(int i = 0; i < snapshot.data.length; i++){
            LugarModel lugar = lugares[i];
            if(lugar.elegido)
              lugarElegido = lugar;
            popupItems.add(
              PopupMenuItem(
                value: i,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: size.width * 0.095,
                      height: size.height * 0.03,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: ((!lugar.elegido)? 
                          Border.all(
                            width: 1,
                            color: Colors.black.withOpacity(0.9)
                          )
                          :null
                          ),
                        color: (lugar.elegido)? Theme.of(context).secondaryHeaderColor : Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.025,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: size.width  * 0.45),
                      child: Text(
                        lugar.direccion,
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            );
          }
          if(!_direccionTemporalInicialExiste){
            popupItems.add(
              PopupMenuItem( 
                enabled: false,
                value: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal:size.height * 0.015),
                  child: Center(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.04)),
                      child: Text('otra dirección'),
                      color: Colors.grey.withOpacity(0.8),
                      onPressed: (){
                        Navigator.pushNamed(context, DireccionCreatePage.route, arguments: 'cliente');
                      },
                    ),
                  ),
                ),
              )
            );
          }
          
          return PopupMenuButton<int>(
            onSelected: (int index){
              LugarModel elegido = snapshot.data[index];
              lugaresBloc.elegirLugar(elegido.id, token);
              setState(() {

              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.width * 0.048)
            ),
            offset: Offset(
              -size.width * 0.04,
              size.height * 0.155,
            ),
            padding: EdgeInsets.all(0.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.place,
                  color: Colors.grey.withOpacity(0.8),
                  size: size.width * 0.06,
                ),
                SizedBox(
                  width: size.width * 0.02
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width  * 0.45),
                  child: Text(
                    lugarElegido.direccion,
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.005,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey.withOpacity(0.65),
                  size: size.width * 0.085,
                ),
              ],
            ),
            itemBuilder: (BuildContext context){
              return popupItems;
            },
          ); 
        }
        return Container();
      },
    );
  }

  Future<void> _initDatos()async{
    await _validarLogin();
    await _cargarLugares();
    if(!pedidosBloc.pedidosAnterioresCargados)
      pedidosBloc.cargarPedidosAnterioresPorClienteOTienda(usuarioBloc.token, 'cliente', null);
  }

  Future<void> _validarLogin()async{
    if(sharedPreferencesBloc.sharedPreferences == null){
      await sharedPreferencesBloc.initSharedPreferences();
    }
    //sharedPreferencesBloc.deleteDireccionTemporalInicial();
    if(!usuarioBloc.isLogged){
      Map<String, dynamic> loginCredentials = sharedPreferencesBloc.getActualLoginCredentials();
      if(['facebook', 'google'].contains( loginCredentials['tipo'] ) ){
        if(loginCredentials['email'] != null){
          _autoExternalLogin(loginCredentials['email']);
        }
      }else if(loginCredentials['tipo'] == 'normal'){
        if(loginCredentials['email'] != null && loginCredentials['password'] != null){
          await _autoNormalLogin(loginCredentials['email'], loginCredentials['password']);
        }
      }else{
        if(sharedPreferencesBloc.getDireccionTemporalInicial() == null)
          Navigator.of(context).pushNamed(DireccionCreatePage.route, arguments: TipoDireccion.DESLOGGEADO);
      }
    }
  }

  Future<void> _cargarLugares()async{
    if(sharedPreferencesBloc.sharedPreferences == null)
      await sharedPreferencesBloc.initSharedPreferences();
    //sharedPreferencesBloc.deleteDireccionTemporalInicial();
    Map<String, dynamic> loginCredentials = sharedPreferencesBloc.getActualLoginCredentials();
    if(usuarioBloc.usuario != null && usuarioBloc.usuario.phoneVerify){
      Map<String, dynamic> response = await lugaresBloc.cargarLugares(usuarioBloc.token);
      if(response['status'] == 'no_direcciones')
        Navigator.of(context).pushReplacementNamed(DireccionCreatePage.route, arguments: 'cliente_nuevo');
    }else if(sharedPreferencesBloc.getDireccionTemporalInicial() != null){
      lugaresBloc.addDireccionInicialActual(sharedPreferencesBloc.getDireccionTemporalInicial());
      _direccionTemporalInicialExiste = true;
    }
  }

  Future<void> _autoNormalLogin(String email, String password)async{
    Map<String, dynamic> loginResponse = await usuarioBloc.login(email, password);
    if(loginResponse['status'] == UsuarioBloc.INVALID_CREDENTIALS_MESSAGE){
      if(sharedPreferencesBloc.getDireccionTemporalInicial() == null)
        Navigator.of(context).pushNamed(DireccionCreatePage.route, arguments: TipoDireccion.DESLOGGEADO);
    }else{
      print('ya está loggeado normal');
    }
  }

  void _autoExternalLogin(String email)async{
    Map<String, dynamic> loginResponse = await usuarioBloc.validarEmail(email);
    if(loginResponse['status'] == UsuarioBloc.INVALID_CREDENTIALS_MESSAGE){
      if(sharedPreferencesBloc.getDireccionTemporalInicial() == null)
        Navigator.of(context).pushNamed(DireccionCreatePage.route, arguments: TipoDireccion.DESLOGGEADO);
    }else{
      print('ya está loggeado por externo');
    }
  }
}