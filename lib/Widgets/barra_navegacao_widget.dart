import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';

class BarraNavegacao extends StatelessWidget {
  const BarraNavegacao({Key? key}) : super(key: key);

  Widget botoesIcones(String tipoIcone, BuildContext context) => SizedBox(
      height: 60,
      width: 60,
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
          if (tipoIcone == Constantes.tipoIconeHome) {
            Navigator.pushReplacementNamed(context, Constantes.rotaTelaInical);
          } else if (tipoIcone == Constantes.tipoIconeAdicionar) {
            Navigator.pushReplacementNamed(
                context, Constantes.rotaTelaCriarTabela);
          } else if (tipoIcone == Constantes.tipoIconeLista) {
            Navigator.pushReplacementNamed(
                context, Constantes.rotaTelaListagemTabelas);
          } else if (tipoIcone == Constantes.tipoIconeConfiguracao) {
            Navigator.pushReplacementNamed(
                context, Constantes.rotaTelaConfiguracoes);
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (tipoIcone == Constantes.tipoIconeHome) {
              return const Icon(
                Icons.home_filled,
                size: 30,
              );
            } else if (tipoIcone == Constantes.tipoIconeLista) {
              return const Icon(
                Icons.list_alt_outlined,
                size: 30,
              );
            } else if (tipoIcone == Constantes.tipoIconeAdicionar) {
              return const Icon(
                Icons.add_circle_outline_outlined,
                size: 30,
              );
            } else {
              return const Icon(
                Icons.settings,
                size: 30,
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
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            botoesIcones(Constantes.tipoIconeHome, context),
            botoesIcones(Constantes.tipoIconeAdicionar, context),
            botoesIcones(Constantes.tipoIconeLista, context),
            botoesIcones(Constantes.tipoIconeConfiguracao, context),
          ],
        ),
      ),
    );
  }
}
