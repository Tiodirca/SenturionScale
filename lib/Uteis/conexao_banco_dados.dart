import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'package:senturionscale/Modelos/tabelas_modelo.dart';
import 'package:senturionscale/Uteis/constantes.dart';

class ConexaoBancoDados {
  // var configuracoesBanco =
  //     ConnectionSettings(host: 'localhost', user: 'root', db: 'banco_teste');

  var configuracoesBanco = ConnectionSettings(
    host: 'senturionlist.000webhostapp.com',
    db: 'id18102343_listasenturion',
    user: 'id18102343_senturion',
    password: 'Agosto30250@',
    useSSL: false,
    port: 3306,
    useCompression: false,
  );
  static var root = Uri.parse("https://senturionlist.000webhostapp.com");

  Future criarTabela(String nomeTabela) async {
    try {
      var conn = await MySqlConnection.connect(configuracoesBanco);
      await conn.query(
          'CREATE TABLE IF NOT EXISTS $nomeTabela (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, '
          '${Constantes.primeiraHoraPulpito} varchar(255), '
          '${Constantes.segundaHoraPulpito} varchar(255), '
          '${Constantes.primeiraHoraEntrada} varchar(255), '
          '${Constantes.segundaHoraEntrada} varchar(255), '
          '${Constantes.recolherOferta} varchar(255), '
          '${Constantes.uniforme} varchar(255), '
          '${Constantes.mesaApoio} varchar(255), '
          '${Constantes.servirSantaCeia} varchar(255), '
          '${Constantes.dataCulto} varchar(255), '
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
    List<TabelaModelo> listaTabelasBancoDados = [];
    try {
      var conn = await MySqlConnection.connect(configuracoesBanco);
      var resultado =
          await conn.query('show tables').timeout(const Duration(seconds: 10));
      for (var linha in resultado) {
        listaTabelasBancoDados
            .add(TabelaModelo(nomeTabela: linha[0].toString()));
      }
      return listaTabelasBancoDados;
    } catch (e) {
      print(e.toString());
      return Constantes.erroAcaoBancoDados;
    }
  }

  Future<bool> excluirTabela(String nomeTabela) async {
    var conn = await MySqlConnection.connect(configuracoesBanco);
    try {
      await conn.query('drop table $nomeTabela');
      return true;
    } catch (e) {
      return false;
    }
  }

  //metodo para criar tabela
   Future<String> criarTabelas(String nomeTabela, String acao) async {
    try {
      //instanciando map
      var map = <String, dynamic>{};
      //passando um map

      //map['action'] = acao;
      //map['tabela'] = nomeTabela;
      //definindo que a variavel vai receber os seguintes parametro
      var conn = await MySqlConnection.connect(configuracoesBanco);
      final response =
          await http.post(root,headers: {
            
          },body: criarTabela(nomeTabela)).timeout(const Duration(seconds: 20));
      print("fdfsf");
      print(response.body.toString());
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print(e.toString());
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
