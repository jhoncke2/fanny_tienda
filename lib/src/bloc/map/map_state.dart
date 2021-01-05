part of 'map_bloc.dart';

@immutable
class MapState {
  final bool inicializado;
  final bool hasLocation;
  final LatLng currentLocation;
  final Set<Polygon> polygons;
  final bool onPolygonCreation;
  final Polygon currentOnCreationPolygon;

  MapState({
    this.inicializado = false,
    this.hasLocation = false,
    this.currentLocation,
    Set<Polygon> polygons,
    this.onPolygonCreation = false,
    this.currentOnCreationPolygon
  })
  : this.polygons = polygons??{}
    ;

  MapState copyWith({
    bool inicializado,
    bool hasLocation,
    LatLng currentLocation,
    Set<Polygon> polygons,
    bool onPolygonCreation,
    Polygon currentOnCreationPolygon
  }) => MapState(
    inicializado: inicializado??this.inicializado,
    hasLocation: hasLocation??this.hasLocation,
    currentLocation: currentLocation??this.currentLocation,
    polygons: polygons??this.polygons,
    onPolygonCreation: onPolygonCreation??this.onPolygonCreation,
    currentOnCreationPolygon: currentOnCreationPolygon??this.currentOnCreationPolygon
  );

  MapState notOnPolygonCreation()=>MapState(
    inicializado: this.inicializado,
    hasLocation: this.hasLocation,
    currentLocation: this.currentLocation,
    
  );
}

