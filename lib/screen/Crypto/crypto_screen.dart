import 'package:shimmer/shimmer.dart';
import 'package:eltin_gold/providers/price_provider.dart';
import 'package:eltin_gold/screen/MarketDetail/market_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // List of all crypto keys extracted from nemoneh.json (USD versions)
  final Map<String, String> _cryptoMap = {
    'crypto-avalanche': 'Avalanche',
    'crypto-binance-coin': 'Binance Coin',
    'crypto-bitcoin': 'Bitcoin',
    'crypto-bitcoin-cash': 'Bitcoin Cash',
    'crypto-bittorrent': 'BitTorrent',
    'crypto-cardano': 'Cardano',
    'crypto-cashaa': 'Cashaa',
    'crypto-chainlink': 'Chainlink',
    'crypto-cosmos': 'Cosmos',
    'crypto-dash': 'Dash',
    'crypto-decred': 'Decred',
    'crypto-dogecoin': 'Dogecoin',
    'crypto-elrond': 'Elrond',
    'crypto-eos': 'EOS',
    'crypto-ethereum': 'Ethereum',
    'crypto-ethereum-classic': 'Ethereum Classic',
    'crypto-fantom': 'Fantom',
    'crypto-filecoin': 'Filecoin',
    'crypto-flow': 'Flow',
    'crypto-gala': 'Gala',
    'crypto-litecoin': 'Litecoin',
    'crypto-loopring-irc': 'Loopring',
    'crypto-maker': 'Maker',
    'crypto-monero': 'Monero',
    'crypto-nem': 'NEM',
    'crypto-neo': 'NEO',
    'crypto-pancakeswap': 'PancakeSwap',
    'crypto-polkadot': 'Polkadot',
    'crypto-ripple': 'XRP',
    'crypto-sandbox': 'The Sandbox',
    'crypto-shiba-inu': 'Shiba Inu',
    'crypto-solana': 'Solana',
    'crypto-stellar': 'Stellar',
    'crypto-tether': 'Tether',
    'crypto-tezos': 'Tezos',
    'crypto-toncoin': 'Toncoin',
    'crypto-tron': 'TRON',
    'crypto-uniswap': 'Uniswap',
    'crypto-usd-coin': 'USD Coin',
    'crypto-waves': 'Waves',
    'crypto-zcash': 'Zcash',
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
              Container(width: 100, height: 16, color: Colors.white),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(width: 80, height: 16, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 50, height: 12, color: Colors.white),
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
            Expanded(child: _buildCurrencyList()),
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
                'ارز دیجیتال',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(width: 12),
              Image.asset(
                'assets/icons/coin-bit-coin-svgrepo-com.png',
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
          hintText: 'جستجوی رمز ارز',
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

        _cryptoMap.forEach((key, name) {
          if (prices.containsKey(key)) {
            final priceItem = prices[key];
            if (_searchQuery.isEmpty ||
                name.toLowerCase().contains(_searchQuery.toLowerCase())) {
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
                      iconPath: 'assets/icons/coin-bit-coin-svgrepo-com.png',
                    ),
                  ),
                );
              },
              child: _buildCryptoCard(data['name'], data['item']),
            );
          },
        );
      },
    );
  }

  Widget _buildCryptoCard(String name, dynamic item) {
    bool isPositive = true;
    double percentVal = 0.0;
    try {
      percentVal = double.parse(item.dp.toString());
    } catch (_) {}

    // Determine color based on change direction/value
    if (item.dt == 'high' || percentVal > 0) {
      isPositive = true;
    } else {
      isPositive = false;
    }

    String changePercent = '${percentVal.toStringAsFixed(2)}%';
    if (isPositive) {
      changePercent = '+$changePercent';
    } else {
      // if it's already negative number, toString covers it, but usually dp is absolute in some APIs?
      // In nemoneh.json, dp is positive number, dt indicates direction.
      // "dt": "low" -> negative.
      if (item.dt == 'low') {
        changePercent = '-$changePercent';
        isPositive = false;
      }
    }

    String priceText = item.p.toString();
    // Format price with commas if it's a number
    try {
      String rawPrice = priceText.replaceAll(',', '');
      double priceVal = double.parse(rawPrice);
      final formatter = NumberFormat('#,###.##');
      priceText = formatter.format(priceVal);
    } catch (_) {}

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
          // Left: Name (English)
          Text(
            name,
            style: const TextStyle(
              fontFamily:
                  'Vazir', // Keeping Vazir for consistency, though text is English
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),

          // Right: Price and Percent
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color.fromARGB(255, 37, 185, 135).withOpacity(0.1)
                      : const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
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
            ],
          ),
        ],
      ),
    );
  }
}
