import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:senturionscale/Uteis/Rotas.dart';
import 'package:senturionscale/Uteis/ScrollBehaviorPersonalizado.dart';
import 'package:senturionscale/Uteis/constantes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senturion Scale',
      scrollBehavior: ScrollBehaviorPersonalizado(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //definicoes usadas no date picker
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      //setando o suporte da lingua usada no data picker
      supportedLocales: const [Locale('pt', 'BR')],
      initialRoute: Constantes.rotaTelaSplashScreen,
      onGenerateRoute: Rotas.generateRoute,
    );
  }
}
