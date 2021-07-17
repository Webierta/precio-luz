import 'package:flutter/material.dart';
import '../widgets/tab_main.dart';
import '../widgets/appbar.dart';
import '../widgets/tab_page_range.dart';
import '../widgets/tab_page.dart';
import '../services/datos.dart';
import 'grafico.dart';

class Resultado extends StatefulWidget {
  final Datos data;
  final String fecha;
  final Datos dataHoy;
  const Resultado({Key key, this.data, this.fecha, this.dataHoy}) : super(key: key);
  @override
  _ResultadoState createState() => _ResultadoState();
}

class _ResultadoState extends State<Resultado> {
  var _currentPage = 0;
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      TabMain(
        fecha: widget.fecha,
        data: widget.data,
        dataHoy: widget.dataHoy,
      ),
      TabPage(
          page: 2,
          fecha: widget.fecha,
          titulo: 'Evolución del Precio en el día',
          data: widget.data),
      TabPage(
        page: 3,
        fecha: widget.fecha,
        titulo: 'Horas por Precio ascendente',
        data: widget.data,
      ),
      TabPageRange(fecha: widget.fecha, data: widget.data),
    ];

    return Scaffold(
      appBar: BaseAppBar(title: const Text('Datos PVPC'), appBar: AppBar()),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, //TODO: REVISAR
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          controller: _scrollController,
          child: _pages.elementAt(_currentPage),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'PVPC',
            backgroundColor: Color(0xFF0D47A1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.euro_symbol),
            activeIcon: Icon(Icons.upgrade),
            label: 'PRECIO',
            backgroundColor: Color(0xFF0D47A1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            activeIcon: Icon(Icons.upgrade),
            label: 'HORAS',
            backgroundColor: Color(0xFF0D47A1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            activeIcon: Icon(Icons.upgrade),
            label: 'FRANJAS',
            backgroundColor: Color(0xFF0D47A1),
          ),
        ],
        currentIndex: _currentPage,
        //type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white, //fixedColor: Colors.white,
        //backgroundColor: Color(0xFF0D47A1),
        unselectedItemColor: Colors.white60,
        onTap: (int inIndex) {
          _scrollController.animateTo(_scrollController.position.minScrollExtent,
              duration: Duration(seconds: 1), curve: Curves.ease);
          if (_currentPage != inIndex) {
            setState(() => _currentPage = inIndex);
          }
        },
      ),
      floatingActionButton: _currentPage == 1
          ? FloatingActionButton(
              child: Icon(Icons.bar_chart),
              onPressed: () {
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Grafico(
                      data: widget.data,
                      fecha: widget.fecha,
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
