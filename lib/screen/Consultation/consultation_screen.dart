import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsultationScreen extends StatelessWidget {
  const ConsultationScreen({super.key});

  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/989028485858');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _makePhoneCall() async {
    final Uri url = Uri.parse('tel:+989122962306');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'مشاوره و سرمایه‌گذاری',
          style: TextStyle(
            fontFamily: 'Vazir',
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1a3235), Color(0xFF2E5358)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1a3235).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/support-svgrepo-com.png',
                            width: 64,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'تیم مشاوره التین گلد',
                            style: TextStyle(
                              fontFamily: 'Vazir',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Description Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'چرا مشاوره با ما؟',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'تیم متخصص التین گلد با سال‌ها تجربه در بازارهای مالی، طلا و ارز، آماده ارائه بهترین راهکارهای سرمایه‌گذاری متناسب با سرمایه و اهداف مالی شماست. ما در کنار شما هستیم تا با اطمینان خاطر، دارایی خود را حفظ و رشد دهید.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 15,
                        height: 1.8,
                        color: Colors.grey[600],
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Contact Options
              const Text(
                'راه‌های ارتباطی',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),

              // Phone Button
              _buildContactButton(
                icon: 'assets/icons/call-192-svgrepo-com.png',
                title: 'تماس تلفنی',
                subtitle: '۰۹۱۲۲۹۶۲۳۰۶',
                color: const Color(0xFF1F2937),
                onTap: _makePhoneCall,
              ),

              const SizedBox(height: 16),

              // WhatsApp Button
              _buildContactButton(
                icon: 'assets/icons/whatsapp-svgrepo-com.png',
                title: 'گفتگو در واتساپ',
                subtitle: 'پاسخگویی سریع و آنلاین',
                color: const Color(0xFF25D366),
                onTap: _launchWhatsApp,
                isWhatsApp: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isWhatsApp = false,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(icon, color: color, width: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[300],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
