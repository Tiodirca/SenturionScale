import 'package:flutter/material.dart';

class MetodosAuxiliares {
  exibirMsg(String msg,BuildContext context) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
