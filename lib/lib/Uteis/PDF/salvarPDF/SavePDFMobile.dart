import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
//future para salvar pdf no dispositivo
Future<void> salvarPDF(List<int> bytes,String nomeArquivo) async{
  final caminho = (await getApplicationDocumentsDirectory()).path;
  final file = File('$caminho/$nomeArquivo');
  await file.writeAsBytes(bytes,flush: true);
  OpenFile.open('$caminho/$nomeArquivo');

}