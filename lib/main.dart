import 'dart:async';

import 'package:al_quran/favorite.dart';
import 'package:al_quran/surahs.dart';
import 'package:al_quran/translations.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.light(
            surface: Colors.white,
            primary: const Color(0xff6AE131),
            secondary: Colors.black,
            inversePrimary: const Color(0xff6AE131),
            onSurface: Colors.grey.shade200,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff6AE131),
            foregroundColor: Colors.black,
          )),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            surface: Colors.grey.shade900,
            primary: Colors.grey.shade700,
            secondary: Colors.white,
            inversePrimary: Colors.grey.shade700,
            onSurface: Colors.grey.shade800,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey.shade700,
            foregroundColor: Colors.white,
          )),
      themeMode: ThemeMode.light,
      // themeMode: ThemeMode.system,
      home: const Splash(),
    );
  }
}


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();


}


class _SplashState extends State<Splash> {
@override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home(),));
    });
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      color: Theme.of(context).colorScheme.primary,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Image.asset('assets/images/logo.png',width: 300, height: 300,),
        const SpinKitWave(color: Colors.white,)
      ],),
    ),);
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FavSurahClass favSurahClass = FavSurahClass();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Al Quran',
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Quran'),
              ),
              Tab(
                child: Text('Translations'),
              ),
              Tab(
                child: Text('Favorites'),
              )
            ],
            labelStyle: TextStyle(color: Colors.black),
          ),
        ),
        body: TabBarView(children: [
          const Quran(),
          const TranslatedQuran(),
          FavoritesPage(favSurahClass: favSurahClass),
          
        ]),
      ),
    );
  }
}
