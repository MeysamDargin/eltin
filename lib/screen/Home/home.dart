import 'package:shimmer/shimmer.dart';
import 'package:eltin_gold/models/tgju_model.dart';
import 'package:eltin_gold/providers/price_provider.dart';
import 'package:eltin_gold/screen/Commodities/commodities_screen.dart';
import 'package:eltin_gold/screen/Crypto/crypto_screen.dart';
import 'package:eltin_gold/screen/Energy/energy_screen.dart';
import 'package:eltin_gold/screen/MarketDetail/market_detail_screen.dart';
import 'package:eltin_gold/screen/Metals/metals_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Header Section
              _buildHeader(),
              const SizedBox(height: 20),

              // Balance Card
              _buildBalanceCard(),
              const SizedBox(height: 20),

              // Quick Actions
              _buildQuickActions(),
              const SizedBox(height: 24),

              // Section Title
              _buildSectionTitle('بازار'),
              const SizedBox(height: 12),

              // Market List
              Consumer<PriceProvider>(
                builder: (context, provider, child) {
                  final List<Map<String, dynamic>> marketItemsConfig = [
                    {
                      'key': 'tgju_gold_irg18',
                      'title': 'طلای ۱۸ عیار',
                      'subtitle': 'طلای ۱۸ عیار',
                      'icon': 'assets/icons/gold-bars.png',
                      'color': Colors.amber,
                      'isRial': true,
                    },
                    {
                      'key': 'sekee',
                      'title': 'سکه امامی',
                      'subtitle': 'سکه امامی',
                      'icon': 'assets/icons/سکه-امامی.png',
                      'color': Colors.orange,
                      'isRial': true,
                    },
                    {
                      'key': 'price_dollar_rl',
                      'title': 'دلار آزاد',
                      'subtitle': 'دلار بازار آزاد',
                      'icon': 'assets/icons/dollar.png',
                      'color': Colors.green,
                      'isRial': true,
                    },
                    {
                      'key': 'crypto-tether-irr',
                      'title': 'تتر',
                      'subtitle': 'تتر به تومان',
                      'icon': 'assets/icons/usdt.png',
                      'color': Colors.teal,
                      'isRial': true,
                    },
                    {
                      'key': 'crypto-bitcoin-irr',
                      'title': 'بیت‌کوین',
                      'subtitle': 'بیت کوین به تومان',
                      'icon': 'assets/icons/bitcoin.png',
                      'color': Colors.orangeAccent,
                      'isRial': true,
                    },
                    {
                      'key': 'sekeb',
                      'title': 'نیم سکه',
                      'subtitle': 'نیم سکه بهار آزادی',
                      'icon':
                          'assets/icons/f2uJwWbvGo9Ooxi1-removebg-preview.png',
                      'color': Colors.amberAccent,
                      'isRial': true,
                    },
                    {
                      'key': 'tether_gold_xaut',
                      'title': 'اونس جهانی طلا',
                      'subtitle': 'اونس جهانی طلا',
                      'icon': 'assets/icons/gold.png',
                      'color': Colors.blueGrey,
                      'isRial': false,
                    },
                    {
                      'key': 'oil_brent',
                      'title': 'نفت برنت',
                      'subtitle': 'نفت برنت',
                      'icon': 'assets/icons/oil-drum.png',
                      'color': Colors.black,
                      'isRial': false,
                    },
                    {
                      'key': 'silver',
                      'title': 'انس جهانی نقره',
                      'subtitle': 'انس جهانی نقره (دلار)',
                      'icon': 'assets/icons/silver.png',
                      'color': Colors.grey,
                      'isRial': false,
                    },
                    {
                      'key': 'silver_999',
                      'title': 'گرم نقره ۹۹۹',
                      'subtitle': 'گرم نقره ۹۹۹',
                      'icon': 'assets/icons/2nd-place.png',
                      'color': Colors.blueGrey,
                      'isRial': true,
                    },
                    {
                      'key': 'silver_925',
                      'title': 'گرم نقره ۹۲۵',
                      'subtitle': 'گرم نقره ۹۲۵',
                      'icon': 'assets/icons/game.png',
                      'color': Colors.blueGrey,
                      'isRial': true,
                    },
                    {
                      'key': 'geram24',
                      'title': 'طلای ۲۴ عیار',
                      'subtitle': 'طلای ۲۴ عیار',
                      'icon': 'assets/icons/gold.png',
                      'color': Colors.amber,
                      'isRial': true,
                    },
                  ];

                  if (provider.prices == null) {
                    return Column(
                      children: List.generate(
                        5,
                        (index) => _buildShimmerItem(),
                      ),
                    );
                  }

                  return Column(
                    children: marketItemsConfig.map((item) {
                      final priceItem = provider.prices?.current[item['key']];
                      if (priceItem == null) return const SizedBox.shrink();

                      String priceText = priceItem.p;
                      String changePercent = '0%';
                      bool isPositive = true;

                      // Format Price
                      if (item['isRial'] == true) {
                        String rawPrice = priceItem.p.replaceAll(',', '');
                        if (rawPrice.isNotEmpty) {
                          try {
                            double priceVal = double.parse(rawPrice);
                            double tomanVal = priceVal / 10;
                            final formatter = NumberFormat('#,###');
                            priceText = _toPersianDigits(
                              formatter.format(tomanVal),
                            );
                          } catch (_) {}
                        }
                      } else {
                        priceText = _toPersianDigits(priceItem.p);
                      }

                      // Format Change
                      changePercent = _toPersianDigits('${priceItem.dp}%');
                      if (priceItem.dt == ChangeDirection.high) {
                        changePercent = '+$changePercent';
                        isPositive = true;
                      } else if (priceItem.dt == ChangeDirection.low) {
                        changePercent = '-$changePercent';
                        isPositive = false;
                      } else {
                        isPositive = true; // Default or grey
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MarketDetailScreen(
                                  marketKey: item['key'],
                                  marketName: item['title'],
                                  iconPath: item['icon'],
                                  isRial: item['isRial'],
                                ),
                              ),
                            );
                          },
                          child: _buildMarketItem(
                            item['title'],
                            item['subtitle'],
                            priceText,
                            changePercent,
                            isPositive,
                            item['icon'],
                            item['color'],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 80, height: 16, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 50, height: 12, color: Colors.white),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(width: 60, height: 16, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 100, height: 12, color: Colors.white),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<PriceProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(), // فاصله از لبه‌ها
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      provider.fetchPrices(silent: false);
                    },
                    icon: provider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF1F2937),
                            ),
                          )
                        : Image.asset(
                            'assets/icons/refresh-svgrepo-com.png',
                            width: 25,
                          ),
                  ),
                  Image.asset(
                    'assets/icons/notification-svgrepo-com.png',
                    width: 25,
                  ),
                ],
              ),
            ),
            const Text(
              'التین گلد',
              style: TextStyle(
                fontFamily: 'Vazir',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        );
      },
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

  Widget _buildBalanceCard() {
    return Consumer<PriceProvider>(
      builder: (context, provider, child) {
        final priceItem = provider.prices?.current['geram18'];
        String priceText = '---';
        String changePercent = '---';
        String dateText = '---';
        IconData changeIcon = Icons.minimize;

        if (priceItem != null) {
          // محاسبه قیمت به تومان (حذف صفر آخر)
          String rawPrice = priceItem.p.replaceAll(',', '');
          if (rawPrice.isNotEmpty) {
            try {
              double priceVal = double.parse(rawPrice);
              double tomanVal = priceVal / 10;
              final formatter = NumberFormat('#,###');
              priceText = _toPersianDigits(formatter.format(tomanVal));
            } catch (e) {
              priceText = priceItem.p;
            }
          }

          // محاسبه درصد تغییر
          changePercent = _toPersianDigits('${priceItem.dp}%');
          if (priceItem.dt == ChangeDirection.high) {
            changePercent = '+$changePercent';
          } else if (priceItem.dt == ChangeDirection.low) {
            changePercent = '-$changePercent';
          }

          // تاریخ (تبدیل به شمسی)
          try {
            Jalali jalali = Jalali.fromDateTime(priceItem.ts);
            JalaliFormatter f = jalali.formatter;
            dateText = '${_toPersianDigits(f.d)} ${f.mN}';
          } catch (e) {
            dateText = priceItem.t;
          }

          // جهت تغییر
          if (priceItem.dt == ChangeDirection.high) {
            changeIcon = Icons.trending_up;
          } else if (priceItem.dt == ChangeDirection.low) {
            changeIcon = Icons.trending_down;
          }
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1a3235), Color.fromARGB(255, 46, 83, 88)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1a3235).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      'assets/img/1k_Dissolve_Noise_Texture.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(changeIcon, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  changePercent,
                                  style: const TextStyle(
                                    fontFamily: 'Vazir',
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'طلای ۱۸ عیار',
                            style: TextStyle(
                              fontFamily: 'Vazir',
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      provider.isLoading && priceItem == null
                          ? Shimmer.fromColors(
                              baseColor: Colors.white.withOpacity(0.5),
                              highlightColor: Colors.white.withOpacity(0.2),
                              child: Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          : Text(
                              priceText,
                              style: const TextStyle(
                                fontFamily: 'Vazir',
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      const SizedBox(height: 4),
                      const Text(
                        'تومان',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    dateText,
                    style: const TextStyle(
                      fontFamily: 'Vazir',
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Builder(
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              'assets/icons/oil-pump-svgrepo-com.png',
              'نفت و انرژی',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EnergyScreen()),
                );
              },
            ),
            _buildActionButton(
              'assets/icons/gold-ingot.png',
              'فلزات',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MetalsScreen()),
                );
              },
            ),
            _buildActionButton(
              'assets/icons/grocery-store-groceries-svgrepo-com.png',
              'کالای اساسی',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommoditiesScreen(),
                  ),
                );
              },
            ),
            _buildActionButton(
              'assets/icons/coin-bit-coin-svgrepo-com.png',
              'ارز دیجیتال',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CryptoScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(String icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                icon,
                color: const Color.fromARGB(255, 72, 101, 105),
                width: 28, // حالا این ۲۴ اعمال می‌شود
                height: 28,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Vazir',
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: const Text(
            'مشاهده همه',
            style: TextStyle(
              fontFamily: 'Vazir',
              color: Color.fromARGB(255, 60, 85, 88),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Vazir',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildMarketItem(
    String title,
    String subtitle,
    String price,
    String change,
    bool isPositive,
    dynamic icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Change Percentage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isPositive
                  ? const Color.fromARGB(255, 37, 185, 135).withOpacity(0.1)
                  : const Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              change,
              style: TextStyle(
                fontFamily: 'Vazir',
                color: isPositive
                    ? const Color.fromARGB(255, 0, 112, 75)
                    : const Color(0xFFEF4444),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          // Price and Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: icon is IconData
                ? Icon(icon, color: iconColor, size: 24)
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(icon, width: 24, height: 24),
                  ),
          ),
        ],
      ),
    );
  }
}
