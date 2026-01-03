import 'package:cached_network_image/cached_network_image.dart'; // حتماً به pubspec.yaml اضافه کن
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

  final Map<String, String?> _cryptoIcons = {
    'Avalanche':
        'https://assets.coingecko.com/coins/images/12559/large/Avalanche_Circle_RedWhite_Trans.png?1696512369',
    'Binance Coin':
        'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png?1696501970',
    'Bitcoin':
        'https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400',
    'Bitcoin Cash':
        'https://assets.coingecko.com/coins/images/780/large/bitcoin-cash-circle.png?1696501932',
    'BitTorrent':
        'https://assets.coingecko.com/coins/images/22457/large/btt_logo.png?1696522119',
    'Cardano':
        'https://assets.coingecko.com/coins/images/975/large/cardano.png?1696502090',
    'Cashaa':
        'https://assets.coingecko.com/coins/images/2541/large/cashaa.png?1696503340',
    'Chainlink':
        'https://assets.coingecko.com/coins/images/877/large/chainlink-new-logo.png?1696502009',
    'Cosmos':
        'https://assets.coingecko.com/coins/images/1481/large/cosmos_hub.png?1696502525',
    'Dash':
        'https://assets.coingecko.com/coins/images/19/large/dash-logo.png?1696502023',
    'Decred':
        'https://assets.coingecko.com/coins/images/486/large/decred.png?1696502040',
    'Dogecoin':
        'https://assets.coingecko.com/coins/images/5/large/dogecoin.png?1696501409',
    'Elrond':
        'https://assets.coingecko.com/coins/images/12335/large/egld-token.png?1696512162',
    'EOS':
        'https://assets.coingecko.com/coins/images/738/large/eos-eos-logo.png?1696501893',
    'Ethereum':
        'https://assets.coingecko.com/coins/images/279/large/ethereum.png?1696501628',
    'Ethereum Classic':
        'https://assets.coingecko.com/coins/images/453/large/ethereum-classic-logo.png?1696501668',
    'Fantom':
        'https://assets.coingecko.com/coins/images/4001/large/Fantom_round.png?1696504642',
    'Filecoin':
        'https://assets.coingecko.com/coins/images/12817/large/filecoin.png?1696512609',
    'Flow':
        'https://assets.coingecko.com/coins/images/13446/large/5f6294c0c7a8cda55cb1c936_Flow_Wordmark.png?1696513210',
    'Gala':
        'https://assets.coingecko.com/coins/images/12493/large/GALA_token_image_-_200PNG.png?1709725869',
    'Litecoin':
        'https://assets.coingecko.com/coins/images/2/large/litecoin.png?1696501400',
    'Loopring':
        'https://assets.coingecko.com/coins/images/913/large/LRC.png?1696502034',
    'Maker':
        'https://assets.coingecko.com/coins/images/1364/large/Mark_Maker.png?1696502428',
    'Monero':
        'https://assets.coingecko.com/coins/images/69/large/monero_logo.png?1696501460',
    'NEM':
        'https://assets.coingecko.com/coins/images/242/large/NEM_Logo.png?1696501598',
    'NEO':
        'https://assets.coingecko.com/coins/images/480/large/NEO_512_512.png?1696501735',
    'PancakeSwap':
        'https://assets.coingecko.com/coins/images/12632/large/pancakeswap-cake-logo_%282%29.png?1696512440',
    'Polkadot':
        'https://assets.coingecko.com/coins/images/12171/large/polkadot.png?1696512012',
    'XRP':
        'https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png?1696501442',
    'The Sandbox':
        'https://assets.coingecko.com/coins/images/12129/large/sandbox_logo.jpg?1696511971',
    'Shiba Inu':
        'https://assets.coingecko.com/coins/images/11939/large/shiba.png?1696511800',
    'Solana':
        'https://assets.coingecko.com/coins/images/4128/large/solana.png?1696504756',
    'Stellar':
        'https://assets.coingecko.com/coins/images/100/large/Stellar_symbol_black_RGB.png?1696501482',
    'Tether':
        'https://assets.coingecko.com/coins/images/325/large/Tether.png?1696501661',
    'Tezos':
        'https://assets.coingecko.com/coins/images/976/large/Tezos-logo.png?1696502091',
    'Toncoin':
        'https://assets.coingecko.com/coins/images/17980/large/ton_symbol.png?1696517498',
    'TRON':
        'https://assets.coingecko.com/coins/images/1094/large/tron-logo.png?1696502193',
    'Uniswap':
        'https://assets.coingecko.com/coins/images/12504/large/uniswap-logo.png?1696512319',
    'USD Coin':
        'https://assets.coingecko.com/coins/images/6319/large/usdc.png?1696506694',
    'Waves':
        'https://assets.coingecko.com/coins/images/425/large/Waves.png?1696501881',
    'Zcash':
        'https://assets.coingecko.com/coins/images/486/large/circle-zcash-color.png?1696501740',
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
              Row(
                children: [
                  Container(width: 40, height: 40, color: Colors.white),
                  const SizedBox(width: 12),
                  Container(width: 100, height: 16, color: Colors.white),
                ],
              ),
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
            final String? iconUrl = _cryptoIcons[data['name']];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MarketDetailScreen(
                      marketKey: data['key'],
                      marketName: data['name'],
                      isRial: false,
                      iconPath:
                          'assets/icons/coin-bit-coin-svgrepo-com.png', // fallback برای صفحات قدیمی
                      networkIconUrl:
                          iconUrl, // این خط مهمه! آیکون واقعی رو می‌فرسته
                    ),
                  ),
                );
              },
              child: _buildCryptoCard(data['name'], data['item'], iconUrl),
            );
          },
        );
      },
    );
  }

  Widget _buildCryptoCard(String name, dynamic item, String? iconUrl) {
    bool isPositive = true;
    double percentVal = 0.0;
    try {
      percentVal = double.parse(item.dp.toString());
    } catch (_) {}

    if (item.dt == 'high' || percentVal > 0) {
      isPositive = true;
    } else {
      isPositive = false;
    }

    String changePercent = '${percentVal.toStringAsFixed(2)}%';
    if (isPositive) {
      changePercent = '+$changePercent';
    } else {
      if (item.dt == 'low') {
        changePercent = '-$changePercent';
        isPositive = false;
      }
    }

    String priceText = item.p.toString();
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
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: iconUrl != null
                    ? CachedNetworkImage(
                        imageUrl: iconUrl,
                        width: 40,
                        height: 40,
                        placeholder: (context, url) => const SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/icons/coin-bit-coin-svgrepo-com.png',
                          width: 40,
                          height: 40,
                        ),
                      )
                    : Image.asset(
                        'assets/icons/coin-bit-coin-svgrepo-com.png',
                        width: 40,
                        height: 40,
                      ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
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
