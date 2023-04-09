import 'package:senturionscale/Uteis/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MetodosSharePreferences {
  gravarDadosPadrao() async {
    //metodo para gravar informacoes
    // padroes no share preferences
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
