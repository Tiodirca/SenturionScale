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

  EscalaModelo({required this.id,
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

  // factory EscalaModelo.fromJson(Map<String, dynamic> json) {
  //   return EscalaModelo(
  //     id: json['id'] as String,
  //     primeiroHorario: json['primeiroHorario'] as String,
  //     segundoHorario: json['segundoHorario'] as String,
  //     primeiroHorarioPulpito: json['primeiroHorarioPulpito'] as String,
  //     segundoHorarioPulpito: json['segundoHorarioPulpito'] as String,
  //     recolherOferta: json['recolherOferta'] as String,
  //     uniforme: json['uniforme'] as String,
  //     mesaApoio: json['mesaApoio'] as String,
  //     servirCeia: json['servirCeia'] as String,
  //     dataSemana: json['dataSemana'] as String,
  //     horario: json['horario'] as String,
  //     reserva: json['reserva'] as String
  //   );
  // }
}
