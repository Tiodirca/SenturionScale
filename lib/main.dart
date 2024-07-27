import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:senturionscale/Uteis/textos.dart';

import 'Uteis/Rotas.dart';
import 'Uteis/ScrollBehaviorPersonalizado.dart';
import 'Uteis/constantes.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).whenComplete(() => print("Completo"));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Textos.nomeAplicacao,
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
