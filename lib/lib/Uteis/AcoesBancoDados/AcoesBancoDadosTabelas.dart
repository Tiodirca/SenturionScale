import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:senturionscale/Modelos/exibir_tabelas.dart';
import 'package:senturionscale/Uteis/constantes.dart';

class AcoesBancoDadosTabelas {
  //static var root = Uri.parse("https:// 192.168.74.7/teste/conexao.php");

  static var root = Uri.parse("http://192.168.101.5/teste/conexao.php");
  static const acaoDeletarTabela = 'deletarTabela';
  static const acaoExibirTabelas = 'exibirTabelas';
  static const acaoCriarTabelas = 'criarTabela';

//metodo para criar tabela
  static Future<String> criarTabela(String nomeTabela) async {
    try {
      //instanciando map
      var map = <String, dynamic>{};
      //passando um map
      map['acao'] = acaoCriarTabelas;
      map['tabela'] = nomeTabela;
      //definindo que a variavel vai receber
      // os seguintes parametros
      final response =
          await http.post(root, body: map).timeout(const Duration(seconds: 10));
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return Constantes.erroAcaoBancoDados;
      }
    } catch (e) {
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
      map['acao'] = acaoExibirTabelas;
      map['tabela'] = acaoExibirTabelas;
      //definindo que a variavel vai receber os seguintes parametros
      final response =
          await http.post(root, body: map).timeout(const Duration(seconds: 10));

      if (200 == response.statusCode) {
        String resposta = response.body;
        List itensDivididos = resposta.split(",");
        // removendo ultimo index pois o mesmo está vazio
        itensDivididos.removeAt(itensDivididos.length - 1);

        List<ExibirTabelas> list = [];
        for (var element in itensDivididos) {
          Map<String, dynamic> converterParaJson = json.decode(element);
          list.add(ExibirTabelas.fromJson(converterParaJson));
        }
        return list;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return <ExibirTabelas>[];
  }
  //metodo para deletar a tabela do
  // banco de dados
  static Future<String> deletarTabela(String tabela) async {
    try {
      //instanciando map
      var map = <String, dynamic>{};
      //passando os parametros para o map
      map['acao'] = acaoDeletarTabela;
      map['tabela'] = tabela;
      //definindo que a variavel vai receber os seguintes parametros
      final response =
          await http.post(root, body: map).timeout(const Duration(seconds: 5));
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
