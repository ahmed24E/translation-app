import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:transelation_p/core/constants/app_constants.dart';
import 'package:transelation_p/core/di/injection_container.dart';

import 'package:transelation_p/feature/translator/data/models/translation_hive_model.dart';

import 'package:transelation_p/feature/translator/presentation/bloc/translator_bloc.dart';
import 'package:transelation_p/feature/translator/presentation/pages/translator_page.dart';

import 'package:transelation_p/feature/history/presentation/bloc/history_bloc.dart';
import 'package:transelation_p/feature/history/presentation/pages/history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Hive.initFlutter();

  
  Hive.registerAdapter(TranslationHiveModelAdapter());

  
  await Hive.openBox<TranslationHiveModel>(AppConstants.translationsBoxName);

 
  await initDependencies();

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Linguistic Editorial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A1A2E)),
        useMaterial3: true,
        fontFamily: 'Poppins', 
      ),

      
      home: BlocProvider(
        create: (_) => sl<TranslatorBloc>(),
        child: const TranslatorPage(),
      ),

      
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/history':
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => sl<HistoryBloc>(),
                child: const HistoryPage(),
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => sl<TranslatorBloc>(),
                child: const TranslatorPage(),
              ),
            );
        }
      },
    );
  }
}
