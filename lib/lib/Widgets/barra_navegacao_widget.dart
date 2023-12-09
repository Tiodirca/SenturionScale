import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/textos.dart';

class BarraNavegacao extends StatelessWidget {
  const BarraNavegacao({Key? key}) : super(key: key);

  Widget botoesIcones(String tipoIcone, BuildContext context) => SizedBox(
      height: 55,
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: const BorderSide(color: PaletaCores.corAdtl),
          backgroundColor: PaletaCores.corAzulClaro,
          elevation: 10,
          shadowColor: PaletaCores.corAdtl,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        onPressed: () {
          if (tipoIcone == Constantes.iconeAdicionar) {
            Navigator.pushReplacementNamed(
                context, Constantes.rotaTelaCriarTabela);
          } else if (tipoIcone == Constantes.iconeLista) {
            Navigator.pushReplacementNamed(
                context, Constantes.rotaTelaListagemTabelas);
          } else if (tipoIcone == Constantes.iconeConfiguracao) {
            Navigator.pushReplacementNamed(
                context, Constantes.rotaTelaConfiguracoes);
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (tipoIcone == Constantes.iconeLista) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.list_alt_outlined,
                    size: 30,
                  ),
                  Text(Textos.btnVerLista,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12)),
                ],
              );
            } else if (tipoIcone == Constantes.iconeAdicionar) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_circle_outline_outlined,
                    size: 30,
                  ),
                  Text(Textos.btnCriarTabela,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12)),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.settings,
                    size: 30,
                  ),
                  Text(Textos.btnConfiguracoes,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12)),
                ],
              );
            }
          },
        ),
      ));

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;

    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      elevation: 10,
      color: PaletaCores.corAdtl,
      child: SizedBox(
        width: larguraTela,
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            botoesIcones(Constantes.iconeAdicionar, context),
            botoesIcones(Constantes.iconeLista, context),
            botoesIcones(Constantes.iconeConfiguracao, context),
          ],
        ),
      ),
    );
  }
}
