import 'package:flutter/material.dart';
import 'package:senturionscale/Modelos/escala_modelo.dart';
import 'package:senturionscale/Uteis/AcoesBancoDados/AcaoBancoDadosItensEscala.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/ajustar_visualizacao.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/estilo.dart';
import 'package:intl/intl.dart';
import 'package:senturionscale/Uteis/textos.dart';
import 'package:senturionscale/Widgets/barra_navegacao_widget.dart';
import 'package:senturionscale/Widgets/tela_carregamento.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaAtualizar extends StatefulWidget {
  TelaAtualizar({Key? key, required this.nomeTabela, required this.idItem})
      : super(key: key);

  String nomeTabela;
  String idItem;

  @override
  State<TelaAtualizar> createState() => _TelaAtualizarState();
}

class _TelaAtualizarState extends State<TelaAtualizar> {
  Estilo estilo = Estilo();
  bool exibirTelaCarregamento = true;
  bool exibirCampoServirSantaCeia = false;
  bool exibirSoCamposCooperadora = false;
  bool exbirCampoIrmaoReserva = false;
  String horarioTroca = "";

  late DateTime dataSelecionada;
  final _formKeyFormulario = GlobalKey<FormState>();
  TextEditingController ctPrimeiroHoraPulpito = TextEditingController(text: "");
  TextEditingController ctSegundoHoraPulpito = TextEditingController(text: "");
  TextEditingController ctPrimeiroHoraEntrada = TextEditingController(text: "");
  TextEditingController ctSegundoHoraEntrada = TextEditingController(text: "");
  TextEditingController ctRecolherOferta = TextEditingController(text: "");
  TextEditingController ctUniforme = TextEditingController(text: "");
  TextEditingController ctMesaApoio = TextEditingController(text: "");
  TextEditingController ctServirSantaCeia = TextEditingController(text: "");
  TextEditingController ctIrmaoReserva = TextEditingController(text: "");

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
                //verificando o tipo do botao
                // para fazer acoes diferentes
                if (nomeBotao == Constantes.iconeAtualizar) {
                  if (_formKeyFormulario.currentState!.validate()) {
                    chamarAtualizarItensBancoDados();
                  }
                } else if (nomeBotao == Constantes.iconeLista) {
                  redirecionarTela();
                } else {
                  exibirDataPicker();
                }
              },
              child: LayoutBuilder(
                builder: (p0, p1) {
                  if (nomeBotao == Constantes.iconeAtualizar) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.update_outlined,
                            color: PaletaCores.corAdtl, size: 30),
                        Text(
                          Textos.btnSalvar,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: PaletaCores.corAdtl),
                        )
                      ],
                    );
                  } else if (nomeBotao == Constantes.iconeLista) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.view_list,
                            color: PaletaCores.corAdtl, size: 30),
                        Text(
                          Textos.btnVerLista,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: PaletaCores.corAdtl),
                        )
                      ],
                    );
                  } else {
                    return const Icon(Icons.date_range_outlined,
                        color: PaletaCores.corAdtl);
                  }
                },
              )));

  Widget botoesSwitch(String label, bool valorBotao) => SizedBox(
        width: 170,
        child: Row(
          children: [
            Text(label),
            Switch(
                value: valorBotao,
                activeColor: PaletaCores.corAdtl,
                onChanged: (bool valor) {
                  setState(() {
                    mudarSwitch(label, valor);
                  });
                })
          ],
        ),
      );

  // metodo para mudar status dos switch
  mudarSwitch(String label, bool valor) {
    if (label == Textos.labelSwitchCooperadora) {
      setState(() {
        exibirSoCamposCooperadora = !valor;
        exibirSoCamposCooperadora = valor;
      });
    } else if (label == Textos.labelSwitchIrmaoReserva) {
      setState(() {
        exbirCampoIrmaoReserva = !valor;
        exbirCampoIrmaoReserva = valor;
      });
    } else if (label == Textos.labelSwitchServirSantaCeia) {
      setState(() {
        exibirCampoServirSantaCeia = !valor;
        exibirCampoServirSantaCeia = valor;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    recuperarHorarioTroca();
    recuperarValoresItem();
  }

  redirecionarTela() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaListagemItens,
        arguments: widget.nomeTabela);
  }

  recuperarValoresItem() async {
    await AcaoBancoDadosItensEscala.recuperarItens(widget.nomeTabela,
            AcaoBancoDadosItensEscala.acaoRecupearDadosPorID, widget.idItem)
        .then(
      (value) {
        preencherCampos(value);
      },
    );
  }

  preencherCampos(List<EscalaModelo> escala) {
    for (var element in escala) {
      ctPrimeiroHoraPulpito.text = element.primeiraHoraPulpito;
      ctSegundoHoraPulpito.text = element.segundaHoraPulpito;
      ctPrimeiroHoraEntrada.text = element.primeiraHoraEntrada;
      ctSegundoHoraEntrada.text = element.segundaHoraEntrada;
      ctRecolherOferta.text = element.recolherOferta;
      ctUniforme.text = element.uniforme;
      ctMesaApoio.text = element.mesaApoio;
      ctServirSantaCeia.text = element.servirSantaCeia;
      ctIrmaoReserva.text = element.irmaoReserva;

      dataSelecionada =
          DateFormat("dd/MM/yyyy EEEE", "pt_BR").parse(element.dataCulto);
      //verificando se os campos nao estao vazios
      // para exibi-los
      if (element.servirSantaCeia.isNotEmpty) {
        setState(() {
          exibirCampoServirSantaCeia = true;
        });
      }
      if (element.irmaoReserva.isNotEmpty) {
        setState(() {
          exbirCampoIrmaoReserva = true;
        });
      }
      if (element.primeiraHoraPulpito.isEmpty &&
          element.segundaHoraPulpito.isEmpty) {
        setState(() {
          exibirSoCamposCooperadora = true;
        });
      }
    }
    setState(() {
      exibirTelaCarregamento = false;
    });
  }

  chamarAtualizarItensBancoDados() async {
    setState(() {
      exibirTelaCarregamento = true;
    });

    String primeiroHoraPulpito = "";
    String segundoHoraPulpito = "";
    String mesaApoio = "";
    String servirSantaCeia = "";
    String irmaoReserva = "";

    if (exibirSoCamposCooperadora) {
      primeiroHoraPulpito = "";
      segundoHoraPulpito = "";
      mesaApoio = ctMesaApoio.text;
    } else {
      primeiroHoraPulpito = ctPrimeiroHoraPulpito.text;
      segundoHoraPulpito = ctSegundoHoraPulpito.text;
      mesaApoio = "";
    }
    if (exibirCampoServirSantaCeia) {
      servirSantaCeia = ctServirSantaCeia.text;
    } else {
      servirSantaCeia = "";
    }

    if (exbirCampoIrmaoReserva) {
      irmaoReserva = ctIrmaoReserva.text;
    } else {
      irmaoReserva = "";
    }

    String retorno = await AcaoBancoDadosItensEscala.adicionarAtualizarItens(
        primeiroHoraPulpito,
        segundoHoraPulpito,
        ctPrimeiroHoraEntrada.text,
        ctSegundoHoraEntrada.text,
        ctRecolherOferta.text,
        ctUniforme.text,
        mesaApoio,
        servirSantaCeia,
        formatarData(dataSelecionada),
        horarioTroca,
        irmaoReserva,
        widget.nomeTabela,
        AcaoBancoDadosItensEscala.acaoAtualizarDados,
        widget.idItem);

    if (retorno == Constantes.retornoSucessoBancoDado) {
      exibirMsg(Textos.sucessoMsgAdicionarItemEscala);
      setState(() {
        redirecionarTela();
      });
    } else {
      exibirMsg(Textos.erroMsgAdicionarItemEscala);
      setState(() {
        exibirTelaCarregamento = false;
      });
    }
  }

  exibirMsg(String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // metodo para recuperar os horarios definidos
  // e gravados no share preferences
  recuperarHorarioTroca() async {
    String data = formatarData(dataSelecionada).toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // verificando se a data corresponde a um dia do fim de semana
    if (data.contains(Constantes.sabado) || data.contains(Constantes.domingo)) {
      setState(() {
        horarioTroca = "1° Hora começa às : "
            "${prefs.getString(Constantes.shareHorarioInicialFSemana) ?? ''}"
            " e troca às : ${prefs.getString(Constantes.shareHorarioTrocaFsemana) ?? ''} ";
      });
    } else {
      setState(() {
        horarioTroca = "1° Hora começa às : "
            "${prefs.getString(Constantes.shareHorarioInicialSemana) ?? ''}"
            " e troca às : "
            "${prefs.getString(Constantes.shareHorarioTrocaSemana) ?? ''} ";
      });
    }
  }

  // metodo para formatar a data e exibir
  // ela nos moldes exigidos
  formatarData(DateTime data) {
    String dataFormatada = DateFormat("dd/MM/yyyy EEEE", "pt_BR").format(data);
    return dataFormatada;
  }

  // metodo para exibir data picker para
  // o usuario selecionar uma data
  exibirDataPicker() {
    showDatePicker(
      helpText: Textos.descricaoDataPicker,
      context: context,
      initialDate: dataSelecionada,
      firstDate: DateTime(2001),
      lastDate: DateTime(2222),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.light(
              primary: PaletaCores.corAdtl,
              onPrimary: Colors.white,
              surface: PaletaCores.corAdtl,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    ).then((date) {
      setState(() {
        //definindo que a  variavel vai receber o
        // valor selecionado no data picker
        if (date != null) {
          dataSelecionada = date;
        }
      });
      formatarData(dataSelecionada);
      recuperarHorarioTroca();
    });
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
                  context, Constantes.rotaTelaListagemItens,
                  arguments: widget.nomeTabela);
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
                          context, Constantes.rotaTelaListagemItens,
                          arguments: widget.nomeTabela);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                title: SizedBox(
                  width: larguraTela,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Textos.tituloTelaAtualizarItem),
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
                                                Textos
                                                    .descricaoTelaAtualizarItem,
                                                style: const TextStyle(
                                                    fontSize: 20),
                                                textAlign: TextAlign.center),
                                          ),
                                          botoesAcoes(Constantes.iconeDataCulto,
                                              PaletaCores.corAdtl, 60, 60),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 20.0, horizontal: 0),
                                            width: larguraTela,
                                            child: Text(
                                                Textos.descricaoDataSelecionada +
                                                    formatarData(
                                                        dataSelecionada),
                                                textAlign: TextAlign.center),
                                          ),
                                          SizedBox(
                                            width: larguraTela,
                                            child: Text(horarioTroca,
                                                textAlign: TextAlign.center),
                                          ),
                                          Form(
                                            key: _formKeyFormulario,
                                            child: Wrap(
                                              children: [
                                                Visibility(
                                                    visible:
                                                        !exibirSoCamposCooperadora,
                                                    child: Wrap(
                                                      children: [
                                                        camposFormulario(
                                                            larguraTela,
                                                            ctPrimeiroHoraPulpito,
                                                            Textos
                                                                .labelPrimeiroHoraPulpito),
                                                        camposFormulario(
                                                            larguraTela,
                                                            ctSegundoHoraPulpito,
                                                            Textos
                                                                .labelSegundoHoraPulpito),
                                                      ],
                                                    )),
                                                camposFormulario(
                                                    larguraTela,
                                                    ctPrimeiroHoraEntrada,
                                                    Textos
                                                        .labelPrimeiroHoraEntrada),
                                                camposFormulario(
                                                    larguraTela,
                                                    ctSegundoHoraEntrada,
                                                    Textos
                                                        .labelSegundoHoraEntrada),
                                                camposFormulario(
                                                    larguraTela,
                                                    ctRecolherOferta,
                                                    Textos.labelRecolherOferta),
                                                camposFormulario(
                                                    larguraTela,
                                                    ctUniforme,
                                                    Textos.labelUniforme),
                                                Visibility(
                                                  visible:
                                                      exibirSoCamposCooperadora,
                                                  child: camposFormulario(
                                                      larguraTela,
                                                      ctMesaApoio,
                                                      Textos.labelMesaApoio),
                                                ),
                                                Visibility(
                                                  visible:
                                                      exibirCampoServirSantaCeia,
                                                  child: camposFormulario(
                                                      larguraTela,
                                                      ctServirSantaCeia,
                                                      Textos
                                                          .labelServirSantaCeia),
                                                ),
                                                Visibility(
                                                  visible:
                                                      exbirCampoIrmaoReserva,
                                                  child: camposFormulario(
                                                      larguraTela,
                                                      ctIrmaoReserva,
                                                      Textos.labelIrmaoReserva),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: larguraTela,
                                            height: 90,
                                            child: Card(
                                              elevation: 10,
                                              child: SingleChildScrollView(
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    botoesSwitch(
                                                        Textos
                                                            .labelSwitchCooperadora,
                                                        exibirSoCamposCooperadora),
                                                    botoesSwitch(
                                                        Textos
                                                            .labelSwitchServirSantaCeia,
                                                        exibirCampoServirSantaCeia),
                                                    botoesSwitch(
                                                        Textos
                                                            .labelSwitchIrmaoReserva,
                                                        exbirCampoIrmaoReserva)
                                                  ],
                                                ),
                                              ),
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
                                        botoesAcoes(Constantes.iconeAtualizar,
                                            PaletaCores.corVerdeCiano, 80, 70),
                                        botoesAcoes(Constantes.iconeLista,
                                            PaletaCores.corAdtlLetras, 80, 70),
                                      ],
                                    )),
                                const Expanded(flex: 1, child: BarraNavegacao())
                              ],
                            );
                          }
                        },
                      ))),
            )));
  }
}
