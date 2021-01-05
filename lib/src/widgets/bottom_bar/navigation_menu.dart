import 'package:flutter/material.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/pages/direccion_create_page.dart';
import 'package:fanny_tienda/src/pages/gestionar_polygons_page.dart';
import 'package:fanny_tienda/src/pages/login_page.dart';
import 'package:fanny_tienda/src/pages/perfil_page.dart';
import 'package:fanny_tienda/src/pages/productos_tienda_page.dart';
import 'package:fanny_tienda/src/pages/solicitud_de_pedidos_page.dart';
import 'package:fanny_tienda/src/pages/ventas_page.dart';
import 'package:fanny_tienda/src/bloc_old/navigation_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/tienda_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_tienda/src/utils/size_utils.dart';

class NavigationMenu{
  final int _currentNavigationIndex;

  BuildContext _context;
  NavigationBloc _navigationBloc;
  UsuarioBloc _usuarioBloc;
  TiendaBloc _tiendaBloc;
  SizeUtils _sizeUtils;

  NavigationMenu(int currentNavigationIndex, BuildContext appContext, NavigationBloc navigationBloc, UsuarioBloc usuarioBloc)
  : _currentNavigationIndex = currentNavigationIndex{
    _initInitialConfiguration(appContext, navigationBloc, usuarioBloc);
  }

  void _initInitialConfiguration(BuildContext appContext, NavigationBloc navigationBloc, UsuarioBloc usuarioBloc){
    _context = appContext;
    _navigationBloc = navigationBloc;
    _usuarioBloc = usuarioBloc;
    _tiendaBloc = Provider.tiendaBloc(_context);
    _sizeUtils = SizeUtils();
  }

  void showNavigationMenu()async{
    final double screenWidth = MediaQuery.of(_context).size.width;
    final String authorizationToken = _usuarioBloc.token;
    List<PopupMenuEntry<String>> menuItems = _agregarMenuItems(authorizationToken);
    final String value = await showMenu<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_sizeUtils.xasisSobreYasis * 0.05),
          topRight: Radius.circular(_sizeUtils.xasisSobreYasis * 0.05)
        )
      ),
      context: _context, 
      position: RelativeRect.fromLTRB(
        _sizeUtils.xasisSobreYasis * 0.275, 
        _sizeUtils.xasisSobreYasis * 0.09, 
        screenWidth - 1, 
        _sizeUtils.xasisSobreYasis * 0.855
      ),
      items: menuItems,
    );
    _validateNavigationMenuValue(value);
  }

  void _validateNavigationMenuValue(String value){
    final String authorizationToken = _usuarioBloc.token;
    if(value!=null){
      _navigationBloc.index = _currentNavigationIndex;
    }
    switch(value){
      case 'perfil':
        Navigator.of(_context).pushNamed(PerfilPage.route);
        break;
      case 'gestionar_areas_reparto':
        Navigator.of(_context).pushNamed(GestionarPolygonsPage.route);
      break;
      case 'tienda':   
        TiendaBloc tiendaBloc = Provider.tiendaBloc(_context);
        if(!tiendaBloc.enCreacion){
          tiendaBloc.iniciarCreacionTienda();
          Navigator.of(_context).pushNamed(DireccionCreatePage.route, arguments: 'tienda');
        }else
          Navigator.of(_context).pushNamed(PerfilPage.route);
        break;
      case 'productos':
        Navigator.of(_context).pushNamed(ProductosTiendaPage.route);
        break;
      case 'solicitud_de_pedidos':
        Navigator.of(_context).pushNamed(SolicitudDePedidosPage.route);
        break;
      case 'ventas':
        Navigator.of(_context).pushNamed(VentasPage.route);
        break;
      case 'salir':
        _logOut(authorizationToken);
        break;
      default:
        break; 
    }
  }

  List<PopupMenuEntry<String>> _agregarMenuItems(String token){
    List<PopupMenuEntry<String>> items = [
      PopupMenuItem<String>(
        enabled: false,
        value: 'imagen',
        child: Container(
          padding: EdgeInsets.only(bottom:_sizeUtils.xasisSobreYasis * 0.035, top: _sizeUtils.xasisSobreYasis * 0.024),
          child: Center(
            child: Image.asset(
              'assets/iconos/logo_fanny_1.png',
              fit: BoxFit.fill,
              width: _sizeUtils.xasisSobreYasis * 0.27,
              height: _sizeUtils.xasisSobreYasis * 0.23,
            ),
          ),
        ),
      ),
      PopupMenuItem<String>(
        value: 'perfil',
        height: _sizeUtils.xasisSobreYasis * 0.075,
        child: _crearChildPopUpMenuItem(0, 'Perfil', Icons.person),
      ),
      PopupMenuItem<String>(
        value: 'gestionar_areas_reparto',
        height: _sizeUtils.xasisSobreYasis * 0.075,
        child: _crearChildPopUpMenuItem(1, 'Gestionar áreas de reparto', Icons.location_on_outlined),
      ),
      PopupMenuItem<String>(
        value: 'tienda',
        enabled: !_usuarioBloc.usuario.hasStore,
        height: _sizeUtils.xasisSobreYasis * 0.075,
        child: _crearChildPopUpMenuItem(2, 'Ofrecer productos para venta', Icons.monetization_on),
      ),
      PopupMenuItem<String>(
        value: 'productos',
        height: _sizeUtils.xasisSobreYasis * 0.075,
        child: _crearChildPopUpMenuItem(3, 'Productos', Icons.indeterminate_check_box_rounded),
      ),
      PopupMenuItem<String>(
        value: 'solicitud_de_pedidos',
        height: _sizeUtils.xasisSobreYasis * 0.075,
        child: _crearChildPopUpMenuItem(4, 'Solicitud de pedidos', Icons.compare_arrows_rounded),
      ),
      PopupMenuItem<String>(
        value: 'ventas',
        height: _sizeUtils.xasisSobreYasis * 0.075,
        child: _crearChildPopUpMenuItem(5, 'Ventas', Icons.attach_money),
      ),
      PopupMenuItem<String>(
        value: 'salir',
        height: _sizeUtils.xasisSobreYasis * 0.075,
        child: _crearChildPopUpMenuItem(7, 'Salir', Icons.open_in_new),
      ),
      PopupMenuItem<String>(
        value: 'bottom',
        height: _sizeUtils.xasisSobreYasis * 0.21,
        enabled: false,
        child: Container(),
      )
    ];
    return items;
  }
  
  Widget _crearChildPopUpMenuItem(int itemIndex, String nombre, IconData icono){
    bool esTiendaSubItem = 2 < itemIndex && itemIndex < 7;
    return Container(
      height: _sizeUtils.xasisSobreYasis * (esTiendaSubItem? 0.07 : 0.09),
      margin: (esTiendaSubItem)?EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.085):EdgeInsets.all(0.0),
      decoration: _createMenuItemDecoration(itemIndex),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _createMenuItemText(nombre),
          _createMenuItemIcon(esTiendaSubItem, icono)
        ],
      ),
    );
  }

  BoxDecoration _createMenuItemDecoration(int itemIndex){
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.withOpacity(((_usuarioBloc.usuario.hasStore && itemIndex < 7)? 0.45: 0.0)),
          width: 1.35
        )
      )
    );
  }

  Widget _createMenuItemText(String nombre){
    return Text(
      nombre,
      style: TextStyle(
        color: Colors.black.withOpacity(0.55),
        fontSize: _sizeUtils.normalTextSize * 1.1,
        fontFamily: 'OpenSansCondensed',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _createMenuItemIcon(bool esTiendaSubItem, IconData icono){
    if(!esTiendaSubItem)
      return Icon(
        icono,
        size: _sizeUtils.normalIconSize,
        color: Colors.grey.withOpacity(0.85),
      );
    else
      return Container();
  }

  void _logOut(String authoirizationToken)async{
    await _usuarioBloc.logOut(authoirizationToken);
    Provider.sharedPreferencesBloc(_context).logOut();
    _navigationBloc.reiniciarIndex();
    Navigator.pushReplacementNamed(_context, LoginPage.route);
  }
}