import 'dart:async';

import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Widgets/tela_carregamento.dart';

class TelaSplashScreen extends StatefulWidget {
  const TelaSplashScreen({Key? key}) : super(key: key);

  @override
  State<TelaSplashScreen> createState() => _TelaSplashScreenState();
}

class _TelaSplashScreenState extends State<TelaSplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaInical,
          arguments: Constantes.tipoExibicaoListagemTabela);
    });
  }
  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;
    return Scaffold(
      body: Container(
          height: alturaTela,
          width: larguraTela,
          color: PaletaCores.corAzul,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                // FundoTela(
                //     altura: alturaTela - alturaBarraStatus - alturaAppBar),
                Positioned(
                    child: SizedBox(
                        width: larguraTela,
                        height: alturaTela - alturaBarraStatus - alturaAppBar,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SizedBox(
                            //   width: larguraTela * 0.9,
                            //   height: alturaTela * 0.2,
                            //   child: Image.asset(
                            //     "assets/imagens/logo_app.png",
                            //   ),
                            // ),
                            const TelaCarregamento()
                          ],
                        )))
              ],
            ),
          )),
    );
  }
}
