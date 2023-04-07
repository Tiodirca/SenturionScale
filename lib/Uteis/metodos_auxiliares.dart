import 'package:flutter/material.dart';

class MetodosAuxiliares {
  static exibirMensagem(context, String msg) {
    final snackBarSucesso = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBarSucesso);
  }
}
