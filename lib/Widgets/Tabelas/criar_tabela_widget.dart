import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/ajustar_visualizacao.dart';
import 'package:senturionscale/Uteis/conexao_banco_dados.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/estilo.dart';
import 'package:senturionscale/Uteis/textos.dart';

class CriarTabela extends StatefulWidget {
  const CriarTabela({Key? key}) : super(key: key);

  @override
  State<CriarTabela> createState() => _CriarTabelaState();
}

class _CriarTabelaState extends State<CriarTabela> {
  Estilo estilo = Estilo();
  final _formKeyTabela = GlobalKey<FormState>();
  final TextEditingController _controllerCadastrarTabela =
      TextEditingController(text: "");
  ConexaoBancoDados conexaoBancoDados = ConexaoBancoDados();

  criarTabelaBancoDados() async {
    String retorno =
        await conexaoBancoDados.criarTabela(_controllerCadastrarTabela.text);
    if (retorno == Constantes.sucessoCriarTabela) {
      final snackBar = SnackBar(content: Text(Textos.sucessoMsgCriarTabela));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text(Textos.erroMsgCriarTabela));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return Theme(
      data: estilo.estiloGeral,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
        width: larguraTela,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Recarregar"),
                SizedBox(
                  width: 45,
                  height: 45,
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: const Icon(Icons.update_outlined),
                  ),
                )
              ],
            ),
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
                      left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
                  width: AjustarVisualizacao.ajustarTextField(larguraTela),
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
              width: 200,
              height: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: PaletaCores.corVerdeCiano),
                child: Text(
                  Textos.btnCriarTabela,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  if (_formKeyTabela.currentState!.validate()) {
                    criarTabelaBancoDados();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
