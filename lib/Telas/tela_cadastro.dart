import 'dart:io';

import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/AcoesBancoDados/AcaoBancoDadosItensEscala.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/estilo.dart';
import 'package:intl/intl.dart';
import 'package:senturionscale/Uteis/metodos_auxiliares.dart';
import 'package:senturionscale/Uteis/textos.dart';
import 'package:senturionscale/Widgets/barra_navegacao_widget.dart';
import 'package:senturionscale/Widgets/tela_carregamento.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaCadastro extends StatefulWidget {
  TelaCadastro({Key? key, required this.nomeTabela}) : super(key: key);

  String nomeTabela;

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  Estilo estilo = Estilo();
  bool exibirTelaCarregamento = false;
  bool exibirCampoServirSantaCeia = false;
  bool exibirSoCamposCooperadora = false;
  bool exbirCampoIrmaoReserva = false;
  String horarioTroca = "";

  DateTime dataSelecionada = DateTime.now();
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
        width: MetodosAuxiliares.ajustarTamanhoTextField(larguraTela),
        child: TextFormField(
          keyboardType: TextInputType.text,
          controller: controller,
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
          child: FloatingActionButton(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: corBotao),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              onPressed: () async {
                //verificando o tipo do botao
                // para fazer acoes diferentes
                if (nomeBotao == Constantes.iconeSalvar) {
                  if (_formKeyFormulario.currentState!.validate()) {
                    chamarAdicionarItensBancoDados();
                  }
                } else if (nomeBotao == Constantes.iconeLista) {
                  Navigator.pushReplacementNamed(
                      context, Constantes.rotaTelaListagemItens,
                      arguments: widget.nomeTabela);
                } else {
                  exibirDataPicker();
                }
              },
              child: LayoutBuilder(
                builder: (p0, p1) {
                  if (nomeBotao == Constantes.iconeSalvar) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save_outlined,
                            color: PaletaCores.corAdtl, size: 30),
                        Text(
                          Textos.btnSalvar,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
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
                          Textos.btnVerEscalaAtual,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: PaletaCores.corAdtl),
                        )
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.date_range_outlined,
                            color: PaletaCores.corAdtl, size: 30),
                        Text(
                          Textos.labelData,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: PaletaCores.corAdtl),
                        )
                      ],
                    );
                  }
                },
              )));

  Widget botoesSwitch(String label, bool valorBotao) => SizedBox(
        width: 180,
        child: Row(
          children: [
            Text(label),
            Switch(
                inactiveThumbColor: PaletaCores.corAzul,
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
  }

  chamarAdicionarItensBancoDados() async {
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
        MetodosAuxiliares.removerEspacoNomeTabelas(widget.nomeTabela),
        AcaoBancoDadosItensEscala.acaoAdicionarDados,
        "SemID");

    if (retorno == Constantes.retornoSucessoBancoDado) {
      exibirMsg(Textos.sucessoMsgAdicionarItemEscala);
      setState(() {
        limparValoresCampos();
        exibirTelaCarregamento = false;
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
        horarioTroca = "Começa às : "
            "${prefs.getString(Constantes.shareHorarioInicialFSemana) ?? ''}"
            " e troca às : ${prefs.getString(Constantes.shareHorarioTrocaFsemana) ?? ''} ";
      });
    } else {
      setState(() {
        horarioTroca = "Começa às : "
            "${prefs.getString(Constantes.shareHorarioInicialSemana) ?? ''}"
            " e troca às : "
            "${prefs.getString(Constantes.shareHorarioTrocaSemana) ?? ''} ";
      });
    }
  }

  // metodo para limpar valores dos
  // campos apos cadastrar item
  // na base de dados
  limparValoresCampos() {
    ctPrimeiroHoraPulpito.text = "";
    ctSegundoHoraPulpito.text = "";
    ctPrimeiroHoraEntrada.text = "";
    ctSegundoHoraEntrada.text = "";
    ctRecolherOferta.text = "";
    ctUniforme.text = "";
    ctMesaApoio.text = "";
    ctServirSantaCeia.text = "";
    ctIrmaoReserva.text = "";
  }

  // metodo para formatar a data e exibir
  // ela nos moldes exigidos
  formatarData(DateTime data) {
    String dataFormatada = DateFormat("dd/MM/yyyy EEEE", "pt_BR").format(data);
    if (exibirCampoServirSantaCeia) {
      return dataFormatada = "$dataFormatada ( Santa Ceia )";
    } else {
      return dataFormatada;
    }
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
              primary: PaletaCores.corVerdeCiano,
              onPrimary: Colors.white,
              surface: PaletaCores.corAdtl,
              onSurface: Colors.white,
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
        child: Scaffold(
          appBar: AppBar(
              leading: Visibility(
                visible: !exibirTelaCarregamento,
                child: IconButton(
                    color: Colors.white,
                    //setando tamanho do icone
                    iconSize: 30,
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaListagemTabelas);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
              ),
              title: Visibility(
                visible: !exibirTelaCarregamento,
                child: SizedBox(
                  width: larguraTela,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Textos.tituloTelaCadastro),
                    ],
                  ),
                ),
              )),
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
                                            Textos.descricaoTelaCadastro,
                                            style:
                                                const TextStyle(fontSize: 20),
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
                                                formatarData(dataSelecionada),
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
                                                Textos.labelSegundoHoraEntrada),
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
                                                  Textos.labelServirSantaCeia),
                                            ),
                                            Visibility(
                                              visible: exbirCampoIrmaoReserva,
                                              child: camposFormulario(
                                                  larguraTela,
                                                  ctIrmaoReserva,
                                                  Textos.labelIrmaoReserva),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            Platform.isAndroid || Platform.isIOS
                                                ? larguraTela
                                                : larguraTela * 0.9,
                                        height: 100,
                                        child: Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  width: 1,
                                                  color:
                                                      PaletaCores.corAzulClaro),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          elevation: 1,
                                          child: Wrap(
                                            runAlignment: WrapAlignment.center,
                                            alignment: WrapAlignment.center,
                                            children: [
                                              botoesSwitch(
                                                  Textos.labelSwitchCooperadora,
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
                                    ],
                                  ),
                                ))),
                            Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      botoesAcoes(Constantes.iconeSalvar,
                                          PaletaCores.corVerdeCiano, 80, 70),
                                      botoesAcoes(Constantes.iconeLista,
                                          PaletaCores.corAdtlLetras, 80, 70),
                                    ],
                                  ),
                                )),
                            const Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                  child: BarraNavegacao(),
                                ))
                          ],
                        );
                      }
                    },
                  ))),
        ));
  }
}
