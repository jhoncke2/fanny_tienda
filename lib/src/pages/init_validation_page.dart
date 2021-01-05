import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/bloc_old/shared_preferences_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_tienda/src/pages/direccion_create_page.dart';
import 'package:fanny_tienda/src/pages/login_page.dart';
import 'package:fanny_tienda/src/pages/register_page.dart';
import 'package:fanny_tienda/src/pages/solicitud_de_pedidos_page.dart';
import 'package:fanny_tienda/src/utils/size_utils.dart';
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class InitValidationPage extends StatelessWidget {
  static final String route = 'init_validation';
  BuildContext _context;
  SizeUtils _sizeUtils;
  UsuarioBloc _usuarioBloc;
  SharedPreferencesBloc _sharedPreferencesBloc;
  @override
  Widget build(BuildContext appContext) {
    _initInitialConfiguration(appContext);
    WidgetsBinding.instance.addPostFrameCallback((_){
      _validarLogin(_context, Provider.usuarioBloc(_context), Provider.sharedPreferencesBloc(_context));          
    });
    Size size = MediaQuery.of(_context).size;
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(_context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(size.width * 0.035)
          ),
          height: size.height * 0.7,
          width: size.width * 0.8,
        ),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    final Size screenSize = MediaQuery.of(appContext).size;
    _sizeUtils = SizeUtils();
    _sizeUtils.initUtil(screenSize);
    _usuarioBloc = Provider.usuarioBloc(_context);
    _sharedPreferencesBloc = Provider.sharedPreferencesBloc(_context);
  }

  void _validarLogin(BuildContext context, UsuarioBloc usuarioBloc, SharedPreferencesBloc sharedPreferencesBloc)async{
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
          _autoNormalLogin(loginCredentials['email'], loginCredentials['password']);
        }
      }else{
        if(sharedPreferencesBloc.getDireccionTemporalInicial() == null)
          Navigator.of(context).pushNamed(LoginPage.route);
      }
    }
  }

  void _autoNormalLogin( String email, String password)async{
    Map<String, dynamic> loginResponse = await _usuarioBloc.login(email, password);
    if(loginResponse['status'] != UsuarioBloc.INVALID_CREDENTIALS_MESSAGE){
        Map<String, dynamic> tiendaResponse = await Provider.tiendaBloc(_context).cargarTienda(_usuarioBloc.token);
        if(tiendaResponse['status'] == 'ok'){
          Provider.navigationBloc(_context).index = 3;
          Navigator.of(_context).pushNamed(SolicitudDePedidosPage.route);
        }
          
    }else{
        Navigator.of(_context).pushNamed(LoginPage.route);
    }
  }

  void _autoExternalLogin(email)async{
    Map<String, dynamic> loginResponse = await _usuarioBloc.validarEmail(email);
    if(loginResponse['status'] != UsuarioBloc.INVALID_CREDENTIALS_MESSAGE){
        Navigator.of(_context).pushNamed(RegisterPage.route, arguments: TipoDireccion.DESLOGGEADO);
    }else{
      print('ya está loggeado por externo');
    }
  }
}