import 'package:flutter/material.dart';
import 'package:senturionscale/Telas/Tabelas/tela_criar_tabela_banco.dart';
import 'package:senturionscale/Telas/Tabelas/tela_listagem_tabalas_banco_dados.dart';
import 'package:senturionscale/Telas/telaCadastro.dart';
import 'package:senturionscale/Telas/tela_inicial.dart';
import 'package:senturionscale/Telas/tela_splash.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';

class Rotas {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Recebe os parâmetros na chamada do Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case Constantes.rotaTelaSplashScreen:
        return MaterialPageRoute(builder: (_) => const TelaSplashScreen());
      case Constantes.rotaTelaInical:
        return MaterialPageRoute(builder: (_) => TelaInicial());
      case Constantes.rotaTelaListagemTabelas:
        return MaterialPageRoute(
            builder: (_) =>  const TelaListagemTabelasBancoDados());
      case Constantes.rotaTelaCriarTabela:
        return MaterialPageRoute(
            builder: (_) =>  const TelaCriarTabelaBanco());
      case Constantes.rotaTelaCadastro:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => TelaCadastro(nomeTabela: args),
          );
        } else {
          return erroRota(settings);
        }
      // case Constantes.rotaTelaInical:
      //   if (args is Map) {
      //     return MaterialPageRoute(
      //       builder: (_) => TelaAtualizar(
      //         nomeTabela: args["tabela"],idItem: args["id"],
      //       ),
      //     );
      //   } else {
      //     return erroRota(settings);
      //   }
    }

    // Se o argumento não é do tipo correto, retorna erro
    return erroRota(settings);
  }

  //metodo para exibir mensagem de erro
  static Route<dynamic> erroRota(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: PaletaCores.corAdtl,
          title: const Text("Tela não encontrada!"),
        ),
        body: Container(
          color: PaletaCores.corAdtl,
          child: const Center(
            child: Text("Tela não encontrada."),
          ),
        ),
      );
    });
  }
}
