import 'package:flutter/material.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';

class Estilo {

  ThemeData get estiloGeral => ThemeData(
      appBarTheme: const AppBarTheme(
        color: PaletaCores.corAdtl,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      primaryColor: PaletaCores.corAdtl,
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: const TextStyle(
            fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
        hintStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: PaletaCores.corAdtl),
          borderRadius: BorderRadius.circular(5),
        ),
        //definindo estilo do textfied ao ser clicado
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: PaletaCores.corAdtl),
          borderRadius: BorderRadius.circular(5),
        ),
        labelStyle: const TextStyle(
          color: PaletaCores.corAdtl,
        ),
      ),
      // estilo dos botoes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          side: const BorderSide(color: PaletaCores.corVerdeCiano),
          backgroundColor: Colors.white,
          textStyle: const TextStyle( fontSize: 18),
          shadowColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
        ),
      )
  );
  ThemeData get estiloBotoes => ThemeData(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          side: const BorderSide(color: PaletaCores.corVerdeCiano),
          backgroundColor: Colors.white,
          textStyle: const TextStyle( fontSize: 18),
          shadowColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
        ),
      )
  );

}
