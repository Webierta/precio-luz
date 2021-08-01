import 'package:flutter/material.dart';

class HojaCalendario extends StatelessWidget {
  final String fecha;
  const HojaCalendario({Key key, this.fecha}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DateTime date = DateTime.parse(fecha).toLocal();
    //var dia = date.day.toString();
    //var anoMes = DateFormat('MMM yy').format(date).toString();
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(height: 1.0, color: Colors.white),
          ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.1),
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(fecha, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(height: 1.0, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
