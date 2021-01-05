import 'package:fanny_tienda/src/widgets/maps/polygons_management/polygon_creation_components.dart';
import 'package:flutter/material.dart';

import 'package:fanny_tienda/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/widgets/maps/polygons_management/opciones_uso_mapa.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fanny_tienda/src/bloc/map/map_bloc.dart';
import 'package:fanny_tienda/src/utils/size_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GestionarPolygonsPage extends StatefulWidget {
  static final route = 'gestionar_polygons';

  @override
  _GestionarPolygonsPageState createState() => _GestionarPolygonsPageState();
}

class _GestionarPolygonsPageState extends State<GestionarPolygonsPage> {

  BuildContext _context;
  SizeUtils _sizeUtils;

  @override
  Widget build(BuildContext appContext) {
    _initInitialConfiguration(appContext);
    return Scaffold(
      body: _crearElementos(),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
  }

  Widget _crearElementos(){
    return BlocBuilder<MapBloc, MapState>(
      builder: (_, MapState mapaState){
        return _crearElementosByCurrentLocation(mapaState);
      },
    );
  }

  Widget _crearElementosByCurrentLocation(MapState mapState){
    //final LatLng currentLocation = mapState.currentLocation;
    final LugaresBloc lugaresBloc = Provider.lugaresBloc(context);
    final LatLng currentLocation = lugaresBloc.actualElegido.latLng;
    if(currentLocation != null)
      return _crearComponentesMapa(mapState, currentLocation);
    
  }

  Widget _crearComponentesMapa(MapState mapState, LatLng currentLocation){
    return Stack(
      children: <Widget>[
        _crearMapa(mapState, currentLocation),
        OpcionesUsoMapa(),
        PolygonCreationComponents()
      ],
    );
  }

  Widget _crearMapa(MapState mapState, LatLng currentLocation){
    final MapBloc mapBloc = BlocProvider.of<MapBloc>(context);
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        zoom: 16,
        target: currentLocation
      ),
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller){
        mapBloc.initMap(controller);
      },
      polygons: _generatePolygons(mapState),
      onTap: _onTapMap,
    );
  }


  void _onTapMap(LatLng tapPosition){
    final MapBloc mapaBloc = BlocProvider.of<MapBloc>(_context);
    final bool onPolygonCreation = mapaBloc.state.onPolygonCreation;
    if(onPolygonCreation){
      mapaBloc.add(AddPointToCurrentOnCreationPolygon(point: tapPosition));
    }
  }


  Set<Polygon> _generatePolygons(MapState state){
    final Set<Polygon> polygons = state.polygons;
    if(state.onPolygonCreation ){
      final Polygon currentOnCreationPolygon = state.currentOnCreationPolygon;
      final int nOnPolygonCreationPoints = currentOnCreationPolygon.points.length;
      if(nOnPolygonCreationPoints > 0)
        polygons.add(currentOnCreationPolygon);
    }
    return polygons;
  }

}

/**************************************************************************** 
 * 
 *  ------------------> ¡ Aquí está la clase copiada!   <--------------------
 * 
*****************************************************************************/

