import 'dart:io';
import 'dart:typed_data';
import 'package:eltin_gold/providers/price_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart'; // پکیج جدید
import 'package:share_plus/share_plus.dart';
import 'package:shamsi_date/shamsi_date.dart';

class ScreenshotScreen extends StatefulWidget {
  const ScreenshotScreen({super.key});

  @override
  State<ScreenshotScreen> createState() => _ScreenshotScreenState();
}

class _ScreenshotScreenState extends State<ScreenshotScreen> {
  // کنترلر پکیج screenshot
  final ScreenshotController _screenshotController = ScreenshotController();

  bool _isCapturing = false;

  Future<void> _captureAndSaveScreenshot() async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      // capture مستقیم و پایدار (بدون مشکلات RepaintBoundary روی اندروید)
      final Uint8List? pngBytes = await _screenshotController.capture();

      if (pngBytes == null || pngBytes.isEmpty) {
        throw Exception('تصویر اسکرین‌شات خالی بود');
      }

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imagePath = '${directory.path}/eltin_gold_$timestamp.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);

      if (!mounted) return;

      setState(() {
        _isCapturing = false;
      });

      _showSuccessDialog(imagePath);
    } catch (e) {
      print('Error capturing screenshot: $e');

      if (mounted) {
        setState(() {
          _isCapturing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در گرفتن اسکرین‌شات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSuccessDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'اسکرین‌شات ذخیره شد',
          style: TextStyle(
            fontFamily: 'vazir',
            color: Color(0xffd9c68b),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'آیا می‌خواهید اسکرین‌شات را اشتراک‌گذاری کنید؟',
          style: TextStyle(fontFamily: 'vazir', color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'بستن',
              style: TextStyle(fontFamily: 'vazir', color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Share.shareXFiles([
                XFile(imagePath),
              ], text: 'قیمت لحظه‌ای بازار طلا و ارز\nEltin.gold');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffd9c68b),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'اشتراک‌گذاری',
              style: TextStyle(fontFamily: 'vazir', color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  String _toPersianDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(english[i], persian[i]);
    }
    return input;
  }

  String _getLastUpdateDateTime(PriceProvider provider) {
    final prices = provider.prices?.current;
    if (prices == null || prices.isEmpty) {
      return '---';
    }

    final referenceItem = prices['tgju_gold_irg18'] ?? prices.values.first;
    final dateTime = referenceItem.ts;

    final jalali = Jalali.fromDateTime(dateTime);
    final formatter = jalali.formatter;

    final dateStr = '${formatter.yyyy}/${formatter.mm}/${formatter.dd}';
    final timeStr =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';

    return _toPersianDigits('$dateStr - $timeStr');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF1a3235),
      body: Stack(
        children: [
          // محتوای اصلی – حالا داخل Screenshot ویجت پیچیده شده
          SingleChildScrollView(
            child: Screenshot(
              controller: _screenshotController,
              child: Container(
                constraints: BoxConstraints(minHeight: screenHeight),
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildPriceContent(screenHeight),
                      SizedBox(height: screenHeight * 0.02),
                      _buildFooter(),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // دکمه بازگشت (بالا سمت چپ)
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          // دکمه اسکرین‌شات (بالا سمت راست)
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              onPressed: _isCapturing ? null : _captureAndSaveScreenshot,
              icon: Image.asset(
                'assets/icons/screen-capture-svgrepo-com.png',
                color: const Color(0xffd9c68b),
                width: 30,
              ),
            ),
          ),

          // لودینگ هنگام capture
          if (_isCapturing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xffd9c68b)),
              ),
            ),
        ],
      ),
    );
  }

  // بقیه ویجت‌ها دقیقاً همون قبلی – بدون هیچ تغییری
  Widget _buildPriceContent(double screenHeight) {
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.24,
        ), // تنظیم پویا بر اساس ارتفاع صفحه (تقریبا 170 برای iPhone 16 با ارتفاع ~852 logical pixels)
        const Text(
          'قیمت لحظه‌ ای بازار',
          style: TextStyle(
            fontFamily: 'doran',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xffd9c68b),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Consumer<PriceProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getLastUpdateDateTime(provider),
                style: const TextStyle(
                  fontFamily: 'vazir',
                  fontSize: 17,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        SizedBox(height: screenHeight * 0.010),
        Consumer<PriceProvider>(
          builder: (context, provider, child) {
            if (provider.prices == null) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xffd9c68b)),
              );
            }

            final items = [
              {
                'key': 'tgju_gold_irg18',
                'name': 'طلای ۱۸ عیار',
                'icon': 'assets/icons/gold-bars.png',
              },
              {
                'key': 'geram24',
                'name': 'طلای ۲۴ عیار',
                'icon': 'assets/icons/gold.png',
              },
              {
                'key': 'silver_999',
                'name': 'نقره ۹۹۹',
                'icon': 'assets/icons/silver.png',
              },
              {
                'key': 'sekee',
                'name': 'سکه امامی',
                'icon': 'assets/icons/سکه-امامی.png',
              },
              {
                'key': 'sekeb',
                'name': 'سکه بهار آزادی',
                'icon': 'assets/icons/f2uJwWbvGo9Ooxi1-removebg-preview.png',
              },
              {
                'key': 'retail_nim',
                'name': 'نیم سکه',
                'icon': 'assets/icons/f2uJwWbvGo9Ooxi1-removebg-preview.png',
              },
              {
                'key': 'price_dollar_rl',
                'name': 'دلار آزاد',
                'icon': 'assets/icons/dollar.png',
              },
              {
                'key': 'crypto-bitcoin-irr',
                'name': 'بیت‌کوین',
                'icon': 'assets/icons/bitcoin.png',
              },
            ];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.028),
              child: Column(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final priceItem = provider.prices?.current[item['key']];
                  String priceText = '---';

                  if (priceItem != null) {
                    String rawPrice = priceItem.p.replaceAll(',', '');
                    if (rawPrice.isNotEmpty) {
                      try {
                        double priceVal = double.parse(rawPrice);
                        double tomanVal = priceVal / 10;
                        final formatter = NumberFormat('#,###');
                        priceText = formatter.format(tomanVal);
                      } catch (_) {
                        priceText = priceItem.p;
                      }
                    }
                  }

                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.012,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '$priceText تومان',
                                style: const TextStyle(
                                  fontFamily: 'DMSerifDisplay',
                                  fontSize: 20,
                                  color: Color(0xffd9c68b),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                Text(
                                  item['name']!,
                                  style: const TextStyle(
                                    fontFamily: 'doran',
                                    fontSize: 18,
                                    color: Color(0xffd9c68b),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xffd9c68b),
                                      width: 1,
                                    ),
                                  ),
                                  child: Image.asset(
                                    item['icon']!,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (index != items.length - 1)
                        Container(
                          height: 1.5,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xffd9c68b).withOpacity(0.0),
                                const Color(0xffd9c68b),
                                const Color(0xffd9c68b).withOpacity(0.0),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          color: const Color(0xffd9c68b).withOpacity(0.3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFooterItem(
              'assets/icons/web-svgrepo-com (1).png',
              'Eltin.gold',
            ),
            Container(
              height: 16,
              width: 1,
              color: Colors.white30,
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
            _buildFooterItem(
              'assets/icons/call-192-svgrepo-com.png',
              '09122962306',
            ),
            Container(
              height: 16,
              width: 1,
              color: Colors.white30,
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
            _buildFooterItem(
              'assets/icons/instagram-svgrepo-com.png',
              '@Eltin.gold',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterItem(String icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'vazir',
            fontSize: 16,
            color: Color(0xffd9c68b),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Image.asset(icon, width: 16, color: const Color(0xffd9c68b)),
      ],
    );
  }
}
