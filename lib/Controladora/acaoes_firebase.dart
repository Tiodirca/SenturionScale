import 'package:cloud_firestore/cloud_firestore.dart';

import '../Modelos/tabelas_modelo.dart';
import '../Uteis/constantes.dart';
import '../Uteis/metodos_auxiliares.dart';

class AcoesFireBase {
  static criarTabelas(String nomeTabela) {
    try {
      CollectionReference colecao = FirebaseFirestore.instance
          .collection(Constantes.fireBaseTabelasColecao);
      colecao.add({
        Constantes.fireBaseValorTabelas:
            MetodosAuxiliares.removerEspacoNomeTabelas(nomeTabela)
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static Future consultarTabelas() async {
    List<TabelaModelo> tabelasBancoDados = [];
    var db = FirebaseFirestore.instance;
    await db.collection(Constantes.fireBaseTabelasColecao).get().then((event) {
      for (var doc in event.docs) {
        var nomeTabela = doc
            .data()
            .values
            .toString()
            .replaceAll("(", "")
            .replaceAll(")", "");
        tabelasBancoDados
            .add(TabelaModelo(nomeTabela: nomeTabela, idTabela: doc.id));
      }
    });
    return tabelasBancoDados;
  }
}
