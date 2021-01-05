part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class CambiarUbicacion extends MapEvent{
  final LatLng location;

  CambiarUbicacion({
    @required this.location
  });
}

class InitMap extends MapEvent{

}

class InitPolygonCreation extends MapEvent{

}

class AddPointToCurrentOnCreationPolygon extends MapEvent{
  final LatLng point;

  AddPointToCurrentOnCreationPolygon({
    @required this.point
  });
}

class DeleteLastPointToCurrentOnCreationPolygon extends MapEvent{

}

class EndFailedPolygonCreation extends MapEvent{

}

class EndSuccessPolygonCreation extends MapEvent{

}

class TappearPolygon extends MapEvent{
  final String polygonId;
  TappearPolygon({
    @required this.polygonId
  });
}
