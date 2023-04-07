import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/textos.dart';

class TelaCarregamento extends StatelessWidget {
  const TelaCarregamento({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.all(10),
        width: larguraTela,
        height: alturaTela,
        color: PaletaCores.corAdtl,
        child: Center(
          child: SizedBox(
            width: larguraTela * 0.9,
            height: 150,
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Textos.txtTelaCarregamento,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(PaletaCores.corAdtl),
                      strokeWidth: 3.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
