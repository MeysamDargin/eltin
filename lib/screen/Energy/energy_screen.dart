import 'package:shimmer/shimmer.dart';
import 'package:eltin_gold/providers/price_provider.dart';
import 'package:eltin_gold/screen/MarketDetail/market_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';

class EnergyScreen extends StatefulWidget {
  const EnergyScreen({super.key});

  @override
  State<EnergyScreen> createState() => _EnergyScreenState();
}

class _EnergyScreenState extends State<EnergyScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Map of energy keys to Persian names
  final Map<String, String> _energyMap = {
    'oil': 'نفت خام آمریکا (WTI)',
    'oil_brent': 'نفت برنت (Brent)',
    'oil_opec': 'سبد نفتی اوپک (OPEC)',
    'base-us-uranium': 'اورانیوم (Uranium)',
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 60, height: 24, color: Colors.white),
              const Spacer(),
              Row(
                children: [
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
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Back + Refresh
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 24,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(width: 12),
              Consumer<PriceProvider>(
                builder: (context, provider, child) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
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
            ],
          ),
          // Title and Icon
          Row(
            children: [
              const Text(
                'نفت و انرژی',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(width: 12),
              Image.asset(
                'assets/icons/oil-pump-svgrepo-com.png',
                width: 28,
                color: const Color.fromARGB(255, 60, 85, 88),
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
          hintText: 'جستجوی انرژی...',
          hintStyle: const TextStyle(
            fontFamily: 'Vazir',
            color: Color(0xFF9CA3AF),
            fontSize: 14,
          ),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
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

        _energyMap.forEach((key, name) {
          if (prices.containsKey(key)) {
            final priceItem = prices[key];
            if (_searchQuery.isEmpty || name.contains(_searchQuery)) {
              filteredItems.add({'key': key, 'name': name, 'item': priceItem});
            }
          }
        });

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
            final data = filteredItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MarketDetailScreen(
                      marketKey: data['key'],
                      marketName: data['name'],
                      isRial: false,
                      iconPath: 'assets/icons/oil-pump-svgrepo-com.png',
                    ),
                  ),
                );
              },
              child: _buildEnergyCard(data['name'], data['item']),
            );
          },
        );
      },
    );
  }

  Widget _buildEnergyCard(String name, dynamic item) {
    bool isPositive = true;
    String changePercent = _toPersianDigits('${item.dp}%');
    if (item.dt == 'high') {
      changePercent = '+$changePercent';
      isPositive = true;
    } else if (item.dt == 'low') {
      changePercent = '-$changePercent';
      isPositive = false;
    }

    String priceText = item.p.toString();
    // Format price
    try {
      String rawPrice = priceText.replaceAll(',', '');
      double priceVal = double.parse(rawPrice);
      final formatter = NumberFormat('#,###.##');
      priceText = _toPersianDigits(formatter.format(priceVal));
    } catch (_) {
      priceText = _toPersianDigits(priceText);
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Change Percent
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

          // Right side: Price and Name
          Row(
            children: [
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
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/oil-drum.png',
                    width: 24,
                    // color: const Color.fromARGB(255, 60, 85, 88), // No color filter for full color icon
                  ),
                ),
              ),
            ],
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
