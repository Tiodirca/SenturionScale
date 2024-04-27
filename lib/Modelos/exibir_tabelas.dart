class ExibirTabelas {
  String tabelas;

  ExibirTabelas(
      {
      required this.tabelas,
      });

  factory ExibirTabelas.fromJson(Map<String, dynamic> json) {
    return ExibirTabelas(
      tabelas: json['Tables_in_id22037631_senturionscale'] as String,
    );
  }
}
