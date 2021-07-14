import 'package:flutter/material.dart';

class ContainerTime extends StatelessWidget {
  final String numero;

  const ContainerTime({Key key, this.numero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE1BEE7),
        border: Border.all(color: Color(0xFF9C27B0)),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: SizedBox(
        width: 55,
        child: Center(
          child: Text(numero, style: const TextStyle(fontSize: 28, color: Color(0xFF9C27B0))),
        ),
      ),
    );
  }
}
