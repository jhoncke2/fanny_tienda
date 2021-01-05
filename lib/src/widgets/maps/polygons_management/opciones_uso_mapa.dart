import 'package:flutter/material.dart';
import 'package:fanny_tienda/src/bloc/map/map_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpcionesUsoMapa extends StatelessWidget {
  
  BuildContext _context;
  Size _size;
  @override
  Widget build(BuildContext context) {
    _context = context;
    _size = MediaQuery.of(context).size;
    return _crearBlocBuilders();
  }

  Widget _crearBlocBuilders(){
    return BlocBuilder<MapBloc, MapState>(
      builder: (_, MapState mapState){
        return _crearComponentesSegunState(mapState);
      },
    );
  }

  Widget _crearComponentesSegunState(MapState mapaState ){
    if(!mapaState.onPolygonCreation)
      return _crearComponentesOpcionesUso();
    else
      return Container();
  }

  Widget _crearComponentesOpcionesUso(){
    return Stack(
      children: [
        _crearBotonCreatePolygon()
      ],
    );
  }

  Widget _crearBotonCreatePolygon(){
    return Positioned(
      bottom: 50,
      left: _size.width * 0.34,
      child: MaterialButton(
        //color: Colors.black87,
        color: Theme.of(_context).primaryColor,
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Crear polígono',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        onPressed: (){
          final MapBloc mapBloc = BlocProvider.of<MapBloc>(_context);
          mapBloc.add(InitPolygonCreation());
        },
      ),
    );
  }

}