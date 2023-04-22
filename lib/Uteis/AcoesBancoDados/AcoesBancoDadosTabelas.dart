import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:senturionscale/Modelos/exibir_tabelas.dart';
import 'package:senturionscale/Uteis/constantes.dart';

class AcoesBancoDadosTabelas {
  static var root = Uri.parse("https://senturionlist.000webhostapp.com");
  static const acaoDeletarTabela = 'deletarTabela';
  static const acaoExibirTabelas = 'exibirTabelas';
  static const acaoCriarTabelas = 'criarTabela';

//metodo para criar tabela
  static Future<String> criarTabela(String nomeTabela) async {
    try {
      //instanciando map
      var map = <String, dynamic>{};
      //passando um map
      map['action'] = acaoCriarTabelas;
      map['tabela'] = nomeTabela;
      //definindo que a variavel vai receber
      // os seguintes parametros
      final response =
          await http.post(root, body: map).timeout(const Duration(seconds: 10));
      if (200 == response.statusCode) {
        print(response.body);
        return response.body;
      } else {
        print(response.body);
        return Constantes.erroAcaoBancoDados;
      }
    } catch (e) {
      print(e.toString());
      return Constantes.erroAcaoBancoDados;
    }
  }

  //metodo para recuparar as tabelas
  // do banco de dados
  static Future<List<ExibirTabelas>> recuperarTabelas() async {
    try {
      //instanciando map
      var map = <String, dynamic>{};
      //passando os parametros para o map
      map['action'] = acaoExibirTabelas;
      map['tabela'] = acaoExibirTabelas;
      //definindo que a variavel vai receber os seguintes parametros
      final response =
          await http.post(root, body: map).timeout(const Duration(seconds: 10));
      if (200 == response.statusCode) {
        List<ExibirTabelas> list = parseResponseTabelas(response.body);
        return list;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return <ExibirTabelas>[];
  }

  static List<ExibirTabelas> parseResponseTabelas(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ExibirTabelas>((json) => ExibirTabelas.fromJson(json))
        .toList();
  }

  //metodo para deletar a tabela do
  // banco de dados
  static Future<String> deletarTabela(String tabela) async {
    try {
      //instanciando map
      var map = <String, dynamic>{};
      //passando os parametros para o map
      map['action'] = acaoDeletarTabela;
      map['tabela'] = tabela;
      //definindo que a variavel vai receber os seguintes parametros
      final response = await http.post(root, body: map).timeout(const Duration(seconds: 5));
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
