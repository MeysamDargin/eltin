import 'package:eltin_gold/screen/Consultation/consultation_screen.dart';
import 'package:eltin_gold/screen/Exchange/exchange_screen.dart';
import 'package:eltin_gold/screen/Home/home.dart';
import 'package:eltin_gold/screen/Markets/markets_screen.dart';
import 'package:eltin_gold/screen/Menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 4; // Default to Home

  final List<Widget> _pages = [
    const MenuScreen(),
    const ConsultationScreen(),
    const ExchangeScreen(),
    const MarketsScreen(),
    const Home(),
  ];

  @override
  void initState() {
    super.initState();
    // تضمین اینکه در صفحه اصلی، دکمه‌های سیستم سفید با آیکون سیاه باشن
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: _pages.length > _selectedIndex
          ? _pages[_selectedIndex]
          : const Home(),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          if (index == 2) return; // FAB
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: CustomFloatingActionButton(
        onTap: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// CustomBottomNavBar و CustomFloatingActionButton دقیقاً همون کد قبلی‌ت هستن – بدون تغییر لازم
// فقط کپی کردم تا کامل باشه

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem('assets/icons/menu-svgrepo-com.png', 'منو', 0),
              _buildNavItem(
                'assets/icons/user-speak-rounded-svgrepo-com.png',
                'مشاوره',
                1,
              ),
              Container(
                width: 60,
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 6, right: 8),
                child: const Text(
                  'مبادله',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 13,
                    color: Color.fromARGB(255, 51, 75, 70),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildNavItem(
                'assets/icons/bar-chart-alt-svgrepo-com.png',
                'بازارها',
                3,
              ),
              _buildNavItem('assets/icons/home.png', 'خانه', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            color: isSelected
                ? const Color.fromARGB(255, 69, 98, 101)
                : const Color.fromARGB(255, 151, 164, 162),
            width: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 13,
              color: isSelected
                  ? const Color.fromARGB(255, 57, 80, 83)
                  : const Color.fromARGB(255, 151, 164, 162),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onTap;

  const CustomFloatingActionButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 23, 43, 45),
            Color.fromARGB(255, 82, 110, 114),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1a3235).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: Image.asset(
              'assets/icons/Background (15).png',
              color: Colors.white,
              width: 23,
            ),
          ),
        ),
      ),
    );
  }
}
