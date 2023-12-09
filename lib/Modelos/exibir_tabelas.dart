class ExibirTabelas {
  String tabelas;

  ExibirTabelas(
      {
      required this.tabelas,
      });

  factory ExibirTabelas.fromJson(Map<String, dynamic> json) {
    return ExibirTabelas(
      tabelas: json['Tables_in_id21590754_senturionscaledatabase'] as String,
    );
  }
}
