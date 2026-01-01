import 'package:country_icons/country_icons.dart';
import 'package:eltin_gold/providers/price_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  final TextEditingController _amountController = TextEditingController(
    text: '1',
  );
  String _selectedSourceKey = 'tgju_gold_irg18';
  String _selectedTargetKey = 'toman';

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

  final List<Map<String, String>> _assets = [
    {'key': 'toman', 'name': 'تومان', 'icon': 'assets/icons/gold-ingot.png'},
    {
      'key': 'tgju_gold_irg18',
      'name': 'طلای ۱۸ عیار',
      'icon': 'assets/icons/gold-bars.png',
    },
    {'key': 'geram24', 'name': 'طلای ۲۴ عیار', 'icon': 'assets/icons/gold.png'},
    {
      'key': 'silver_999',
      'name': 'نقره ۹۹۹',
      'icon': 'assets/icons/silver.png',
    },
    {'key': 'sekee', 'name': 'سکه امامی', 'icon': 'assets/icons/سکه-امامی.png'},
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
    {
      'key': 'crypto-tether-irr',
      'name': 'تتر',
      'icon': 'assets/icons/usdt.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double _getPriceInToman(String key, PriceProvider provider) {
    if (key == 'toman') return 1.0;

    final item = provider.prices?.current[key];
    if (item == null) return 0.0;

    String rawPrice = item.p.replaceAll(',', '');
    try {
      double priceVal = double.parse(rawPrice);
      return priceVal / 10;
    } catch (_) {
      return 0.0;
    }
  }

  Map<String, dynamic> _getAssetInfo(String key) {
    try {
      final asset = _assets.firstWhere((e) => e['key'] == key);
      return {...asset, 'type': 'local'};
    } catch (_) {}

    if (_currencyMap.containsKey(key)) {
      final info = _currencyMap[key]!;
      return {
        'key': key,
        'name': info['name'],
        'code': info['code'],
        'type': 'flag',
      };
    }

    return {
      'key': key,
      'name': 'ناشناخته',
      'icon': 'assets/icons/gold-ingot.png',
      'type': 'local',
    };
  }

  String _toPersianDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(english[i], persian[i]);
    }
    return input;
  }

  String _toEnglishDigits(String input) {
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(persian[i], english[i]);
    }
    return input;
  }

  void _showCurrencyBottomSheet(
    BuildContext context,
    String currentKey,
    ValueChanged<String> onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DefaultTabController(
          length: 2,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  'انتخاب ارز',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 20),
                const TabBar(
                  labelColor: Color(0xFF1a3235),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(0xFF1a3235),
                  labelStyle: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(text: 'طلا و کریپتو'),
                    Tab(text: 'ارزهای فیات'),
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: TabBarView(
                    children: [
                      // Tab 1: Gold & Crypto
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: _assets.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: Colors.grey[200]),
                        itemBuilder: (context, index) {
                          final asset = _assets[index];
                          final isSelected = asset['key'] == currentKey;
                          return ListTile(
                            onTap: () {
                              onSelect(asset['key']!);
                              Navigator.pop(context);
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1a3235).withOpacity(0.1)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                asset['icon']!,
                                width: 24,
                                height: 24,
                              ),
                            ),
                            title: Text(
                              asset['name']!,
                              style: TextStyle(
                                fontFamily: 'Vazir',
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? const Color(0xFF1F2937)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF1a3235),
                                    size: 24,
                                  )
                                : null,
                          );
                        },
                      ),

                      // Tab 2: Fiat Currencies
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: _currencyMap.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: Colors.grey[200]),
                        itemBuilder: (context, index) {
                          final key = _currencyMap.keys.elementAt(index);
                          final info = _currencyMap[key]!;
                          final isSelected = key == currentKey;
                          return ListTile(
                            onTap: () {
                              onSelect(key);
                              Navigator.pop(context);
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1a3235)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: CountryIcons.getSvgFlag(info['code']!),
                                ),
                              ),
                            ),
                            title: Text(
                              info['name']!,
                              style: TextStyle(
                                fontFamily: 'Vazir',
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? const Color(0xFF1F2937)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF1a3235),
                                    size: 24,
                                  )
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAssetIcon(Map<String, dynamic> asset) {
    if (asset['type'] == 'flag') {
      return ClipOval(
        child: FittedBox(
          fit: BoxFit.cover,
          child: CountryIcons.getSvgFlag(asset['code']!),
        ),
      );
    }
    return Image.asset(asset['icon']!);
  }

  Widget _buildCurrencySelectorButton(
    BuildContext context,
    Map<String, dynamic> asset,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
            Row(
              children: [
                Text(
                  asset['name']!,
                  style: const TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 32,
                  height: 32,
                  padding: asset['type'] == 'flag'
                      ? EdgeInsets.zero
                      : const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: asset['type'] == 'flag'
                        ? Border.all(color: Colors.grey[200]!)
                        : null,
                  ),
                  child: _buildAssetIcon(asset),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PriceProvider>(
      builder: (context, provider, child) {
        double sourcePrice = _getPriceInToman(_selectedSourceKey, provider);
        double targetPrice = _getPriceInToman(_selectedTargetKey, provider);

        String amountText = _toEnglishDigits(
          _amountController.text,
        ).replaceAll(',', '');
        double amount = double.tryParse(amountText) ?? 0.0;

        double result = 0.0;
        if (targetPrice > 0 && sourcePrice > 0) {
          result = amount * (sourcePrice / targetPrice);
        }

        final formatter = NumberFormat('#,###.##');

        final sourceAsset = _getAssetInfo(_selectedSourceKey);
        final targetAsset = _getAssetInfo(_selectedTargetKey);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: Color(0xFF6B7280),
                            size: 20,
                          ),
                        ),
                        const Text(
                          'مبدل ارز',
                          style: TextStyle(
                            fontFamily: 'Vazir',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Exchange Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Source Section
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'می‌دهید',
                                  style: TextStyle(
                                    fontFamily: 'Vazir',
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Amount Input
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TextField(
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    onTap: () {
                                      if (_amountController.text.isNotEmpty) {
                                        _amountController.selection =
                                            TextSelection(
                                              baseOffset: 0,
                                              extentOffset:
                                                  _amountController.text.length,
                                            );
                                      }
                                    },
                                    style: const TextStyle(
                                      fontFamily: 'Vazir',
                                      fontSize: 24,
                                      color: Color(0xFF1F2937),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      hintText: '۰',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Source Currency Selector
                                _buildCurrencySelectorButton(
                                  context,
                                  sourceAsset,
                                  () => _showCurrencyBottomSheet(
                                    context,
                                    _selectedSourceKey,
                                    (val) => setState(
                                      () => _selectedSourceKey = val,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Swap Button
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  final temp = _selectedSourceKey;
                                  _selectedSourceKey = _selectedTargetKey;
                                  _selectedTargetKey = temp;
                                });
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1a3235),
                                      Color.fromARGB(255, 46, 83, 88),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF1a3235,
                                      ).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.swap_vert,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),

                          // Target Section
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'دریافت می‌کنید',
                                  style: TextStyle(
                                    fontFamily: 'Vazir',
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Result Display
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(
                                          0xFF1a3235,
                                        ).withOpacity(0.05),
                                        const Color.fromARGB(
                                          255,
                                          46,
                                          83,
                                          88,
                                        ).withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _toPersianDigits(
                                        formatter.format(result),
                                      ),
                                      style: const TextStyle(
                                        fontFamily: 'Vazir',
                                        fontSize: 24,
                                        color: Color(0xFF1F2937),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Target Currency Selector
                                _buildCurrencySelectorButton(
                                  context,
                                  targetAsset,
                                  () => _showCurrencyBottomSheet(
                                    context,
                                    _selectedTargetKey,
                                    (val) => setState(
                                      () => _selectedTargetKey = val,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Exchange Rate Info
                    if (sourcePrice > 0 && targetPrice > 0)
                      Container(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF1a3235,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.trending_up,
                                    color: Color(0xFF1a3235),
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '۱ ${sourceAsset['name']} = ${_toPersianDigits(formatter.format(sourcePrice / targetPrice))} ${targetAsset['name']}',
                              style: TextStyle(
                                fontFamily: 'Vazir',
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w600,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
