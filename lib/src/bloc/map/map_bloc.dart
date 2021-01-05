import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState());

  MapState _currentReturnedState;

  GoogleMapController _googleMapController;
  List<Polygon> _polygons = [];
  Polygon _currentOnCreationPolygon;

  void initMap(GoogleMapController newController){
    if(!state.inicializado){
      _googleMapController = newController;
    }
    add(InitMap());
  }

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    // TODO: implement mapEventToState
    switch(event.runtimeType){
      case InitMap:
        yield state.copyWith(inicializado: true);
      break;
      case CambiarUbicacion:
        LatLng newLocation = (event as CambiarUbicacion).location;
        yield state.copyWith(hasLocation: true, currentLocation: newLocation);
      break;
      case InitPolygonCreation:
        _initPolygonCreation(event as InitPolygonCreation);
        yield _currentReturnedState;
      break;
      case AddPointToCurrentOnCreationPolygon:
        _addPointToCurrentOnCreationPolygon(event as AddPointToCurrentOnCreationPolygon);
        yield _currentReturnedState;
      break;
      case DeleteLastPointToCurrentOnCreationPolygon:
        _deleteLastPointToCurrentOnCreationPolygon(event as DeleteLastPointToCurrentOnCreationPolygon);
        yield _currentReturnedState;
      break;
      case EndSuccessPolygonCreation:
        _endSuccessPolygonCreation(event as EndSuccessPolygonCreation);
        yield _currentReturnedState;
      break;
      case EndFailedPolygonCreation:
        _endFailedPolygonCreation(event as EndFailedPolygonCreation);
        yield _currentReturnedState;
      break;
    }
  }

  void _initPolygonCreation(InitPolygonCreation event){
    final List<LatLng> initialPoints = [];
    _currentOnCreationPolygon = Polygon(
      polygonId: PolygonId('on_creation'),
      fillColor: Colors.redAccent[200].withOpacity(0.7),
      strokeColor: Colors.brown[400].withOpacity(0.8),
      strokeWidth: 2,
      points: initialPoints
    );
    _currentReturnedState = state.copyWith(
      onPolygonCreation: true, 
      currentOnCreationPolygon: _currentOnCreationPolygon
    );
  }

  void _addPointToCurrentOnCreationPolygon(AddPointToCurrentOnCreationPolygon event){
    final LatLng newPoint = event.point;
    final List<LatLng> onCreationPolygonPoints = _currentOnCreationPolygon.points;
    onCreationPolygonPoints.add(newPoint);
    _currentOnCreationPolygon = _currentOnCreationPolygon.copyWith(pointsParam: onCreationPolygonPoints);
    _currentReturnedState = state.copyWith(currentOnCreationPolygon: _currentOnCreationPolygon);
  }

  void _deleteLastPointToCurrentOnCreationPolygon(DeleteLastPointToCurrentOnCreationPolygon event){
    final List<LatLng> points = _currentOnCreationPolygon.points;
    points.removeLast();
    _currentOnCreationPolygon = _currentOnCreationPolygon.copyWith(pointsParam: points);
    _currentReturnedState = state.copyWith(currentOnCreationPolygon: _currentOnCreationPolygon);
  }

  void _endSuccessPolygonCreation(EndSuccessPolygonCreation event){
    final int nPolygons = state.polygons.length;
    final PolygonId newPolygonId = PolygonId('$nPolygons');
    final Polygon newPolygon = Polygon(
      polygonId: newPolygonId,
      fillColor: Colors.redAccent[100].withOpacity(0.8),
      strokeColor: Colors.brown[200],
      strokeWidth: 3,
      points: _currentOnCreationPolygon.points,
    );
    _polygons.add(newPolygon);
    Set<Polygon> setOfPolygons = _polygons.toSet();
    _currentOnCreationPolygon = null;
    _currentReturnedState = state.copyWith(
      onPolygonCreation: false,
      currentOnCreationPolygon: null,
      polygons: setOfPolygons
    );
  }

  void _endFailedPolygonCreation(EndFailedPolygonCreation event){
    _currentOnCreationPolygon = null;
    Set<Polygon> statePolygons = _polygons.toSet();
    _currentReturnedState = MapState(
      inicializado: true,
      hasLocation: state.hasLocation,
      currentLocation: state.currentLocation,
      polygons: statePolygons
    );
  }
}
