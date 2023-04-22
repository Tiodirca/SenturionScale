import 'package:senturionscale/Uteis/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MetodosAuxiliares{

  // metodo para sobreescrever string substituindo espaco
  // por anderline
  static removerEspacoNomeTabelas(String texto){
    return texto.replaceAll(" ", "_");
  }

  //metodo para ajustar o tamanho do textField com base no tamanho da tela
  static ajustarTamanhoTextField(double larguraTela) {
    double tamanho = 150;
    //verificando qual o tamanho da tela
    if (larguraTela <= 600) {
      tamanho = 190;
    } else {
      tamanho = 500;
    }
    return tamanho;
  }

  // metodo para gravar valores padroes no
  // share preferences
  gravarDadosPadrao() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final horaMudada = prefs.getString(Constantes.horarioMudado) ?? '';
    if (horaMudada != Constantes.horarioMudado) {
      prefs.setString(
          Constantes.shareHorarioInicialSemana, Constantes.horarioInicialSemana);
      prefs.setString(
          Constantes.shareHorarioTrocaSemana, Constantes.horarioTrocaSemana);
      prefs.setString(
          Constantes.shareHorarioInicialFSemana, Constantes.horarioInicialFSemana);
      prefs.setString(
          Constantes.shareHorarioTrocaFsemana, Constantes.horarioTrocaFsemana);
    }
  }
}