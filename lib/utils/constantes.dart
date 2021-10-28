import 'package:flutter/material.dart';

const BoxDecoration kBoxDeco = BoxDecoration(
  color: Color.fromRGBO(255, 255, 255, 0.1),
  border: Border(
    bottom: BorderSide(color: Color(0xFF1565C0), width: 1.5),
    left: BorderSide(color: Color(0xFF1565C0), width: 1.5),
  ),
);

const ShapeBorderClipper kBorderClipper = ShapeBorderClipper(
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

const TextStyle sizeText20 = TextStyle(fontSize: 20.0);
