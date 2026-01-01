import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:eltin_gold/providers/price_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shamsi_date/shamsi_date.dart';

class ScreenshotScreen extends StatefulWidget {
  const ScreenshotScreen({super.key});

  @override
  State<ScreenshotScreen> createState() => _ScreenshotScreenState();
}

class _ScreenshotScreenState extends State<ScreenshotScreen> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isCapturing = false;

  Future<void> _captureAndSaveScreenshot() async {
    setState(() {
      _isCapturing = true;
    });

    try {
      // تاخیر کوتاه برای اطمینان از رندر شدن وضعیت جدید
      await Future.delayed(const Duration(milliseconds: 100));

      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      // بررسی اینکه آیا boundary آماده است
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imagePath = '${directory.path}/eltin_gold_$timestamp.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);

      setState(() {
        _isCapturing = false;
      });

      if (mounted) {
        _showSuccessDialog(imagePath);
      }
    } catch (e) {
      print('Error capturing screenshot: $e');
      setState(() {
        _isCapturing = false;
      });
      if (mounted) {
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

    // استفاده از زمان طلای ۱۸ عیار به عنوان مرجع، یا اولین آیتم موجود
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
    return Scaffold(
      backgroundColor: const Color(
        0xFF1a3235,
      ), // رنگ پس‌زمینه پیش‌فرض برای جلوگیری از سفیدی در اسکرول
      body: Stack(
        children: [
          // محتوای اصلی - اسکرول‌بل
          SingleChildScrollView(
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
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
                      _buildPriceContent(),
                      const SizedBox(height: 20),
                      _buildFooter(),
                      const SizedBox(height: 40),
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

          // لودینگ هنگام اسکرین‌شات
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

  Widget _buildPriceContent() {
    return Column(
      children: [
        // فضای بالا برای لوگوی بک‌گراند
        const SizedBox(height: 170),

        // عنوان
        const Text(
          'قیمت لحظه‌ ای بازار',
          style: TextStyle(
            fontFamily: 'doran',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xffd9c68b),
          ),
        ),

        const SizedBox(height: 8),

        // تاریخ و ساعت
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

        const SizedBox(height: 30),

        // لیست قیمت‌ها
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // قیمت (سمت چپ)
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
                            // آیکون و نام (سمت راست)
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
                      // خط جداکننده
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
