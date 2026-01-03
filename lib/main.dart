import 'package:eltin_gold/providers/price_provider.dart';
import 'package:eltin_gold/screen/Splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PriceProvider()..fetchPrices()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'vazir',
        useMaterial3: true, // مهم برای اندروید 12+
        // تنظیمات دکمه‌های ناوبری سیستم
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.white, // پس‌زمینه سفید
          indicatorColor: Colors.transparent, // اگر اندیکاتور داری
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          iconTheme: MaterialStatePropertyAll(
            IconThemeData(color: Colors.black), // آیکون‌های سیاه
          ),
        ),
        // مهم‌ترین بخش: رنگ سیستم UI (دکمه‌های پایین)
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white, // پس‌زمینه دکمه‌ها سفید
            systemNavigationBarIconBrightness: Brightness.dark, // آیکون‌ها سیاه
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
