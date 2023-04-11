import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senturionscale/Modelos/escala_modelo.dart';
import 'package:senturionscale/Uteis/constantes.dart';

class AcaoBancoDadosItensEscala {
  static const acaoAdicionarDados = 'adicionarDados';
  static const acaoRecupearDados = 'recuperarDados';
  static const acaoRecupearDadosPorID = 'recuperarDadosPorID';
  static const acaoAtualizarDados = 'atualizarDados';
  static const acaoDeletarDados = 'deletarDados';

  static var root = Uri.parse("https://senturionlist.000webhostapp.com");

  //metodo para adicionar dados no banco de dados
  static Future<String> adicionarItens(
      String primeiraHoraPulpito,
      String segundaHoraPulpito,
      String primeiraHoraEntrada,
      String segundaHoraEntrada,
      String recolherOferta,
      String uniforme,
      String mesaApoio,
      String servirSantaCeia,
      String dataCulto,
      String horarioTroca,
      String irmaoReserva,
      String nomeTabela) async {
    try {
      //instanciando map
      var map = <String, dynamic>{};
      //passando os parametros para o map
      map['action'] = acaoAdicionarDados;
      map[Constantes.primeiraHoraPulpito] = primeiraHoraPulpito;
      map[Constantes.segundaHoraPulpito] = segundaHoraPulpito;
      map[Constantes.primeiraHoraEntrada] = primeiraHoraEntrada;
      map[Constantes.segundaHoraEntrada] = segundaHoraEntrada;
      map[Constantes.recolherOferta] = recolherOferta;
      map[Constantes.uniforme] = uniforme;
      map[Constantes.mesaApoio] = mesaApoio;
      map[Constantes.servirSantaCeia] = servirSantaCeia;
      map[Constantes.dataCulto] = dataCulto;
      map[Constantes.horarioTroca] = horarioTroca;
      map[Constantes.irmaoReserva] = irmaoReserva;
      map[Constantes.nomeTabela] = nomeTabela;
      //definindo que a variavel vai
      // receber os seguintes parametros
      final response =
          await http.post(root, body: map).timeout(const Duration(seconds: 20));
      if (200 == response.statusCode) {
        print(response.body.toString());
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      print(e.toString());
      return Constantes.erroAcaoBancoDados;
    }
  }
  //metodo para recuperar os dados do banco de dados
  static Future<List<EscalaModelo>> recuperarItens(String tabela) async {
    try {
      //instanciando map
      var map = <String, dynamic>{};
      //passando os parametros para o map
      map['action'] = acaoRecupearDados;
      map['tabela'] = tabela;
      //definindo que a variavel vai receber os seguintes parametros
      final response = await http.post(root, body: map).timeout(const Duration(seconds: 20));
      if (200 == response.statusCode) {
        List<EscalaModelo> list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return <EscalaModelo>[];
  }
  //metodo para transformar os dados obtidos pelo json em objetos
  static List<EscalaModelo> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<EscalaModelo>((json) => EscalaModelo.fromJson(json))
        .toList();
  }
  //metodo para deletar os dados
  static Future<String> deletar(String id, String nomeTabela) async {
    try {
      //instanciando map
      var map = <String, dynamic>{};
      //passando os parametros para o map
      map['action'] = acaoDeletarDados;
      map['id'] = id;
      map['tabela'] = nomeTabela;
      //definindo que a variavel vai
      // receber os seguintes parametros
      final response =
      await http.post(root, body: map).timeout(const Duration(seconds: 20));
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return Constantes.erroAcaoBancoDados;
      }
    } catch (e) {
      return Constantes.erroAcaoBancoDados;
    }
  }

}
