import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants.dart';
import 'views/ayah_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppConstants.bgDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const QuranAyatApp());
}

class QuranAyatApp extends StatelessWidget {
  const QuranAyatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppConstants.bgDark,
        colorScheme: const ColorScheme.dark(
          primary: AppConstants.goldPrimary,
          secondary: AppConstants.goldLight,
          surface: AppConstants.bgCard,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const AyahListScreen(),
    );
  }
}
