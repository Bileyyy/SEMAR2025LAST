import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailInformasi extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const DetailInformasi({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  void showPopup(BuildContext context, String title, String content, IconData icon) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Info',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.all(24),
              titlePadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              title: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
                    child: Icon(icon, color: Theme.of(context).primaryColor, size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              content: Text(
                content,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Tutup'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildIconButton(
    BuildContext context,
    IconData icon,
    String label,
    String popupTitle,
    String popupContent,
  ) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(60),
          onTap: () => showPopup(context, popupTitle, popupContent, icon),
          splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
          child: Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10), // Reduced from 12
            child: FaIcon(icon, color: Theme.of(context).primaryColor, size: 18), // Reduced from 20
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label, 
          style: const TextStyle(fontSize: 11), // Reduced from 12
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg/lawang1000.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: screenHeight,
            color: const Color(0xFFFFF2DA).withOpacity(0.6),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 2)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        image,
                        width: 340,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 340,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 340,
                      padding: const EdgeInsets.symmetric(vertical: 8), // Reduced vertical padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          const Text(
                            'Informasi Lanjutan',
                            style: TextStyle(
                              fontSize: 14, // Reduced from 15
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8), // Reduced from 12
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildIconButton(
                                context,
                                FontAwesomeIcons.moneyBill,
                                'Harga Tiket',
                                'Informasi Harga',
                                'Dewasa: Rp20.000\nAnak: Rp10.000\nParkir: Rp5.000',
                              ),
                              buildIconButton(
                                context,
                                FontAwesomeIcons.clock,
                                'Jam Buka',
                                'Jam Operasional',
                                'Senin-Jumat: 08.00-17.00\nSabtu-Minggu: 07.00-18.00',
                              ),
                              buildIconButton(
                                context,
                                FontAwesomeIcons.locationDot,
                                'Lokasi',
                                'Lokasi Tempat',
                                'Jl. Pandanaran II',
                              ),
                            ],
                          ),
                          const SizedBox(height: 4), // Reduced from 8
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}