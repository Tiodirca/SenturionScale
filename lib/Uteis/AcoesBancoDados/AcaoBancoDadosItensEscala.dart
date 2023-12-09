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


  static var root = Uri.parse("https://senturionlistback.000webhostapp.com/");

  //metodo para adicionar  e atualizar dados no banco de dados
  static Future<String> adicionarAtualizarItens(
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
      String nomeTabela,
      String tipoAcao,
      String id) async {
    try {
      var map = <String, dynamic>{};
      // verificando o tipo da acao
      // a ser realizada pelo metodo
      if (tipoAcao == acaoAdicionarDados) {
        map['acao'] = acaoAdicionarDados;
      } else {
        map['acao'] = acaoAtualizarDados;
        map['id'] = id;
      }
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
        print(response.body);
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return Constantes.erroAcaoBancoDados;
    }
  }

  //metodo para recuperar os dados do banco de dados
  static Future<List<EscalaModelo>> recuperarItens(String tabela,
      String tipoAcao, String id) async {
    try {
      var map = <String, dynamic>{};
      // verificando o tipo da acao
      // a ser realizada pelo metodo
      if (tipoAcao == acaoRecupearDados) {
        map['acao'] = acaoRecupearDados;
      } else {
        map['acao'] = acaoRecupearDadosPorID;
        map['id'] = id;
      }
      map['tabela'] = tabela;
      //definindo que a variavel vai receber os seguintes parametros
      final response =
      await http.post(root, body: map).timeout(const Duration(seconds: 20));
      if (200 == response.statusCode) {
        //print(response.body);
        String resposta = response.body;
        List itensDivididos = resposta.split(" || ");
        // removendo ultimo index pois o mesmo está vazio
        itensDivididos.removeAt(itensDivididos.length-1);
        List<EscalaModelo> list = [];
        for (var element in itensDivididos) {
           Map<String, dynamic> converterParaJson = json.decode(element);
           list.add(EscalaModelo.fromJson(converterParaJson));
        }
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
      map['acao'] = acaoDeletarDados;
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
