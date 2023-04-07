import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/ajustar_visualizacao.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/estilo.dart';
import 'package:senturionscale/Uteis/textos.dart';
import 'package:senturionscale/Widgets/barra_navegacao_widget.dart';
import 'package:senturionscale/Widgets/tela_carregamento.dart';

class TelaCadastro extends StatefulWidget {
  TelaCadastro({Key? key, required this.nomeTabela}) : super(key: key);

  String nomeTabela;

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  Estilo estilo = Estilo();
  bool exibirTelaCarregamento = false;
  TextEditingController ctPrimeiroHoraPulpito = TextEditingController(text: "");
  TextEditingController ctSegundoHoraPulpito = TextEditingController(text: "");
  TextEditingController ctPrimeiroHoraEntrada = TextEditingController(text: "");
  TextEditingController ctSegundoHoraEntrada = TextEditingController(text: "");
  TextEditingController ctRecolherOferta = TextEditingController(text: "");
  TextEditingController ctUniforme = TextEditingController(text: "");

  Widget camposFormulario(
          double larguraTela, TextEditingController controller, String label) =>
      Container(
        padding:
            const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
        width: AjustarVisualizacao.ajustarTextField(larguraTela),
        child: TextFormField(
          keyboardType: TextInputType.text,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return Textos.erroCampoVazio;
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
      );

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
            leading: IconButton(
                //setando tamanho do icone
                iconSize: 30,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, Constantes.rotaTelaInical,
                      arguments: Constantes.tipoExibicaoListagemTabela);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            title: Text(Textos.tituloTelaCadastro),
          ),
          body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SizedBox(
                  width: larguraTela,
                  height: alturaTela - alturaAppBar - alturaBarraStatus,
                  child: LayoutBuilder(
                    builder: (p0, p1) {
                      if (exibirTelaCarregamento) {
                        return Center(
                          child: SizedBox(
                            height: alturaTela * 0.2,
                            width: larguraTela,
                            child: const TelaCarregamento(),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Expanded(
                                flex: 9,
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    Text("fdsfsdd"),
                                    Container(
                                      padding:
                                      const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
                                      width: AjustarVisualizacao.ajustarTextField(larguraTela),
                                      child: TextFormField(
                                        onTap: (){
                                          print("fdsfs");
                                        },
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: "Data do Culto",
                                        ),
                                      ),
                                    ),
                                    Wrap(
                                      children: [
                                        camposFormulario(
                                            larguraTela,
                                            ctPrimeiroHoraPulpito,
                                            Textos.labelPrimeiroHoraPulpito),
                                        camposFormulario(
                                            larguraTela,
                                            ctSegundoHoraPulpito,
                                            Textos.labelSegundoHoraPulpito),
                                        camposFormulario(
                                            larguraTela,
                                            ctPrimeiroHoraEntrada,
                                            Textos.labelPrimeiroHoraEntrada),
                                        camposFormulario(
                                            larguraTela,
                                            ctPrimeiroHoraPulpito,
                                            Textos.labelPrimeiroHoraPulpito),
                                        camposFormulario(
                                            larguraTela,
                                            ctRecolherOferta,
                                            Textos.labelRecolherOferta),
                                        camposFormulario(larguraTela,
                                            ctUniforme, Textos.labelUniforme),
                                      ],
                                    ),
                                    Container(
                                      width: larguraTela,
                                      height: 100,
                                      child: Card(),
                                    )
                                  ],
                                ))),
                            const Expanded(flex: 1, child: BarraNavegacao())
                          ],
                        );
                      }
                    },
                  ))),
        ));
  }
}
