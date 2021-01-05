import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

ImagePicker _imagePicker = ImagePicker();

Future<void> tomarFotoDialog(BuildContext context, Size size, Map<String, File> imagenMap)async{
  File imagen;
  await showDialog(
    context: context,
     builder: (BuildContext buildContext){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.035)
        ),
        child: Container(
          color: Colors.grey.withOpacity(0.45),
          padding: EdgeInsets.symmetric(vertical:0.0),
          height: size.height * 0.24,
          width: size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.35),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black.withOpacity(0.65)
                    )
                  ),
                  
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.redAccent.withOpacity(0.9),
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
              CupertinoButton(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                //color: Colors.blueGrey.withOpacity(0.35),
                child: Text(
                  'Subir imagen',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.45),
                    fontSize: size.width * 0.049
                  ),
                ),
                onPressed: ()async{
                  imagen = await _procesarImagen(context, ImageSource.gallery);
                  imagenMap['imagen'] = imagen;
                  Navigator.of(context).pop(imagen);
                }
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
                height: size.height * 0.001,
              ),
              CupertinoButton(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                //color: Colors.blueGrey.withOpacity(0.35),
                child: Text(
                  'Tomar foto',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.45),
                    fontSize: size.width * 0.049
                  ),
                ),
                onPressed: ()async{
                  imagen = await _procesarImagen(context, ImageSource.camera);
                  imagenMap['imagen'] = imagen;
                  Navigator.of(context).pop(imagen);
                }
              ),
            ],
          ),
        ),
      );
    }
  );
}

void showBottomSheetByScaffoldState(GlobalKey<ScaffoldState> scaffoldKey, Size size, String mensaje){
  PersistentBottomSheetController bottomSheetController;
  bottomSheetController =  scaffoldKey.currentState.showBottomSheet(
    (BuildContext context){
      Future.delayed(
        const Duration(milliseconds: 3500),
        (){
          bottomSheetController.close();
        }
      );
      return Card(
        color: Colors.white.withOpacity(0.98),
        elevation: size.width * 0.01,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          height: size.height * 0.15,
          width: size.width,
          alignment: Alignment.center,
          child: Text(
            mensaje,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.045
            ),
          ),
        ),
      );
    }
  );
}



Future<File> _procesarImagen(BuildContext context, ImageSource imageSource)async{
  PickedFile pickedFile = await _imagePicker.getImage(
      source: imageSource
    );
    File imagen = File(pickedFile.path);
    return imagen;    
}

String getStringOfDate(Map<String, dynamic> fecha){
  return '${fecha['day_of_week']}, ${fecha['day']} de ${getStringMonthByNumberMonth(fecha['month'])} del ${fecha['year']}';
}

String getStringOfRango(Map<String, dynamic> rango){
  int horaInicial = rango['hora_inicial'];
  if(horaInicial != 12)
    horaInicial = rango['hora_inicial']%12;
  int horaFinal = rango['hora_final'];
  if(horaFinal != 12)
    horaFinal = rango['hora_final']%12;
  String horaInicialString = (horaInicial< 10)? '0$horaInicial':'$horaInicial';
  horaInicialString += rango['hora_inicial'] < 12? 'am' : 'pm';
  String horaFinalString = (horaFinal< 10)? '0$horaFinal':'$horaFinal';
  horaFinalString += rango['hora_final'] < 12? 'am' : 'pm';
  return 'desde $horaInicialString hasta $horaFinalString';
}

String getStringDayByWeekNumberDay(int weekNumberDay){
    switch(weekNumberDay){
      case 1:
        return 'lunes';
      case 2:
        return 'martes';
      case 3:
        return 'miércoles';
      case 4:
        return 'jueves';
      case 5:
        return 'viernes';
      case 6:
        return 'sábado';
      case 7:
        return 'domingo';
      default:
        return 'desconocido';
    }
  }

  String getStringMonthByNumberMonth(int weekNumberDay){
    switch(weekNumberDay){
      case 1:
        return 'Enero';
      case 2:
        return 'Febrero';
      case 3:
        return 'Marzo';
      case 4:
        return 'Abril';
      case 5:
        return 'Mayo';
      case 6:
        return 'Junio';
      case 7:
        return 'Julio';
      case 8:
        return 'Agosto';
      case 9:
        return 'Septiembre';
      case 10:
        return 'Octubre';
      case 11:
        return 'Noviembre';
      case 12:
        return 'Diciembre';
      default:
        return 'desconocido';
    }
  }

