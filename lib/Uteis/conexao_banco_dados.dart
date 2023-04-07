import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'package:senturionscale/Modelos/TabelaModelo.dart';
import 'package:senturionscale/Uteis/constantes.dart';

class ConexaoBancoDados {
  var configuracoesBanco =
      ConnectionSettings(host: 'localhost', user: 'root', db: 'banco_teste');

  // var configuracoesBanco = ConnectionSettings(
  //   password: 'Agosto30250@',
  //   host: 'localhost:55538',
  //   db: 'id18102343_listasenturion',
  //   user: 'id18102343_senturion',
  // );
  static var root = Uri.parse("https://senturionlist.000webhostapp.com");

  Future criarTabela(String nomeTabela) async {
    try {
      var conn = await MySqlConnection.connect(configuracoesBanco);
      await conn.query(
          'CREATE TABLE IF NOT EXISTS $nomeTabela (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, '
          '${Constantes.primeiroHoraPulpito} varchar(255), '
          '${Constantes.segundoHoraPulpito} varchar(255), '
          '${Constantes.primeiroHoraEntrada} varchar(255), '
          '${Constantes.segundoHoraEntrada} varchar(255), '
          '${Constantes.recolherOferta} varchar(255), '
          '${Constantes.uniforme} varchar(255), '
          '${Constantes.mesaApoio} varchar(255), '
          '${Constantes.servirSantaCeia} varchar(255), '
          '${Constantes.dataSemana} varchar(255), '
          '${Constantes.horarioTroca} varchar(255), '
          '${Constantes.irmaoReserva} varchar(255))');
      return Constantes.sucessoCriarTabela;
    } catch (e) {
      return Constantes.erroCriarTabela;
    }
  }

  Future adicionarDados() async {
    // Insert some data
    var conn = await MySqlConnection.connect(configuracoesBanco);
    var result = await conn.query(
        'insert into users (name, email, age) values (?, ?, ?)',
        ['Bob', 'bob@bob.com', 25]);
    print('Inserted row id=${result.insertId}');
  }

  Future recuperarTabelas() async {
    print("xvcxcvxvxvc");
    List<TabelaModelo> listaTabelasBancoDados = [];
    try {
      var conn = await MySqlConnection.connect(configuracoesBanco);
      var resultado =
          await conn.query('show tables').timeout(const Duration(seconds: 10));
      print("bvbcnbvn");
      for (var linha in resultado) {
        listaTabelasBancoDados
            .add(TabelaModelo(nomeTabela: linha[0].toString()));
      }
      return listaTabelasBancoDados;
    } catch (e) {
      return Constantes.erroBuscaBancoDados;
    }
  }

  //metodo para criar tabela
  static Future<String> criarTabelas(String nomeTabela, String acao) async {
    try {
      //instanciando map
      var map = <String, dynamic>{};
      //passando um map
      map['action'] = acao;
      map['tabela'] = nomeTabela;
      //definindo que a variavel vai receber os seguintes parametros
      final response =
          await http.post(root, body: map).timeout(const Duration(seconds: 20));
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

//
//   // Query the database using a parameterized query
//   var results = await conn.query(
//       'select name, email, age from users where id = ?', [result.insertId]);
//   for (var row in results) {
//     print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
//   }
//
//   // Update some data
//   await conn.query('update users set age=? where name=?', [26, 'Bob']);
//
//   // Query again database using a parameterized query
//   var results2 = await conn.query(
//       'select name, email, age from users where id = ?', [result.insertId]);
//   for (var row in results2) {
//     print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
//   }
//
//   // Finally, close the connection
//   await conn.close();
// }
}
