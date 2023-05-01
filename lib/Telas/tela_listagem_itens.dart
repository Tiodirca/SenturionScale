import 'package:flutter/material.dart';
import 'package:senturionscale/Modelos/escala_modelo.dart';
import 'package:senturionscale/Uteis/AcoesBancoDados/AcaoBancoDadosItensEscala.dart';
import 'package:senturionscale/Uteis/PDF/GerarPDF.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:intl/intl.dart';
import 'package:senturionscale/Uteis/estilo.dart';
import 'package:senturionscale/Uteis/metodos_auxiliares.dart';
import 'package:senturionscale/Uteis/textos.dart';
import 'package:senturionscale/Widgets/barra_navegacao_widget.dart';
import 'package:senturionscale/Widgets/tela_carregamento.dart';

class TelaListagemItens extends StatefulWidget {
  TelaListagemItens({Key? key, required this.nomeTabela}) : super(key: key);

  String nomeTabela;

  @override
  State<TelaListagemItens> createState() => _TelaListagemItensState();
}

class _TelaListagemItensState extends State<TelaListagemItens> {
  Estilo estilo = Estilo();
  bool exibirTelaCarregamento = true;
  bool exibirOcultarCampoRecolherOferta = false;
  bool exibirOcultarCampoIrmaoReserva = false;
  bool exibirOcultarCampoMesaApoio = false;
  bool exibirOcultarServirSantaCeia = false;
  late List<EscalaModelo> escala;

  @override
  void initState() {
    super.initState();
    escala = [];
    recuparValoresBancoDados();
  }

  recuparValoresBancoDados() async {
    await AcaoBancoDadosItensEscala.recuperarItens(
            MetodosAuxiliares.removerEspacoNomeTabelas(widget.nomeTabela),
            AcaoBancoDadosItensEscala.acaoRecupearDados,
            "SemID")
        .then(
      (escalaBanco) {
        setState(() {
          if (escalaBanco.isEmpty) {
            exibirTelaCarregamento = false;
          } else {
            escalaBanco.sort((a, b) => DateFormat("dd/MM/yyyy EEEE", "pt_BR")
                .parse(a.dataCulto)
                .compareTo(
                    DateFormat("dd/MM/yyyy EEEE", "pt_BR").parse(b.dataCulto)));
            escala = escalaBanco;
            exibirTelaCarregamento = false;
            chamarVerificarColunaVazia();
          }
        });
      },
    );
  }

  // metodo para chamar metodo para verificar
  // se a coluna esta vazia
  chamarVerificarColunaVazia() {
    for (var element in escala) {
      if (element.mesaApoio.isNotEmpty) {
        exibirOcultarCampoMesaApoio = true;
        break;
      } else {
        exibirOcultarCampoMesaApoio = false;
      }
    }
    for (var element in escala) {
      if (element.irmaoReserva.isNotEmpty) {
        exibirOcultarCampoIrmaoReserva = true;
        break;
      } else {
        exibirOcultarCampoIrmaoReserva = false;
      }
    }
    for (var element in escala) {
      if (element.recolherOferta.isNotEmpty) {
        exibirOcultarCampoRecolherOferta = true;
        break;
      } else {
        exibirOcultarCampoRecolherOferta = false;
      }
    }
    for (var element in escala) {
      if (element.servirSantaCeia.isNotEmpty) {
        exibirOcultarServirSantaCeia = true;
        break;
      } else {
        exibirOcultarServirSantaCeia = false;
      }
    }
  }

  // metodo para verificar se a coluna
  // contem algum valor em uma de suas linhas
  verificarColunaVazia(String valor) {
    if (valor.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  chamarDeletar(EscalaModelo escalaModelo) {
    AcaoBancoDadosItensEscala.deletar(escalaModelo.id,
            MetodosAuxiliares.removerEspacoNomeTabelas(widget.nomeTabela))
        .then((result) {
      if (Constantes.retornoSucessoBancoDado == result) {
        const snackBarSucesso =
            SnackBar(content: Text('Item apagado com sucesso.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBarSucesso);
        //chamando metodo
        escala = [];
        recuparValoresBancoDados();
      }
    });
  }

  // metodo para chamar a geracao do arquivo em pdf
  // e permitir o usuario baixar o arquivo
  chamarGerarArquivoPDF() {
    GerarPDF gerarPDF = GerarPDF(
        escala: escala,
        nomeEscala: widget.nomeTabela,
        exibirMesaApoio: exibirOcultarCampoMesaApoio,
        exibirRecolherOferta: exibirOcultarCampoRecolherOferta,
        exibirIrmaoReserva: exibirOcultarCampoIrmaoReserva,
        exibirServirSantaCeia: exibirOcultarServirSantaCeia);
    gerarPDF.pegarDados();
  }

  Widget botoesAcoes(
          String nomeBotao, Color corBotao, double largura, double altura) =>
      SizedBox(
          height: altura,
          width: largura,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: corBotao),
                backgroundColor: Colors.white,
                elevation: 10,
                shadowColor: PaletaCores.corAdtl,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onPressed: () async {
                if (nomeBotao == Constantes.iconeBaixar) {
                  chamarGerarArquivoPDF();
                } else if (nomeBotao == Constantes.iconeAdicionar) {
                  Navigator.pushReplacementNamed(
                      context, Constantes.rotaTelaCadastro,
                      arguments: widget.nomeTabela);
                } else if (nomeBotao == Constantes.iconeRecarregar) {
                  setState(() {
                    exibirTelaCarregamento = true;
                  });
                  recuparValoresBancoDados();
                } else {
                  Navigator.pushReplacementNamed(
                      context, Constantes.rotaTelaCadastro,
                      arguments: widget.nomeTabela);
                }
              },
              child: LayoutBuilder(
                builder: (p0, p1) {
                  if (nomeBotao == Constantes.iconeBaixar) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.file_download_outlined,
                            color: PaletaCores.corAdtl, size: 30),
                        Text(
                          Textos.btnBaixar,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: PaletaCores.corAdtl),
                        )
                      ],
                    );
                  } else if (nomeBotao == Constantes.iconeAdicionar) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle_outline,
                            color: PaletaCores.corAdtl, size: 30),
                        Text(
                          Textos.btnAdicionar,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: PaletaCores.corAdtl),
                        )
                      ],
                    );
                  } else if (nomeBotao == Constantes.iconeAdicionarEscala) {
                    return const Icon(
                      Icons.add_circle_outline_outlined,
                      color: PaletaCores.corAdtl,
                    );
                  } else {
                    return const Icon(Icons.refresh,
                        color: PaletaCores.corAdtl);
                  }
                },
              )));

  Future<void> alertaExclusao(EscalaModelo escala, BuildContext context) async {
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
                      escala.dataCulto,
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
                setState(() {
                  exibirTelaCarregamento = true;
                });
                chamarDeletar(escala);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
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
        child: WillPopScope(
            onWillPop: () async {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaListagemTabelas);
              return false;
            },
            child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      //setando tamanho do icone
                      iconSize: 30,
                      enableFeedback: false,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Constantes.rotaTelaListagemTabelas);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  title: SizedBox(
                    width: larguraTela,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Textos.tituloTelaListagemItens),
                      ],
                    ),
                  ),
                ),
                body: SizedBox(
                    width: larguraTela,
                    height: alturaTela - alturaAppBar - alturaBarraStatus,
                    child: LayoutBuilder(
                      builder: (p0, p1) {
                        if (exibirTelaCarregamento) {
                          return const TelaCarregamento();
                        } else if (escala.isEmpty) {
                          return Container(
                            margin: const EdgeInsets.all(30),
                            width: larguraTela,
                            height: alturaTela,
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  width: larguraTela * 0.5,
                                  child: Text(
                                      Textos.descricaoErroConsultasBancoDados,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      botoesAcoes(
                                          Constantes.iconeAdicionarEscala,
                                          PaletaCores.corRosaAvermelhado,
                                          60,
                                          40),
                                      botoesAcoes(Constantes.iconeRecarregar,
                                          PaletaCores.corAdtlLetras, 60, 40)
                                    ]),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              Expanded(
                                  flex: 8,
                                  child: SingleChildScrollView(
                                      child: SizedBox(
                                    width: larguraTela,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          width: larguraTela,
                                          child: Text(
                                              Textos.descricaoTabelaSelecionada +
                                                  widget.nomeTabela,
                                              textAlign: TextAlign.end),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 0),
                                          width: larguraTela,
                                          child: Text(
                                              Textos.descricaoTelaListagemItens,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                              textAlign: TextAlign.center),
                                        ),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 0.0),
                                            height: alturaTela * 0.5,
                                            width: larguraTela,
                                            child: Center(
                                              child: ListView(
                                                children: [
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: DataTable(
                                                      columnSpacing: 10,
                                                      columns: [
                                                        DataColumn(
                                                            label: Text(
                                                                Textos
                                                                    .labelData,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center)),
                                                        DataColumn(
                                                          label: Text(
                                                              Textos
                                                                  .labelHorarioTroca,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        ),
                                                        DataColumn(
                                                            label: Visibility(
                                                          visible:
                                                              !exibirOcultarCampoMesaApoio,
                                                          child: Text(
                                                              Textos
                                                                  .labelPrimeiroHoraPulpito,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        )),
                                                        DataColumn(
                                                            label: Visibility(
                                                          visible:
                                                              !exibirOcultarCampoMesaApoio,
                                                          child: Text(
                                                              Textos
                                                                  .labelSegundoHoraPulpito,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        )),
                                                        DataColumn(
                                                            label: Text(
                                                                Textos
                                                                    .labelPrimeiroHoraEntrada,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center)),
                                                        DataColumn(
                                                          label: Text(
                                                              Textos
                                                                  .labelSegundoHoraEntrada,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        ),
                                                        DataColumn(
                                                            label: Visibility(
                                                          visible:
                                                              exibirOcultarCampoMesaApoio,
                                                          child: Text(
                                                              Textos
                                                                  .labelMesaApoio,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        )),
                                                        DataColumn(
                                                          label: Text(
                                                              Textos
                                                                  .labelUniforme,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        ),
                                                        DataColumn(
                                                            label: Visibility(
                                                          visible:
                                                              exibirOcultarCampoRecolherOferta,
                                                          child: Text(
                                                              Textos
                                                                  .labelRecolherOferta,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        )),
                                                        DataColumn(
                                                            label: Visibility(
                                                          visible:
                                                              exibirOcultarServirSantaCeia,
                                                          child: Text(
                                                              Textos
                                                                  .labelServirSantaCeia,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        )),
                                                        DataColumn(
                                                            label: Visibility(
                                                          visible:
                                                              exibirOcultarCampoIrmaoReserva,
                                                          child: Text(
                                                              Textos
                                                                  .labelIrmaoReserva,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        )),
                                                        DataColumn(
                                                          label: Text(
                                                              Textos
                                                                  .labelEditar,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        ),
                                                        DataColumn(
                                                          label: Text(
                                                              Textos
                                                                  .labelExcluir,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        ),
                                                      ],
                                                      rows: escala
                                                          .map(
                                                            (item) => DataRow(
                                                                cells: [
                                                                  DataCell(SizedBox(
                                                                      width: 90,
                                                                      //SET width
                                                                      child: SingleChildScrollView(
                                                                        child: Text(
                                                                            item
                                                                                .dataCulto,
                                                                            textAlign:
                                                                                TextAlign.center),
                                                                      ))),
                                                                  DataCell(Container(
                                                                      alignment: Alignment.center,
                                                                      width: 150,
                                                                      //SET width
                                                                      child: SingleChildScrollView(
                                                                        child: Text(
                                                                            item
                                                                                .horarioTroca,
                                                                            textAlign:
                                                                                TextAlign.center),
                                                                      ))),
                                                                  DataCell(
                                                                      Visibility(
                                                                    visible:
                                                                        !exibirOcultarCampoMesaApoio,
                                                                    child: SizedBox(
                                                                        width: 90,
                                                                        //SET width
                                                                        child: Text(item.primeiraHoraPulpito, textAlign: TextAlign.center)),
                                                                  )),
                                                                  DataCell(
                                                                      Visibility(
                                                                    visible:
                                                                        !exibirOcultarCampoMesaApoio,
                                                                    child: SizedBox(
                                                                        width: 90,
                                                                        //SET width
                                                                        child: Text(item.segundaHoraPulpito, textAlign: TextAlign.center)),
                                                                  )),
                                                                  DataCell(SizedBox(
                                                                      width: 90,
                                                                      //SET width
                                                                      child: Text(item.primeiraHoraEntrada, textAlign: TextAlign.center))),
                                                                  DataCell(SizedBox(
                                                                      width: 90,
                                                                      //SET width
                                                                      child: Text(item.segundaHoraEntrada, textAlign: TextAlign.center))),
                                                                  DataCell(
                                                                      Visibility(
                                                                    visible:
                                                                        exibirOcultarCampoMesaApoio,
                                                                    child: SizedBox(
                                                                        width: 90,
                                                                        //SET width
                                                                        child: Text(item.mesaApoio, textAlign: TextAlign.center)),
                                                                  )),
                                                                  DataCell(SizedBox(
                                                                      width: 150,
                                                                      //SET width
                                                                      child: SingleChildScrollView(
                                                                        child: Text(
                                                                            item
                                                                                .uniforme,
                                                                            textAlign:
                                                                                TextAlign.center),
                                                                      ))),
                                                                  DataCell(
                                                                      Visibility(
                                                                    visible:
                                                                        exibirOcultarCampoRecolherOferta,
                                                                    child: SizedBox(
                                                                        width: 90,
                                                                        //SET width
                                                                        child: Text(item.recolherOferta, textAlign: TextAlign.center)),
                                                                  )),
                                                                  DataCell(
                                                                      Visibility(
                                                                    visible:
                                                                        exibirOcultarServirSantaCeia,
                                                                    child: SizedBox(
                                                                        width: 90,
                                                                        //SET width
                                                                        child: Text(item.servirSantaCeia, textAlign: TextAlign.center)),
                                                                  )),
                                                                  DataCell(
                                                                      Visibility(
                                                                    visible:
                                                                        exibirOcultarCampoIrmaoReserva,
                                                                    child: SizedBox(
                                                                        width: 90,
                                                                        //SET width
                                                                        child: Text(item.irmaoReserva, textAlign: TextAlign.center)),
                                                                  )),
                                                                  DataCell(
                                                                      ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      side: const BorderSide(
                                                                          color:
                                                                              PaletaCores.corAdtlLetras),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10))),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      var dados =
                                                                          {};
                                                                      dados[Constantes
                                                                              .nomeTabela] =
                                                                          widget
                                                                              .nomeTabela;
                                                                      dados[Constantes
                                                                              .idItem] =
                                                                          item.id;
                                                                      Navigator.pushReplacementNamed(
                                                                          context,
                                                                          Constantes
                                                                              .rotaTelaAtualizarItem,
                                                                          arguments:
                                                                              dados);
                                                                    },
                                                                    child: const Icon(
                                                                        Icons
                                                                            .edit_outlined,
                                                                        size:
                                                                            20,
                                                                        color: PaletaCores
                                                                            .corAdtl),
                                                                  )),
                                                                  DataCell(
                                                                      ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      side: const BorderSide(
                                                                          color:
                                                                              PaletaCores.corRosaAvermelhado),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10))),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      alertaExclusao(
                                                                          item,
                                                                          context);
                                                                    },
                                                                    child: const Icon(
                                                                        Icons
                                                                            .close_outlined,
                                                                        size:
                                                                            20,
                                                                        color: PaletaCores
                                                                            .corAdtl),
                                                                  )),
                                                                ]),
                                                          )
                                                          .toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ))),
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      botoesAcoes(Constantes.iconeBaixar,
                                          PaletaCores.corVerdeCiano, 100, 70),
                                      botoesAcoes(Constantes.iconeAdicionar,
                                          PaletaCores.corAdtlLetras, 100, 70),
                                    ],
                                  )),
                              const Expanded(flex: 1, child: BarraNavegacao())
                            ],
                          );
                        }
                      },
                    )))));
  }
}
