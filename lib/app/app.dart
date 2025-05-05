import "package:flutter/material.dart";
//import "package:flutter_application_1/app/view/home.dart";
import "package:flutter_application_1/app/view/splash/splash_page.dart";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const primary = Color(0xFF40B7AD);
  static const textColor = Color(0xFF4A4A4A);
  static const backgroundColor = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor:
                primary), //genera automáticamente una paleta de colores derivada del color semilla
        scaffoldBackgroundColor: backgroundColor, //fondo de color
        //letras
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Poppins',
              bodyColor: textColor,
              displayColor: textColor,
            ),
        useMaterial3:
            true, // para activar el material 3 del colorSchema appbar buttons y textFields

        // theme de modal
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),

        //theme de botones
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.maxFinite, 54), //tamaño
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
            foregroundColor: Colors.white, //letra
            backgroundColor: const Color(0xFF40B7AD), //fondo
          ),
        ),
      ),
      home: const SplashPage(), //ruta al siguiente archivo dart
    );
  }
}
