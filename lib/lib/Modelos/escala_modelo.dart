class EscalaModelo {
  String id;
  String primeiraHoraPulpito;
  String segundaHoraPulpito;
  String primeiraHoraEntrada;
  String segundaHoraEntrada;
  String recolherOferta;
  String uniforme;
  String mesaApoio;
  String servirSantaCeia;
  String dataCulto;
  String horarioTroca;
  String irmaoReserva;

  EscalaModelo(
      {required this.id,
      required this.primeiraHoraPulpito,
      required this.segundaHoraPulpito,
      required this.primeiraHoraEntrada,
      required this.segundaHoraEntrada,
      required this.recolherOferta,
      required this.uniforme,
      required this.mesaApoio,
      required this.servirSantaCeia,
      required this.dataCulto,
      required this.horarioTroca,
      required this.irmaoReserva});

  factory EscalaModelo.fromJson(Map<String, dynamic> json) {
    return EscalaModelo(
        id: json['id'] as String,
        primeiraHoraPulpito: json['primeiraHoraPulpito'] as String,
        segundaHoraPulpito: json['segundaHoraPulpito'] as String,
        primeiraHoraEntrada: json['primeiraHoraEntrada'] as String,
        segundaHoraEntrada: json['segundaHoraEntrada'] as String,
        recolherOferta: json['recolherOferta'] as String,
        uniforme: json['uniforme'] as String,
        mesaApoio: json['mesaApoio'] as String,
        servirSantaCeia: json['servirSantaCeia'] as String,
        dataCulto: json['dataCulto'] as String,
        horarioTroca: json['horarioTroca'] as String,
        irmaoReserva: json['irmaoReserva'] as String);
  }
}
