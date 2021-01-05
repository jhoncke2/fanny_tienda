import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fanny_tienda/src/bloc_old/productos_bloc.dart';
import 'package:fanny_tienda/src/bloc_old/provider.dart';
import 'package:fanny_tienda/src/models/productos_model.dart';
import 'package:fanny_tienda/src/pages/productos_tienda_page.dart';
import 'package:fanny_tienda/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:fanny_tienda/src/widgets/header_widget.dart';

import 'package:fanny_tienda/src/utils/generic_utils.dart' as utils;
class ProductoActivarProgramadoPage extends StatefulWidget {
  static final route = 'producto_activar_programado';
  @override
  _ProductoActivarProgarmadoPageState createState() => _ProductoActivarProgarmadoPageState();
}

class _ProductoActivarProgarmadoPageState extends State<ProductoActivarProgramadoPage> {
  final _rangosHorarioItems = [
    {
      0, 1, '00:00am a 01:00am',
    },
    {
      1, 2, '01:00am a 02:00am',
    },
    {
      2, 3, '02:00am a 03:00am',
    },
    {
      3, 4, '03:00am a 04:00am',
    },
    {
      4, 5, '04:00am a 05:00am',
    },
    {
      5, 6, '05:00am a 06:00am',
    },
    {
      6, 7, '06:00am a 07:00am',
    },
    {
      7, 8, '07:00am a 08:00am',
    },
    {
      8, 9, '08:00am a 09:00am',
    },
    {
      9, 10, '09:00am a 10:00am',
    },
    {
      10, 11, '10:00am a 11:00am',
    },
    {
      11, 12, '11:00am a 12:00pm',
    },
    {
      12, 13, '12:00pm a 01:00pm',
    },
    {
      13, 14, '01:00pm a 02:00pm',
    },
    {
      14, 15, '02:00pm a 03:00pm',
    },
    {
      15, 16, '03:00pm a 04:00pm',
    },
    {
      16, 17, '04:00pm a 05:00pm',
    },
    {
      17, 18, '05:00pm a 06:00pm',
    },
    {
      18, 19, '06:00pm a 07:00pm',
    },
    {
      19, 20, '07:00pm a 08:00pm',
    },
    {
      20, 21, '08:00pm a 09:00pm',
    },
    {
      21, 22, '09:00pm a 10:00pm',
    },
    {
      22, 23, '10:00pm a 11:00pm',
    },
    {
      23, 0, '11:00pm a 00:00am',
    }
  ];

  List<bool> _rangosDeHoraSeleccionados;

  BuildContext context;
  Size size;
  ProductosBloc productosBloc;
  ProductoModel _producto;

  DateTime _diaElegido;
  String _diaElegidoString;
  int _cantidadPedidosMaximosPorHora;
  int _cantidadProductosAVender;
  int _valorUnitario;

  @override
  void initState() {
    // TODO: implement initState
    _rangosDeHoraSeleccionados = [];
    for(int i = 0; i < 24; i++)
      _rangosDeHoraSeleccionados.add(false);
    super.initState();
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    productosBloc = Provider.productosBloc(context);
    _producto = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: _crearElementos(),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Widget _crearElementos(){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.06,
          ),
          HeaderWidget(),
          Container(
            height: size.height * 0.76,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.015,
                ),
                _crearTitulo(),
                SizedBox(
                  height: size.height * 0.045,
                ),
                _crearDatePickerDia(),
                SizedBox(
                  height: size.height * 0.025,
                ),
                _crearRangosDeHorarioEntrega(),
                SizedBox(
                  height: size.height * 0.035,
                ),
                _crearPopUp('pedidos_por_hora'),
                SizedBox(
                  height: size.height * 0.045,
                ),
                _crearPopUp('productos_a_vender'),
                SizedBox(
                  height: size.height * 0.055,
                ),
                _crearInputValorUnitario(),
                SizedBox(
                  height: size.height * 0.065,
                ),
                _crearBotonSubmit()
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _crearTitulo(){
    return Text(
      'Activar producto programado',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: size.width * 0.065,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _crearDatePickerDia(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: size.width * 0.33,
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Row(
              children: <Widget>[
                Text(
                  'Dia de venta',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.043,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                  size: size.width * 0.055,
                )
              ],
            ),
            onPressed: (){
              _showDatePickerDia();
            },
          ),
        ),
        Text(
          _diaElegidoString??'',
          style: TextStyle(
            color: Colors.black,
            fontSize: size.width * 0.035
          ),
        )
      ],
    );
  }

  Widget _crearRangosDeHorarioEntrega(){
    List<Widget> rangosHorariosItemWidgets = [];
    for(int i = 0; i < 24; i++){
      rangosHorariosItemWidgets.add(
        Container(
          height: size.height * 0.04,
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal:0, vertical: size.height * 0.004),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: size.width * 0.095,
                  height: size.height * 0.03,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: ((_rangosDeHoraSeleccionados[i])? 
                        null
                      : Border.all(
                        width: 1,
                        color: Colors.black.withOpacity(0.8)
                      )
                    ),
                    color: (_rangosDeHoraSeleccionados[i])? Theme.of(context).secondaryHeaderColor : Colors.white,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Text(
                  _rangosHorarioItems[i].elementAt(2),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: size.width * 0.042
                  ),
                ),
              ],
            ),
            onPressed: (){
              _rangosDeHoraSeleccionados[i] = !_rangosDeHoraSeleccionados[i];
              setState(() {
                
              });
            },
          ),
        )
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: size.width * 0.81,
          //padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: ExpansionTile(
            title: Text(
              'Rangos de horario de entrega',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.044
              ),
            ),
            trailing: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
              size: size.width * 0.065,
            ),
            children: rangosHorariosItemWidgets,
          ),
        ),
      ],
    );
  }

  /**
   * Params:
   * * * tipoPopup:
   * * * * "pedidos_por_hora"
   * * * * "productos_a_vender"  
   */
  Widget _crearPopUp(String tipoPopup){
    String popupTitle;
    switch(tipoPopup){
      case 'pedidos_por_hora':
        popupTitle = 'Entrega pedidos máximo por hora';
      break;
      case  'productos_a_vender':
        popupTitle = 'Cantidad de productos a vender';
      break;
    }
    List<PopupMenuEntry<int>> popUpItems = [
      PopupMenuItem<int>(
        value: 0,
        height: size.height * 0.35,
        child: _crearListViewCantidad(tipoPopup),
        enabled: false,
      )
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: size.width * 0.8,
          child: PopupMenuButton<int>(
            onSelected: (int newValue){
              setState(() {
                
              });
            },
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            itemBuilder: (BuildContext context){
              return popUpItems;
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.width * 0.02)
            ),
            offset: Offset(
              -size.width * 0.01,
              size.height * 0.1,
            ),
            child: Container(  
              width: size.width * 0.12,
              height: size.height * 0.032,
              padding: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * 0.04),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text( 
                   popupTitle,
                    style: TextStyle(
                      fontSize: size.width * 0.043,
                      color: Colors.black.withOpacity(0.8)
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey.withOpacity(0.9),
                    size: size.width * 0.075,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _crearListViewCantidad(String tipoPopup){
    List<Widget> listViewItems = [];
    for(int i = 0; i<100; i++){
      listViewItems.add(
        Container(
          width: size.width * 0.2,
          height: size.height * 0.045,
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal:0, vertical: size.height * 0.004),
            child: Text(
              '${i+1}',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: size.width * 0.043
              ),
            ),
            onPressed: (){
              switch(tipoPopup){
                case 'pedidos_por_hora':
                  _cantidadPedidosMaximosPorHora = i;
                  break;
                case 'productos_a_vender':
                  _cantidadProductosAVender = i;
                  break;
              }
              Navigator.of(context).pop();
            },
          ),
        )
      );
    }
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeRight: true,
      removeLeft: true,
      child: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        height: size.height * 0.35,
        width: size.width * 0.2,
        child: ListView(
          padding: EdgeInsets.all(0),
          scrollDirection: Axis.vertical,
          children: listViewItems,
        ),
      ),
    );
  }

  Widget _crearInputValorUnitario(){
    return Container(
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          Text(
            'Valor unitario',
            style: TextStyle(
              fontSize: size.width * 0.043,
              color: Colors.black.withOpacity(0.67)
            ),
          ),
          SizedBox(
            width: size.width * 0.04,
          ),
          Container(
            width: size.width * 0.35,
            height: size.height * 0.05,
            /*
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(size.width * 0.045)
            ),
            */
            child: TextFormField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.top,
              initialValue: (_valorUnitario??'').toString(),
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: size.width * 0.047,
                color: Colors.black.withOpacity(0.8),
                
              ),
              showCursor: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.4),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(size.width * 0.045)
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(size.width * 0.045)
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(size.width * 0.045)
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(size.width * 0.045)
                ),
                
                
                prefixIcon: Icon(
                  Icons.attach_money,
                  size: size.width * 0.045,
                )
              ),
              onChanged: (String newValue){
                _valorUnitario = int.parse(newValue);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearBotonSubmit(){
    return Center(
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.045)
        ),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical:size.height * 0.006),
        color: Colors.grey.withOpacity(0.75),
        child: Text(
          'Guardar',
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontSize: size.width * 0.045
          ),
        ),
        onPressed: (){
          _submit();
        },
      ),
    );
  }
  
  Future<void> _showDatePickerDia()async{
    Locale myLocale = Localizations.localeOf(context);
    DateTime nowDate = DateTime.now();
    _diaElegido = await showDatePicker(
      context: context, 
      initialDate: nowDate, 
      firstDate: nowDate, 
      lastDate: DateTime(
        nowDate.year + 1,
        nowDate.month,
        1
      ),
      locale: myLocale
    );
    _diaElegidoString = _formatDateToString(_diaElegido);
    setState(() {
      
    });
  }

  String _formatDateToString(DateTime dateTime){
    return '${utils.getStringDayByWeekNumberDay(dateTime.weekday)}, ${dateTime.day} de ${utils.getStringMonthByNumberMonth(dateTime.month)} de ${dateTime.year}';
  }

  void _submit()async{
    if(![_diaElegido, _cantidadPedidosMaximosPorHora, _cantidadProductosAVender, _valorUnitario].contains(null) && _rangosDeHoraSeleccionados.contains(true)){
      //TODO: implementar método editar producto
      Map<String, dynamic> programacionProducto = {};
      programacionProducto['fecha_venta'] = {
        'day':_diaElegido.day,
        'month':_diaElegido.month,
        'year':_diaElegido.year
      };
      programacionProducto['rangos_horario_entrega'] = [];
      for(int i = 0; i < 24; i++){
        if(_rangosDeHoraSeleccionados[i]){
          programacionProducto['rangos_horario_entrega'].add(
            {
              'hora_inicial':_rangosHorarioItems[i].elementAt(0),
              'hora_final':_rangosHorarioItems[i].elementAt(1)
            }
          );
        }
      }
      programacionProducto['pedidos_maximos_por_hora'] = _cantidadPedidosMaximosPorHora;
      programacionProducto['cantidad_total_a_vender'] = _cantidadProductosAVender;
      programacionProducto['valor_unitario'] = _valorUnitario;
      _producto.precio = _valorUnitario;
      Map<String, dynamic> editResponse = await productosBloc.editarProducto(Provider.usuarioBloc(context).token, _producto, programacionProducto);
      if(editResponse['status'] == 'ok')
        Navigator.of(context).pushNamed(ProductosTiendaPage.route);
    }
  }
}