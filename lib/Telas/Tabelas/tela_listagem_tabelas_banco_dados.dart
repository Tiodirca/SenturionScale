import 'package:flutter/material.dart';
import 'package:senturionscale/Modelos/exibir_tabelas.dart';
import 'package:senturionscale/Uteis/AcoesBancoDados/AcoesBancoDadosTabelas.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/estilo.dart';
import 'package:senturionscale/Uteis/textos.dart';
import 'package:senturionscale/Widgets/barra_navegacao_widget.dart';
import 'package:senturionscale/Widgets/tela_carregamento.dart';

class TelaListagemTabelasBancoDados extends StatefulWidget {
  const TelaListagemTabelasBancoDados({Key? key}) : super(key: key);

  @override
  State<TelaListagemTabelasBancoDados> createState() =>
      _TelaListagemTabelasBancoDadosState();
}

class _TelaListagemTabelasBancoDadosState
    extends State<TelaListagemTabelasBancoDados> {
  String nomeItemDrop = "";
  String nomeTabelaSelecionada = "";
  bool exibirConfirmacaoTabelaSelecionada = false;
  Estilo estilo = Estilo();
  bool exibirTelaCarregamento = true;
  List<ExibirTabelas> tabelasBancoDados = [];

  @override
  void initState() {
    super.initState();
    fazerConsultaTabelasBancoDados();
  }

  // metodo para fazer consulta
  // ao banco de dados
  fazerConsultaTabelasBancoDados() async {
    AcoesBancoDadosTabelas.recuperarTabelas().then(
          (value) {
        if (value.isEmpty) {
          setState(() {
            nomeItemDrop = "";
            exibirTelaCarregamento = false;
          });
        } else {
          setState(() {
            tabelasBancoDados = value;
            nomeItemDrop = value.first.tabelas;
            exibirTelaCarregamento = false;
          });
        }
      },
    );
  }

  Future<void> alertaExclusao(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Textos.tituloAlerta,
            style: const TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  Textos.descricaoAlerta,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: [
                    Text(
                      nomeTabelaSelecionada,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Não',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Sim',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                chamarDeletar();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Metodo para chamar deletar tabela
  chamarDeletar() async {
    setState(() {
      exibirTelaCarregamento = true;
    });
    String retornoAcao =
    await AcoesBancoDadosTabelas.deletarTabela(nomeTabelaSelecionada);
    if (retornoAcao == Constantes.retornoSucessoBancoDado) {
      // Resetando valores
      setState(() {
        tabelasBancoDados = [];
        nomeItemDrop = "";
        nomeTabelaSelecionada = "";
        exibirConfirmacaoTabelaSelecionada = false;
      });
      exibirMsg(Textos.sucessoMsgExcluirEscala);
      fazerConsultaTabelasBancoDados();
    } else {
      setState(() {
        exibirTelaCarregamento = false;
      });
      exibirMsg(Textos.erroMsgExcluirEscala);
    }
  }

  exibirMsg(String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget botoesAcoes(String nomeBotao, Color corBotao) =>
      SizedBox(
          height: 40,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: corBotao),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            onPressed: () async {
              if (nomeBotao == Constantes.iconeAdicionar) {
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaCriarTabela);
              } else if (nomeBotao == Constantes.iconeRecarregar) {
                setState(() {
                  exibirTelaCarregamento = true;
                });
                fazerConsultaTabelasBancoDados();
              } else {
                alertaExclusao(context);
              }
            },
            child: LayoutBuilder(
              builder: (p0, p1) {
                if (nomeBotao == Constantes.iconeAdicionar) {
                  return const Icon(
                    Icons.add_circle_outline_outlined,
                    color: PaletaCores.corAdtl,
                  );
                } else if (nomeBotao == Constantes.iconeRecarregar) {
                  return const Icon(Icons.refresh, color: PaletaCores.corAdtl);
                } else {
                  return const Center(
                      child: Icon(
                        Icons.close_outlined,
                        color: PaletaCores.corAdtl,
                        size: 30,
                      ));
                }
              },
            ),
          ));

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery
        .of(context)
        .size
        .width;
    double alturaTela = MediaQuery
        .of(context)
        .size
        .height;

    return Theme(
      data: estilo.estiloGeral,
      child: Scaffold(
          appBar: AppBar(
            title: Visibility(
              visible: !exibirTelaCarregamento,
              child: Text(
                Textos.tituloTelaSelecaoTabelas,
              ),
            ),
            leading: Visibility(
              visible: !exibirTelaCarregamento,
              child: IconButton(
                //setando tamanho do icone
                  iconSize: 30,
                  color: Colors.white,
                  enableFeedback: false,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Constantes.rotaTelaCriarTabela);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            ),
          ),
          body: SizedBox(
          width: larguraTela,
          height: alturaTela,
          child: LayoutBuilder(
            builder: (p0, p1) {
              if (exibirTelaCarregamento) {
                return const Center(
                  child: TelaCarregamento(),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 9,
                        child: LayoutBuilder(
                          builder: (p0, p1) {
                            if (tabelasBancoDados.isEmpty) {
                              return Container(
                                margin: const EdgeInsets.all(30),
                                width: larguraTela,
                                height: alturaTela,
                                child: Column(
                                  children: [
                                    Container(
                                      margin:
                                      const EdgeInsets.symmetric(
                                          vertical: 20),
                                      width: larguraTela * 0.5,
                                      child: Text(
                                          Textos
                                              .descricaoErroConsultasBancoDados,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight:
                                              FontWeight.bold),
                                          textAlign: TextAlign.center),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceEvenly,
                                        children: [
                                          botoesAcoes(
                                              Constantes
                                                  .iconeAdicionar,
                                              PaletaCores
                                                  .corRosaAvermelhado),
                                          botoesAcoes(
                                              Constantes
                                                  .iconeRecarregar,
                                              PaletaCores.corAdtlLetras)
                                        ]),
                                  ],
                                ),
                              );
                            } else {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: larguraTela,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      Textos.descricaoDropDownTabelas,
                                      style:
                                      const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  DropdownButton(
                                    value: nomeItemDrop,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 40, color: Colors.black,),
                                    items: tabelasBancoDados
                                        .map((item) =>
                                        DropdownMenuItem<String>(
                                          value: item.tabelas,
                                          child: Text(
                                            item.tabelas.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 20),
                                          ),
                                        ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        nomeItemDrop = value!;
                                        nomeTabelaSelecionada =
                                            nomeItemDrop;
                                        exibirConfirmacaoTabelaSelecionada =
                                        true;
                                      });
                                    },
                                  ),
                                  Visibility(
                                      visible:
                                      exibirConfirmacaoTabelaSelecionada,
                                      child: Container(
                                          margin:
                                          const EdgeInsets.all(10),
                                          width: larguraTela,
                                          child: Column(
                                            children: [
                                              Wrap(
                                                crossAxisAlignment:
                                                WrapCrossAlignment
                                                    .center,
                                                alignment: WrapAlignment
                                                    .center,
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign
                                                        .center,
                                                    Textos
                                                        .descricaoTabelaSelecionada,
                                                    style:
                                                    const TextStyle(
                                                        fontSize:
                                                        20),
                                                  ),
                                                  Text(
                                                    textAlign: TextAlign
                                                        .center,
                                                    nomeTabelaSelecionada,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                  Container(
                                                    margin:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        20),
                                                    child: botoesAcoes(
                                                        Constantes
                                                            .iconeExclusao,
                                                        PaletaCores
                                                            .corRosaAvermelhado),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin: const EdgeInsets
                                                    .all(20),
                                                width: 150,
                                                height: 70,
                                                child: ElevatedButton(
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                      backgroundColor:
                                                      PaletaCores
                                                          .corVerdeCiano),
                                                  child: Text(
                                                    Textos
                                                        .btnUsarTabela,
                                                    textAlign: TextAlign
                                                        .center,
                                                    style:
                                                    const TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                        18),
                                                  ),
                                                  onPressed: () {
                                                    Navigator
                                                        .pushReplacementNamed(
                                                        context,
                                                        Constantes
                                                            .rotaTelaListagemItens,
                                                        arguments:
                                                        nomeTabelaSelecionada);
                                                  },
                                                ),
                                              )
                                            ],
                                          )))
                                ],
                              );
                            }
                          },
                        )),
                    const Expanded(flex: 1, child: BarraNavegacao())
                  ],
                );
              }
            },
          )),
    ));
  }
}
