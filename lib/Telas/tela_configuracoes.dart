import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/estilo.dart';
import 'package:senturionscale/Uteis/textos.dart';
import 'package:senturionscale/Widgets/barra_navegacao_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({Key? key}) : super(key: key);

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  Estilo estilo = Estilo();
  String horarioInicioSemana = "";
  String horarioTrocaSemana = "";
  String horarioInicioFSemana = "";
  String horarioTrocaFSemana = "";
  TimeOfDay? horario = const TimeOfDay(hour: 19, minute: 00);
  int contadorSetarHorario = 0;

  @override
  void initState() {
    super.initState();
    recuperarValoresSharePreferences();
  }

  //metodo para recuperar o horario gravado no share prefereces
  recuperarValoresSharePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      horarioInicioSemana =
          prefs.getString(Constantes.shareHorarioInicialSemana) ?? '';
      horarioTrocaSemana =
          prefs.getString(Constantes.shareHorarioTrocaSemana) ?? '';
      horarioInicioFSemana =
          prefs.getString(Constantes.shareHorarioInicialFSemana) ?? '';
      horarioTrocaFSemana =
          prefs.getString(Constantes.shareHorarioTrocaFsemana) ?? '';
    });
  }

  Widget botoesAcoes(double larguraTela, String horarioInicio,
          String horarioTroca, String qualHoraMudar) =>
      Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        width: larguraTela,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 60,
                width: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: PaletaCores.corAdtl),
                      backgroundColor: Colors.white,
                      elevation: 10,
                      shadowColor: PaletaCores.corAdtl,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onPressed: () async {
                      exibirTimePicker(qualHoraMudar);
                    },
                    child: const Icon(
                      Icons.access_time_filled_outlined,
                      color: PaletaCores.corAdtl,
                    ))),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                  "1° Hora começa às : $horarioInicio e troca às : $horarioTroca "),
            )
          ],
        ),
      );

  exibirTimePicker(String qualHoraMudar) async {
    TimeOfDay? novoHorario = await showTimePicker(
      context: context,
      initialTime: horario!,
      helpText: contadorSetarHorario == 1
          ? Textos.descricaoTimePickerHorarioTroca
          : Textos.descricaoTimePickerHorarioInicial,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.white,
              onPrimary: PaletaCores.corAdtlLetras,
              surface: PaletaCores.corAdtl,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (novoHorario != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        horario = novoHorario;
        contadorSetarHorario++;
        //definindo o horario inicial
        if (contadorSetarHorario == 1) {
          if (qualHoraMudar == Constantes.trocarHorarioSemana) {
            prefs.setString(Constantes.shareHorarioInicialSemana,
                "${horario!.hour.toString().padLeft(2, "0")}:${horario!.minute.toString().padLeft(2, "0")}");
          } else if (qualHoraMudar == Constantes.trocarHorarioFimSemana) {
            prefs.setString(Constantes.shareHorarioInicialFSemana,
                "${horario!.hour.toString().padLeft(2, "0")}:${horario!.minute.toString().padLeft(2, "0")}");
          }
          exibirTimePicker(qualHoraMudar);
        } else {
          // definindo horario de troca
          if (qualHoraMudar == Constantes.trocarHorarioSemana) {
            prefs.setString(Constantes.shareHorarioTrocaSemana,
                "${horario!.hour.toString().padLeft(2, "0")}:${horario!.minute.toString().padLeft(2, "0")}");
          } else if (qualHoraMudar == Constantes.trocarHorarioFimSemana) {
            prefs.setString(Constantes.shareHorarioTrocaFsemana,
                "${horario!.hour.toString().padLeft(2, "0")}:${horario!.minute.toString().padLeft(2, "0")}");
          }
          // redefindo valores das variaveis para os valores padroes
          contadorSetarHorario = 0;
          horario = const TimeOfDay(hour: 19, minute: 00);
        }
      });
      recuperarValoresSharePreferences();
    } else {
      // redefindo valor caso o
      // usuario cancele a acao
      contadorSetarHorario = 0;
    }
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
                  context, Constantes.rotaTelaCriarTabela);
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(Textos.tituloTelaConfiguracoes),
                leading: IconButton(
                    //setando tamanho do icone
                    iconSize: 30,
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaCriarTabela);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
              ),
              body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SizedBox(
                      width: larguraTela,
                      height: alturaTela - alturaAppBar - alturaBarraStatus,
                      child: Column(
                        children: [
                          Expanded(
                              flex: 9,
                              child: Container(
                                margin: const EdgeInsets.only(top: 20.0),
                                child: Column(
                                  children: [
                                    Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 20.0),
                                      width: larguraTela * 0.8,
                                      child: Text(
                                          Textos.descricaoBtnDefinirHorario,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 20)),
                                    ),
                                    Text(Textos.descricaoTrocaSemana,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    botoesAcoes(
                                        larguraTela,
                                        horarioInicioSemana,
                                        horarioTrocaSemana,
                                        Constantes.trocarHorarioSemana),
                                    Text(Textos.descricaoTrocaFimSemana,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    botoesAcoes(
                                        larguraTela,
                                        horarioInicioFSemana,
                                        horarioTrocaFSemana,
                                        Constantes.trocarHorarioFimSemana),
                                  ],
                                ),
                              )),
                          const Expanded(flex: 1, child: BarraNavegacao())
                        ],
                      ))),
            )));
  }
}
