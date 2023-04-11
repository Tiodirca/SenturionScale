import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/AcoesBancoDados/AcoesBancoDadosTabelas.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/ajustar_visualizacao.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/estilo.dart';
import 'package:senturionscale/Uteis/textos.dart';
import 'package:senturionscale/Widgets/barra_navegacao_widget.dart';
import 'package:senturionscale/Widgets/tela_carregamento.dart';

class TelaCriarTabelaBanco extends StatefulWidget {
  const TelaCriarTabelaBanco({Key? key}) : super(key: key);

  @override
  State<TelaCriarTabelaBanco> createState() => _TelaCriarTabelaBancoState();
}

class _TelaCriarTabelaBancoState extends State<TelaCriarTabelaBanco> {
  Estilo estilo = Estilo();
  bool exibirTelaCarregamento = false;

  final _formKeyTabela = GlobalKey<FormState>();
  final TextEditingController _controllerCadastrarTabela =
      TextEditingController(text: "");

  criarTabelaBancoDados() async {
    setState(() {
      exibirTelaCarregamento = true;
    });
    String retorno = await AcoesBancoDadosTabelas.criarTabela(
        _controllerCadastrarTabela.text);
    if (retorno == Constantes.retornoSucessoBancoDado) {
      exibirMsg(Textos.sucessoMsgCriarTabela);
      redirecionarTela();
    } else {
      exibirMsg(Textos.erroMsgCriarTabela);
      setState(() {
        exibirTelaCarregamento = false;
      });
    }
  }

  redirecionarTela() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaCadastro,
        arguments: _controllerCadastrarTabela.text);
  }

  exibirMsg(String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return Theme(
        data: estilo.estiloGeral,
        child: Scaffold(
          appBar: AppBar(
            title: Text(Textos.tituloTelaCriarTabela),
          ),
          body: GestureDetector(onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          }, child: LayoutBuilder(
            builder: (p0, p1) {
              if (exibirTelaCarregamento) {
                return const TelaCarregamento();
              } else {
                return SizedBox(
                  width: larguraTela,
                  height: alturaTela,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 9,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                width: larguraTela,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  Textos.descricaoCriarTabela,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Form(
                                  key: _formKeyTabela,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 5.0,
                                        top: 5.0,
                                        right: 5.0,
                                        bottom: 5.0),
                                    width: AjustarVisualizacao.ajustarTextField(
                                        larguraTela),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: _controllerCadastrarTabela,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return Textos.erroCampoVazio;
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: Textos.labelNomeTabela,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                                    if (_formKeyTabela.currentState!
                                        .validate()) {
                                      criarTabelaBancoDados();
                                    }
                                  },
                                ),
                              )
                            ],
                          )),
                      const Expanded(flex: 1, child: BarraNavegacao())
                    ],
                  ),
                );
              }
            },
          )),
        ));
  }
}
