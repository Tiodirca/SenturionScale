import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/estilo.dart';
import 'package:senturionscale/Uteis/textos.dart';
import 'package:senturionscale/Widgets/barra_navegacao_widget.dart';

class TelaInicial extends StatelessWidget {
  TelaInicial({Key? key}) : super(key: key);

  Estilo estilo = Estilo();

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;

    return Theme(
        data: estilo.estiloGeral,
        child: Scaffold(
          appBar: AppBar(
            title: Text(Textos.nomeAplicacao),
          ),
          body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SizedBox(
                  width: larguraTela,
                  height: alturaTela - alturaAppBar - alturaBarraStatus,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 9,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(20),
                                width: 150,
                                height: 70,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          PaletaCores.corVerdeCiano),
                                  child: Text(
                                    Textos.btnCriarTabela,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context,
                                        Constantes.rotaTelaCriarTabela);
                                  },
                                ),
                              ),
                            ],
                          )),
                      const Expanded(flex: 1, child: BarraNavegacao())
                    ],
                  ))),
        ));
  }
}
