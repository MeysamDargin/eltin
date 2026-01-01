import 'package:eltin_gold/models/tgju_model.dart';
import 'package:eltin_gold/providers/price_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';

class MarketDetailScreen extends StatelessWidget {
  final String marketKey;
  final String marketName;
  final String iconPath;
  final Widget? iconWidget;
  final bool isRial;

  const MarketDetailScreen({
    super.key,
    required this.marketKey,
    required this.marketName,
    this.iconPath = '',
    this.iconWidget,
    required this.isRial,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Consumer<PriceProvider>(
          builder: (context, provider, child) {
            final prices = provider.prices?.current;
            if (prices == null || !prices.containsKey(marketKey)) {
              return const Center(child: CircularProgressIndicator());
            }

            final item = prices[marketKey];
            final buyKey = '${marketKey}_buy';
            final buyItem = prices.containsKey(buyKey) ? prices[buyKey] : null;

            ToleranceItem? lastItem;
            if (provider.prices?.last != null) {
              try {
                lastItem = provider.prices!.last.firstWhere(
                  (element) => element.name == marketKey,
                );
              } catch (_) {}
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildMainPriceCard(item),
                  const SizedBox(height: 16),
                  if (buyItem != null) ...[
                    _buildBuySellRow(item, buyItem),
                    const SizedBox(height: 16),
                  ],
                  _buildDetailsGrid(item, lastItem),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1F2937)),
        ),
        Row(
          children: [
            Text(
              marketName,
              style: const TextStyle(
                fontFamily: 'Vazir',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(width: 12),
            if (iconWidget != null)
              SizedBox(width: 32, height: 32, child: iconWidget)
            else if (iconPath.isNotEmpty)
              Image.asset(iconPath, width: 32, height: 32),
          ],
        ),
      ],
    );
  }

  Widget _buildMainPriceCard(dynamic item) {
    bool isPositive = true;
    String changePercent = _toPersianDigits('${item.dp}%');
    if (item.dt == ChangeDirection.high) {
      changePercent = '+$changePercent';
      isPositive = true;
    } else if (item.dt == ChangeDirection.low) {
      changePercent = '-$changePercent';
      isPositive = false;
    }

    // Format update time
    String updateTime = _toPersianDigits(item.t);
    try {
      Jalali jalali = Jalali.fromDateTime(item.ts);
      JalaliFormatter f = jalali.formatter;
      updateTime = '${_toPersianDigits(f.d)} ${f.mN} - $updateTime';
    } catch (_) {}

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'قیمت فعلی فروش',
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _formatPrice(item.p),
            style: const TextStyle(
              fontFamily: 'Vazir',
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color.fromARGB(255, 37, 185, 135).withOpacity(0.1)
                      : const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: isPositive
                          ? const Color.fromARGB(255, 0, 112, 75)
                          : const Color(0xFFEF4444),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      changePercent,
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        color: isPositive
                            ? const Color.fromARGB(255, 0, 112, 75)
                            : const Color(0xFFEF4444),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Color(0xFF9CA3AF),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'بروزرسانی: $updateTime',
                    style: const TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuySellRow(dynamic sellItem, dynamic buyItem) {
    return Row(
      children: [
        Expanded(
          child: _buildPriceBox(
            'فروش بازار',
            sellItem.p,
            sellItem.dp,
            sellItem.dt,
            Colors.red.shade50,
            Colors.red.shade700,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildPriceBox(
            'خرید بازار',
            buyItem.p,
            buyItem.dp,
            buyItem.dt,
            Colors.green.shade50,
            Colors.green.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBox(
    String title,
    String price,
    double dp,
    ChangeDirection dt,
    Color bgColor,
    Color textColor,
  ) {
    bool isPositive = dt == ChangeDirection.high;
    String changePercent = _toPersianDigits('$dp%');
    if (isPositive) changePercent = '+$changePercent';
    if (dt == ChangeDirection.low) changePercent = '-$changePercent';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bgColor, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 14,
              color: textColor.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatPrice(price),
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            changePercent,
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 12,
              color: isPositive
                  ? const Color.fromARGB(255, 0, 112, 75)
                  : const Color(0xFFEF4444),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(dynamic item, ToleranceItem? lastItem) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'جزئیات روزانه',
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow('بالاترین قیمت امروز', item.h),
          const Divider(height: 24),
          _buildDetailRow('پایین‌ترین قیمت امروز', item.l),
          const Divider(height: 24),
          if (lastItem != null && lastItem.o.isNotEmpty) ...[
            _buildDetailRow('قیمت بازگشایی', lastItem.o),
            const Divider(height: 24),
          ],
          _buildDetailRow('میزان تغییر روزانه', item.d, isChange: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isChange = false}) {
    String formattedValue = _formatPrice(value);
    Color valueColor = const Color(0xFF1F2937);

    if (isChange) {
      // If it's a change value, we might want to color it based on sign if available
      // But 'd' is absolute change usually. Let's just keep it neutral or use standard formatting.
      // Usually 'd' doesn't have +/- signs in the raw string for some APIs, but let's just format it.
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formattedValue,
          style: TextStyle(
            fontFamily: 'Vazir',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Vazir',
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  String _formatPrice(String price) {
    if (isRial) {
      String rawPrice = price.replaceAll(',', '');
      if (rawPrice.isEmpty) return price;
      try {
        double priceVal = double.parse(rawPrice);
        double tomanVal = priceVal / 10;
        final formatter = NumberFormat('#,###');
        return _toPersianDigits(formatter.format(tomanVal));
      } catch (_) {
        return _toPersianDigits(price);
      }
    } else {
      return _toPersianDigits(price);
    }
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
