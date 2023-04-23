import 'dart:async';

import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/metodos_auxiliares.dart';
import 'package:senturionscale/Widgets/tela_carregamento.dart';

class TelaSplashScreen extends StatefulWidget {
  const TelaSplashScreen({Key? key}) : super(key: key);

  @override
  State<TelaSplashScreen> createState() => _TelaSplashScreenState();
}

class _TelaSplashScreenState extends State<TelaSplashScreen> {
  @override
  void initState() {
    super.initState();
    MetodosAuxiliares metodosAuxiliares = MetodosAuxiliares();
    metodosAuxiliares.gravarDadosPadrao();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaCriarTabela);
    });
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          height: alturaTela,
          width: larguraTela,
          color: PaletaCores.corAdtl,
          child: SingleChildScrollView(
              child: SizedBox(
                  width: larguraTela,
                  height: alturaTela,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      const Image(
                        image: AssetImage('assets/imagens/Logo.png'),
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(
                        width: larguraTela,
                        height: 300,
                        child: const TelaCarregamento(),
                      ),

                    ],
                  )))),
    );
  }
}
