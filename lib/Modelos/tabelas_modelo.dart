import 'package:cloud_firestore/cloud_firestore.dart';

class TabelaModelo {
  TabelaModelo({required this.nomeTabela, required this.idTabela});

  String nomeTabela;
  String idTabela;

// factory TabelaModelo.fromFirestore(
//     DocumentSnapshot<Map<dynamic, dynamic>> snapshot,
//     SnapshotOptions? options,
//     ) {
//   final data = snapshot.data();
//   return TabelaModelo(
//     nomeTabela: data?['nome_tabela'],
//   );
// }
//
// Map<String, dynamic> toFirestore() {
//   return {
//     "nome_tabela": nomeTabela,
//   };
// }
}
