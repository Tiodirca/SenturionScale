class MostrarTabelas {
  String tabelas;

  MostrarTabelas(
      {
      required this.tabelas,
      });

  factory MostrarTabelas.fromJson(Map<String, dynamic> json) {
    return MostrarTabelas(
      tabelas: json['Tables_in_id18102343_listasenturion'] as String,
      //tabelas: json['Tables_in_dart'] as String,
    );
  }
}
