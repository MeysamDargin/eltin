import 'dart:async';
import 'package:flutter/material.dart';
import '../models/tgju_model.dart';
import '../services/get_pricing_service.dart';

class PriceProvider extends ChangeNotifier {
  TgjuResponse? _prices;
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _timer;

  TgjuResponse? get prices => _prices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// دریافت قیمت‌ها از سرویس
  Future<void> fetchPrices({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners(); // اطلاع به UI که در حال بارگذاری هستیم
    }

    try {
      _prices = await TgjuService.fetchPrices();
    } catch (e) {
      print("خطا در پروایدر: $e");
      if (!silent) {
        _errorMessage = e.toString();
      }
    } finally {
      if (!silent) {
        _isLoading = false;
      }
      notifyListeners(); // اطلاع به UI که عملیات تمام شده
    }

    // شروع تایمر اگر هنوز شروع نشده است
    if (_timer == null) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchPrices(silent: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
