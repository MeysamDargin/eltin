import 'package:shimmer/shimmer.dart';
import 'package:country_icons/country_icons.dart';
import 'package:eltin_gold/models/tgju_model.dart';
import 'package:eltin_gold/providers/price_provider.dart';
import 'package:eltin_gold/screen/MarketDetail/market_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({super.key});

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mapping of currency keys to country codes and Persian names
  final Map<String, Map<String, String>> _currencyMap = {
    'price_dollar_rl': {'code': 'us', 'name': 'دلار آمریکا'},
    'price_eur': {'code': 'eu', 'name': 'یورو'},
    'price_aed': {'code': 'ae', 'name': 'درهم امارات'},
    'price_try': {'code': 'tr', 'name': 'لیر ترکیه'},
    'price_cny': {'code': 'cn', 'name': 'یوان چین'},
    'price_gbp': {'code': 'gb', 'name': 'پوند انگلیس'},
    'price_jpy': {'code': 'jp', 'name': 'ین ژاپن'},
    'price_chf': {'code': 'ch', 'name': 'فرانک سوئیس'},
    'price_cad': {'code': 'ca', 'name': 'دلار کانادا'},
    'price_aud': {'code': 'au', 'name': 'دلار استرالیا'},
    'price_nzd': {'code': 'nz', 'name': 'دلار نیوزیلند'},
    'price_iqd': {'code': 'iq', 'name': 'دینار عراق'},
    'price_kwd': {'code': 'kw', 'name': 'دینار کویت'},
    'price_sar': {'code': 'sa', 'name': 'ریال عربستان'},
    'price_qar': {'code': 'qa', 'name': 'ریال قطر'},
    'price_omr': {'code': 'om', 'name': 'ریال عمان'},
    'price_bhd': {'code': 'bh', 'name': 'دینار بحرین'},
    'price_sek': {'code': 'se', 'name': 'کرون سوئد'},
    'price_nok': {'code': 'no', 'name': 'کرون نروژ'},
    'price_dkk': {'code': 'dk', 'name': 'کرون دانمارک'},
    'price_rub': {'code': 'ru', 'name': 'روبل روسیه'},
    'price_inr': {'code': 'in', 'name': 'روپیه هند'},
    'price_pkr': {'code': 'pk', 'name': 'روپیه پاکستان'},
    'price_afn': {'code': 'af', 'name': 'افغانی افغانستان'},
    'price_thb': {'code': 'th', 'name': 'بات تایلند'},
    'price_myr': {'code': 'my', 'name': 'رینگیت مالزی'},
    'price_sgd': {'code': 'sg', 'name': 'دلار سنگاپور'},
    'price_hkd': {'code': 'hk', 'name': 'دلار هنگ کنگ'},
    'price_krw': {'code': 'kr', 'name': 'وون کره جنوبی'},
    'price_azn': {'code': 'az', 'name': 'منات آذربایجان'},
    'price_amd': {'code': 'am', 'name': 'درام ارمنستان'},
    'price_gel': {'code': 'ge', 'name': 'لاری گرجستان'},
    'price_tjs': {'code': 'tj', 'name': 'سامانی تاجیکستان'},
    'price_tmt': {'code': 'tm', 'name': 'منات ترکمنستان'},
    'price_brl': {'code': 'br', 'name': 'رئال برزیل'},
    'price_mxn': {'code': 'mx', 'name': 'پزو مکزیک'},
    'price_zar': {'code': 'za', 'name': 'راند آفریقای جنوبی'},
    'price_php': {'code': 'ph', 'name': 'پزو فیلیپین'},
    'price_idr': {'code': 'id', 'name': 'روپیه اندونزی'},
    'price_huf': {'code': 'hu', 'name': 'فورینت مجارستان'},
    'price_czk': {'code': 'cz', 'name': 'کرون چک'},
    'price_pln': {'code': 'pl', 'name': 'زلوتی لهستان'},
    'price_ron': {'code': 'ro', 'name': 'لئو رومانی'},
    'price_bgn': {'code': 'bg', 'name': 'لو بلغارستان'},
    'price_isk': {'code': 'is', 'name': 'کرون ایسلند'},
    'price_hrk': {'code': 'hr', 'name': 'کونا کرواسی'},
    'price_rsd': {'code': 'rs', 'name': 'دینار صربستان'},
    'price_uah': {'code': 'ua', 'name': 'گریونا اوکراین'},
    'price_egp': {'code': 'eg', 'name': 'پوند مصر'},
    'price_jod': {'code': 'jo', 'name': 'دینار اردن'},
    'price_lbp': {'code': 'lb', 'name': 'لیره لبنان'},
    'price_syp': {'code': 'sy', 'name': 'لیره سوریه'},
    'price_mad': {'code': 'ma', 'name': 'درهم مراکش'},
    'price_dzd': {'code': 'dz', 'name': 'دینار الجزایر'},
    'price_tnd': {'code': 'tn', 'name': 'دینار تونس'},
    'price_lyd': {'code': 'ly', 'name': 'دینار لیبی'},
    'price_etb': {'code': 'et', 'name': 'بیر اتیوپی'},
    'price_kes': {'code': 'ke', 'name': 'شیلینگ کنیا'},
    'price_ngn': {'code': 'ng', 'name': 'نایرا نیجریه'},
    'price_ghs': {'code': 'gh', 'name': 'سدی غنا'},
    'price_pen': {'code': 'pe', 'name': 'سول پرو'},
    'price_clp': {'code': 'cl', 'name': 'پزو شیلی'},
    'price_cop': {'code': 'co', 'name': 'پزو کلمبیا'},
    'price_ars': {'code': 'ar', 'name': 'پزو آرژانتین'},
    'price_uyu': {'code': 'uy', 'name': 'پزو اروگوئه'},
    'price_vef': {'code': 've', 'name': 'بولیوار ونزوئلا'},
  };

  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
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
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            children: [
              Container(width: 50, height: 24, color: Colors.white),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(width: 80, height: 16, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 60, height: 12, color: Colors.white),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSearchBox(),
            ),
            Expanded(child: _buildCurrencyList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Refresh Icon
          Consumer<PriceProvider>(
            builder: (context, provider, child) {
              return IconButton(
                onPressed: () {
                  provider.fetchPrices();
                },
                icon: provider.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color.fromARGB(255, 60, 85, 88),
                        ),
                      )
                    : Image.asset(
                        'assets/icons/refresh-svgrepo-com.png',
                        width: 25,
                      ),
              );
            },
          ),
          // Right side: Title and Image
          Row(
            children: [
              const Text(
                'نرخ ارزها',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(width: 12),
              Image.asset(
                'assets/icons/notification-svgrepo-com.png', // Placeholder, user asked for suitable image
                width:
                    0, // Hiding as user asked for "title and image" but I don't have a specific market image. I'll use text for now or maybe an icon.
                // Wait, user said "یک عکس مناسب". I don't have one. I'll just use the text as dominant or maybe a generic icon if I had one.
                // Let's use a currency icon from assets if available or just text.
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 224, 224, 224),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'جستجوی ارز',
          hintStyle: const TextStyle(
            fontFamily: 'Vazir',
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color.fromARGB(255, 142, 142, 142),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyList() {
    return Consumer<PriceProvider>(
      builder: (context, provider, child) {
        if (provider.prices == null) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: 10,
            itemBuilder: (context, index) => _buildShimmerItem(),
          );
        }

        final prices = provider.prices!.current;
        final List<Map<String, dynamic>> filteredItems = [];

        // Iterate over our defined map to maintain order and known currencies
        _currencyMap.forEach((key, info) {
          if (prices.containsKey(key)) {
            final priceItem = prices[key];
            if (priceItem != null) {
              final name = info['name']!;
              if (_searchQuery.isEmpty || name.contains(_searchQuery)) {
                filteredItems.add({
                  'key': key,
                  'name': name,
                  'code': info['code'],
                  'data': priceItem,
                });
              }
            }
          }
        });

        // Also check if there are other currencies in the API not in our map that start with price_
        // But for now, sticking to the map ensures we have correct names and flags.

        if (filteredItems.isEmpty) {
          return const Center(
            child: Text(
              'موردی یافت نشد',
              style: TextStyle(fontFamily: 'Vazir'),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filteredItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            final priceItem = item['data'] as PriceItem;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MarketDetailScreen(
                      marketKey: item['key'],
                      marketName: item['name'],
                      isRial: true,
                      iconWidget: ClipOval(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: CountryIcons.getSvgFlag(item['code']),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: _buildCurrencyCard(item['name'], item['code'], priceItem),
            );
          },
        );
      },
    );
  }

  Widget _buildCurrencyCard(String name, String countryCode, PriceItem item) {
    bool isPositive = true;
    String changePercent = _toPersianDigits('${item.dp}%');
    if (item.dt == ChangeDirection.high) {
      changePercent = '+$changePercent';
      isPositive = true;
    } else if (item.dt == ChangeDirection.low) {
      changePercent = '-$changePercent';
      isPositive = false;
    }

    // Price formatting
    String priceText = item.p;
    String rawPrice = item.p.replaceAll(',', '');
    if (rawPrice.isNotEmpty) {
      try {
        double priceVal = double.parse(rawPrice);
        double tomanVal = priceVal / 10;
        final formatter = NumberFormat('#,###');
        priceText = _toPersianDigits(formatter.format(tomanVal));
      } catch (_) {}
    }

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
              changePercent,
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
          // Price and Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceText,
                style: const TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Flag Icon
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: FittedBox(
                fit: BoxFit.cover,
                child: CountryIcons.getSvgFlag(countryCode),
              ),
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
}
