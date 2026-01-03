import 'dart:async';
import 'dart:convert';
import 'package:eltin_gold/widgets/custom_bottom_nav_bar.dart'; // یا مسیر MainWrapper
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isChecking = true;
  bool _isAuthorized = false;
  String _errorMessage = ''; // اضافه شد

  final String _webhookUrl =
      'https://asasfasfasfaf.app.n8n.cloud/webhook/374228d2-60ec-4230-b545-6c02ce624098';

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _checkServerAuthorization();
  }

  Future<void> _checkServerAuthorization() async {
    try {
      final response = await http
          .get(Uri.parse(_webhookUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = response.body.trim();
        if (body == '{"result":"ok"}') {
          setState(() {
            _isAuthorized = true;
            _isChecking = false;
          });

          Timer(const Duration(seconds: 4), () {
            _goToMainApp();
          });
        } else {
          _showErrorScreen('پاسخ سرور معتبر نیست');
        }
      } else {
        _showErrorScreen('خطا در ارتباط با سرور (کد: ${response.statusCode})');
      }
    } on TimeoutException {
      _showErrorScreen('اتصال به سرور زمان‌بر بود');
    } on Exception {
      _showErrorScreen('عدم دسترسی به اینترنت یا مشکل در سرور');
    }
  }

  void _goToMainApp() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainWrapper()),
    );
  }

  void _showErrorScreen(String message) {
    setState(() {
      _isChecking = false;
      _isAuthorized = false;
      _errorMessage = message; // ذخیره پیام
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return _buildSplash();
    }

    if (!_isAuthorized) {
      return _buildErrorScreen(_errorMessage); // حالا message تعریف شده
    }

    return _buildSplash();
  }

  Widget _buildSplash() {
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
            if (_isChecking) const Center(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_clock_rounded,
                  size: 100,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 32),
                const Text(
                  'نسخه آزمایشی منقضی شده',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'مدت زمان تست ۱۲ ساعته به پایان رسیده است.',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 18,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'برای دسترسی به نسخه کامل و بدون محدودیت، لطفاً با ما تماس بگیرید.',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // دکمه تماس با پشتیبانی (اختیاری - ایمیل یا تلگرام)
                ElevatedButton.icon(
                  onPressed: () async {
                    // مثال: باز کردن ایمیل
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'm10551691@gmail.com', // ایمیل خودت رو بذار
                      query: 'subject=درخواست نسخه کامل اپلیکیشن التین گلد',
                    );
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    }
                  },
                  icon: const Icon(Icons.contact_mail_outlined),
                  label: const Text(
                    'تماس با پشتیبانی',
                    style: TextStyle(fontFamily: 'Vazir', fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => SystemNavigator.pop(), // بستن اپ در اندروید
                  child: const Text(
                    'بستن اپلیکیشن',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
