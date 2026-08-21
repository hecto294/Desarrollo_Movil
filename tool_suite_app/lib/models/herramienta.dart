import 'package:flutter/material.dart';

class Herramienta {
  final String id;
  final String titulo;
  final String descripcion;
  final IconData icono;
  final Color color;
  final Widget pantallaDestino;

  Herramienta({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.pantallaDestino,
  });
}