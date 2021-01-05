import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fanny_tienda/src/bloc/map/map_bloc.dart';
import 'package:fanny_tienda/src/pages/gestionar_polygons_page.dart';
import 'package:fanny_tienda/src/pages/init_validation_page.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/pages/confirmar_codigo_domiciliario_page.dart';
import 'package:fanny_tienda/src/pages/cuenta_page.dart';
import 'package:fanny_tienda/src/pages/direccion_create_mapa_page.dart';
import 'package:fanny_tienda/src/pages/direccion_create_page.dart';
import 'package:fanny_tienda/src/pages/domiciliario_create_page.dart';
import 'package:fanny_tienda/src/pages/domiciliarios_elegir_page.dart';
import 'package:fanny_tienda/src/pages/domiciliarios_page.dart';
import 'package:fanny_tienda/src/pages/mapa_page.dart';
import 'package:fanny_tienda/src/pages/pasos_confirmacion_celular_page.dart';
import 'package:fanny_tienda/src/pages/pasos_recuperar_password_page.dart';
import 'package:fanny_tienda/src/pages/perfil_page.dart';
import 'package:fanny_tienda/src/pages/producto_activar_programado_page.dart';
import 'package:fanny_tienda/src/pages/producto_create_page.dart';
import 'package:fanny_tienda/src/pages/solicitud_de_pedidos_page.dart';
import 'package:fanny_tienda/src/pages/splash_screen_page.dart';
import 'package:fanny_tienda/src/pages/ventas_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fanny_tienda/src/pages/home_page.dart';
import 'package:fanny_tienda/src/pages/login_page.dart';
import 'package:fanny_tienda/src/pages/producto_detail_page.dart';
import 'package:fanny_tienda/src/pages/productos_tienda_page.dart';
import 'package:fanny_tienda/src/pages/register_page.dart';

void main()async{
   runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext appContext){
    /**
     * Esta es la forma como Flutter recomienda que manipulemos la información
     * y/o el estado de la misma.
     * 
     * Como estoy implementando el InheritedWidget en la parte más alta(la cabeza) del
     * árbol de Widgets, va a ser distribuido alrededor de toda mi aplicación.
     */
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>(create: (_)=>MapBloc())
      ],
      child: Provider(
        child: MaterialApp(
          title: 'Domicilios',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            const Locale('en', ''),       
            const Locale('es', '')
          ],
          initialRoute: InitValidationPage.route,
          routes:{
            InitValidationPage.route:(BuildContext context)=>InitValidationPage(),
            HomePage.route:(BuildContext context)=>HomePage(),
            SplashScreenPage.route:(BuildContext context)=>SplashScreenPage(),
            LoginPage.route:(BuildContext context)=>LoginPage(),
            RegisterPage.route:(BuildContext context)=>RegisterPage(),
            PasosRecuperarPasswordPage.route:(BuildContext context)=>PasosRecuperarPasswordPage(),
            PasosConfirmacionCelularPage.route:(BuildContext context)=>PasosConfirmacionCelularPage(),
            GestionarPolygonsPage.route:(BuildContext context)=>GestionarPolygonsPage(),
            CuentaPage.route:(BuildContext context)=>CuentaPage(),
            PerfilPage.route:(BuildContext context)=>PerfilPage(),
            DireccionCreatePage.route:(BuildContext context)=>DireccionCreatePage(),
            ProductoDetailPage.route:(BuildContext context)=>ProductoDetailPage(),
            ProductosTiendaPage.route:(BuildContext context)=>ProductosTiendaPage(),
            ProductoActivarProgramadoPage.route:(BuildContext context)=>ProductoActivarProgramadoPage(),
            SolicitudDePedidosPage.route:(BuildContext context)=>SolicitudDePedidosPage(),
            VentasPage.route:(BuildContext context)=>VentasPage(),
            DomiciliariosPage.route:(BuildContext context)=>DomiciliariosPage(),
            DomiciliarioCreatePage.route:(BuildContext context)=>DomiciliarioCreatePage(),
            ConfirmarCodigoDomiciliarioPage.route:(BuildContext context)=>ConfirmarCodigoDomiciliarioPage(),
            DomiciliariosElegirPage.route:(BuildContext context)=>DomiciliariosElegirPage(),
            MapaPage.route:(BuildContext context)=>MapaPage(),
            ProductoCreatePage.route:(BuildContext context)=>ProductoCreatePage(),
            DireccionCreateMapaPage.route:(BuildContext context)=>DireccionCreateMapaPage(),
            
          },
          theme: ThemeData(
            fontFamily: 'OpenSans',
            primaryColor: Color.fromRGBO(164, 41, 15, 1),
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),   
            secondaryHeaderColor: Color.fromRGBO(69, 58, 60, 1),
            hoverColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.blueAccent
            ),
            inputDecorationTheme: InputDecorationTheme(
              fillColor: Colors.blue,
              focusColor: Colors.grey,
              hoverColor: Colors.redAccent
            ),
            buttonColor: Color.fromRGBO(240, 200, 102, 1),
            buttonTheme: ButtonThemeData(
              buttonColor: Color.fromRGBO(240, 200, 102, 1),
            )
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );

  }
}

