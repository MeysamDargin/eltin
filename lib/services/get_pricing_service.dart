import 'package:http/http.dart' as http;
import 'dart:math';
import '../models/tgju_model.dart';

class TgjuService {
  static const String _baseUrl = "https://call2.tgju.org/ajax.json";

  /// تولید rev تصادفی (۴۰ کاراکتر الفبا و عدد – شبیه توکن‌های واقعی)
  static String _generateRandomRev() {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        40,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  static Future<TgjuResponse> fetchPrices() async {
    try {
      // هر بار rev جدید و تصادفی
      final String randomRev = _generateRandomRev();
      final String apiUrl = "$_baseUrl?rev=$randomRev";

      print("درخواست به (با rev تصادفی): $apiUrl");

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          'Accept': 'application/json, text/plain, */*',
          'Referer': 'https://www.tgju.org/',
          'Cache-Control': 'no-cache', // اضافی برای ضدکش
        },
      );

      print("کد وضعیت: ${response.statusCode}");
      print("طول داده: ${response.body.length} کاراکتر");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return tgjuResponseFromJson(response.body);
      } else {
        throw Exception("ریسپانس ناقص: کد ${response.statusCode}");
      }
    } catch (e) {
      print("خطا در سرویس: $e");
      throw Exception("خطا در ارتباط: $e");
    }
  }
}
