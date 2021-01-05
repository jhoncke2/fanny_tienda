import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fanny_tienda/src/bloc/map/map_bloc.dart';
import 'package:fanny_tienda/src/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';

class PolygonCreationComponents extends StatelessWidget {
  BuildContext _context;
  MapBloc _mapaBloc;
  SizeUtils _sizeUtils;
  @override
  Widget build(BuildContext appContext) {
    _initInitialConfiguration(appContext);
    return BlocBuilder<MapBloc, MapState>(
      builder: (_, MapState state){
        if(state.onPolygonCreation)
          return _crearComponentes(); 
        else
          return Container();
      },
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
    _mapaBloc = BlocProvider.of<MapBloc>(appContext);
  }

  Widget _crearComponentes(){
    return Stack(
      children: [
        _createExitButton(),
        _createBackButton(),
        _createSaveButton()
      ],
    );
  }

  Widget _createExitButton(){
    return Positioned(
      top: 70,
      left: 20,
      child: FadeInDown(
        duration: Duration(milliseconds: 550),
        child: CircleAvatar(
          //backgroundColor: Colors.black87,
          backgroundColor: Theme.of(_context).secondaryHeaderColor,
          child: IconButton(
            color: Colors.white,
            icon: Icon(
              Icons.close
            ),
            onPressed: (){
              _mapaBloc.add(EndFailedPolygonCreation());
            },
          ),
        ),
      ),
    );
  }

  Widget _createBackButton(){
    return Positioned(
      top: 70,
      left: 80,
      child: FadeInDown(
        duration: Duration(milliseconds: 550),
        child: CircleAvatar(
          //backgroundColor: Colors.black87,
          backgroundColor: Theme.of(_context).secondaryHeaderColor,
          child: IconButton(
            color: Colors.white,
            icon: Icon(
              Icons.arrow_back
            ),
            onPressed: (){
              _mapaBloc.add(DeleteLastPointToCurrentOnCreationPolygon());
            },
          ),
        ),
      ),
    );
  }

  Widget _createSaveButton(){
    return Positioned(
      bottom: 50,
      left: _sizeUtils.xasisSobreYasis * 0.22,
      child: FadeIn(
        duration: Duration(milliseconds: 550),
        child: MaterialButton(
          //color: Colors.black87,
          color: Theme.of(_context).primaryColor,
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.025),
          child: Text(
            'Guardar poligono',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          onPressed: (){
            _mapaBloc.add(EndSuccessPolygonCreation());
          },
        ),
      ),
    );
  }
}