import 'dart:ui';

import 'package:flutter/material.dart';

class ScrollBehaviorPersonalizado extends MaterialScrollBehavior {
  // sobre escrevendo behavior metodo e getters para arrastar horizontalmente
  //conteudo da tela dependendo do dispositivo
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}