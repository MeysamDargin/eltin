import 'dart:async';
import 'package:eltin_gold/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainWrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(height: 16),
                    Text(
                      'نبض بازار طلا در دستان شما',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
