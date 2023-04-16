import 'package:universal_html/html.dart';
import 'dart:convert';
//future para salvar pdf na web
Future<void> salvarPDF(List<int> bytes,String nomeArquivo)async {

  AnchorElement(href: "data:application/octet-stream;charset=utf-16le;"
      "base64,${base64.encode(bytes)}")..setAttribute("download", nomeArquivo)..click();
}