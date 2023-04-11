import 'package:flutter/material.dart';
import 'package:senturionscale/Modelos/escala_modelo.dart';
import 'package:senturionscale/Uteis/AcaoBancoDadosItensEscala.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:intl/intl.dart';
import 'package:senturionscale/Uteis/estilo.dart';
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
  late List<EscalaModelo> escala;

  @override
  void initState() {
    super.initState();
    escala = [];
    recuparValoresBancoDados();
  }

  recuparValoresBancoDados() async {
    await AcaoBancoDadosItensEscala.recuperarItens(widget.nomeTabela).then(
      (escalaBanco) {
        setState(() {
          if (escalaBanco.isEmpty) {
            exibirTelaCarregamento = false;
          } else {
            // escalaBanco.sort((a, b) => DateFormat("dd/MM/yyyy EEEE", "pt_BR")
            //     .parse(a.dataCulto)
            //     .compareTo(
            //         DateFormat("dd/MM/yyyy EEEE", "pt_BR").parse(b.dataCulto)));
            escala = escalaBanco;
            exibirTelaCarregamento = false;
          }
        });
      },
    );
  }

  Widget botoesAcoes(
          String nomeBotao, Color corBotao) =>
      SizedBox(
          height: 70,
          width: 100,
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
                if (nomeBotao == Constantes.tipoIconeBaixar) {
                } else {
                  Navigator.pushReplacementNamed(
                      context, Constantes.rotaTelaCadastro,
                      arguments: widget.nomeTabela);
                }
              },
              child: LayoutBuilder(
                builder: (p0, p1) {
                  if (nomeBotao == Constantes.tipoIconeBaixar) {
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
                  } else {
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
                  }
                },
              )));

  Widget botoesAcoesListagem(
          String nomeBotao, Color corBotao) =>
      SizedBox(
          height: 40,
          width: 60,
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
                //verificando o tipo do botao
                // para fazer acoes diferentes
                if (nomeBotao == Constantes.tipoIconeAdicionar) {
                  Navigator.pushReplacementNamed(
                      context, Constantes.rotaTelaCadastro,
                      arguments: widget.nomeTabela);
                } else if (nomeBotao == Constantes.tipoIconeRecarregar) {
                  setState(() {
                    exibirTelaCarregamento = true;
                  });
                  recuparValoresBancoDados();
                }
              },
              child: LayoutBuilder(
                builder: (p0, p1) {
                  if (nomeBotao == Constantes.tipoIconeExclusao) {
                    return const Icon(Icons.close_outlined,
                        color: PaletaCores.corAdtl, size: 20);
                  } else if (nomeBotao == Constantes.tipoIconeEditar) {
                    return const Icon(Icons.edit_outlined,
                        color: PaletaCores.corAdtl, size: 20);
                  } else if (nomeBotao == Constantes.tipoIconeAdicionar) {
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

  Widget conteudoBotao(Icons icone) => Column(
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
                                    botoesAcoesListagem(
                                        Constantes.tipoIconeAdicionar,
                                        PaletaCores.corRosaAvermelhado),
                                    botoesAcoesListagem(
                                        Constantes.tipoIconeRecarregar,
                                        PaletaCores.corAdtlLetras)
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
                                    child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
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
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 0.0),
                                        height: alturaTela * 0.5,
                                        child: ListView(
                                          children: [
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: DataTable(
                                                columnSpacing: 10,
                                                columns: [
                                                  DataColumn(
                                                      label: Text(
                                                          Textos.labelData,
                                                          textAlign: TextAlign
                                                              .center)),
                                                  DataColumn(
                                                    label: Text(
                                                        Textos
                                                            .labelHorarioTroca,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  DataColumn(
                                                      label: Text(
                                                          Textos
                                                              .labelPrimeiroHoraPulpito,
                                                          textAlign: TextAlign
                                                              .center)),
                                                  DataColumn(
                                                    label: Text(
                                                        Textos
                                                            .labelSegundoHoraPulpito,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  DataColumn(
                                                      label: Text(
                                                          Textos
                                                              .labelPrimeiroHoraEntrada,
                                                          textAlign: TextAlign
                                                              .center)),
                                                  DataColumn(
                                                    label: Text(
                                                        Textos
                                                            .labelSegundoHoraEntrada,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  DataColumn(
                                                      label: Text(
                                                          Textos.labelMesaApoio,
                                                          textAlign: TextAlign
                                                              .center)),
                                                  DataColumn(
                                                    label: Text(
                                                        Textos.labelUniforme,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                        Textos
                                                            .labelRecolherOferta,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                        Textos
                                                            .labelServirSantaCeia,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                        Textos
                                                            .labelIrmaoReserva,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                        Textos.labelEditar,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                        Textos.labelExcluir,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ],
                                                rows: escala
                                                    .map(
                                                      (item) => DataRow(cells: [
                                                        DataCell(SizedBox(
                                                            width: 90,
                                                            //SET width
                                                            child: Text(
                                                                item.dataCulto,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center))),
                                                        DataCell(Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 90,
                                                            //SET width
                                                            child: Text(
                                                                item
                                                                    .horarioTroca,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center))),
                                                        DataCell(SizedBox(
                                                            width: 90,
                                                            //SET width
                                                            child: Text(
                                                                item
                                                                    .primeiraHoraPulpito,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center))),
                                                        DataCell(SizedBox(
                                                            width: 90,
                                                            //SET width
                                                            child: Text(
                                                                item
                                                                    .segundaHoraPulpito,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center))),
                                                        DataCell(SizedBox(
                                                            width: 90,
                                                            //SET width
                                                            child: Text(
                                                                item
                                                                    .primeiraHoraEntrada,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center))),
                                                        DataCell(SizedBox(
                                                            width: 90,
                                                            //SET width
                                                            child: Text(
                                                                item
                                                                    .segundaHoraPulpito,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center))),
                                                        DataCell(SizedBox(
                                                            width: 90,
                                                            //SET width
                                                            child: Text(
                                                                item.mesaApoio,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center))),
                                                        DataCell(SizedBox(
                                                            width: 90,
                                                            //SET width
                                                            child: Text(
                                                                item.uniforme,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center))),
                                                        DataCell(SizedBox(
                                                            width: 90,
                                                            //SET width
                                                            child: Text(
                                                                item
                                                                    .recolherOferta,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center))),
                                                        DataCell(SizedBox(
                                                            width: 90,
                                                            //SET width
                                                            child: Text(
                                                                item
                                                                    .servirSantaCeia,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center))),
                                                        DataCell(SizedBox(
                                                            width: 180,
                                                            //SET width
                                                            child: Text(
                                                                item
                                                                    .irmaoReserva,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center))),
                                                        DataCell(botoesAcoesListagem(
                                                            Constantes
                                                                .tipoIconeEditar,
                                                            PaletaCores
                                                                .corAdtlLetras)),
                                                        DataCell(botoesAcoesListagem(
                                                            Constantes
                                                                .tipoIconeExclusao,
                                                            PaletaCores
                                                                .corRosaAvermelhado)),
                                                      ]),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))),
                            Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    botoesAcoes(Constantes.tipoIconeBaixar,
                                        PaletaCores.corVerdeCiano),
                                    botoesAcoes(Constantes.tipoIconeLista,
                                        PaletaCores.corAdtlLetras),
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
