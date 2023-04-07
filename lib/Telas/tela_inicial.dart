import 'package:flutter/material.dart';
import 'package:senturionscale/Modelos/TabelaModelo.dart';
import 'package:senturionscale/Uteis/conexao_banco_dados.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/estilo.dart';
import 'package:senturionscale/Uteis/textos.dart';
import 'package:senturionscale/Widgets/Tabelas/criar_tabela_widget.dart';
import 'package:senturionscale/Widgets/Tabelas/listagem_tabelas_banco_dados_widget.dart';
import 'package:senturionscale/Widgets/barra_navegacao_widget.dart';
import 'package:senturionscale/Widgets/tela_carregamento.dart';

class TelaInicial extends StatefulWidget {
  TelaInicial({Key? key, required this.tipoExibicao}) : super(key: key);

  String tipoExibicao;

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List<TabelaModelo> listaTabelasBancoDados = [];
  bool exibirTelaCarregamento = true;
  Estilo estilo = Estilo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.tipoExibicao == Constantes.tipoExibicaoListagemTabela){
      recuperarTabelasBancoDados();
    }else{
      exibirTelaCarregamento = false;
    }
  }

  recuperarTabelasBancoDados() async {
    await ConexaoBancoDados().recuperarTabelas().then(
      (value) {
        if (value == Constantes.erroBuscaBancoDados) {
         setState(() {
           widget.tipoExibicao == Constantes.tipoExibicaoCadastroTabela;
           exibirTelaCarregamento = false;
         });
        } else {
          setState(() {
            listaTabelasBancoDados = value;
            exibirTelaCarregamento = false;
          });
        }
      },
    );
  }

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
            title: Text(listaTabelasBancoDados.isEmpty
                ? Textos.tituloTelaCriarTabela
                : Textos.tituloTelaSelecaoTabelas),
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
                                child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      child: LayoutBuilder(
                                        builder: (p0, p1) {
                                          if (listaTabelasBancoDados.isEmpty) {
                                            return const CriarTabela();
                                          } else {
                                            return SizedBox(
                                              width: larguraTela,
                                              child:
                                                  ListagemTabelasBancoDadosWidget(
                                                tabelas: listaTabelasBancoDados,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                            const Expanded(flex: 1, child: BarraNavegacao())
                          ],
                        );
                      }
                    },
                  ))),
        ));
  }
}
