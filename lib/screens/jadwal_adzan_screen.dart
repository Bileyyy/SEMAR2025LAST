import 'package:flutter/material.dart';
import 'package:semar/widgets/custom_navbar.dart';
import 'package:semar/widgets/navbar.dart';

class JadwalAdzanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg/lawang1000.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay warna
          Container(
            width: double.infinity,
            height: screenHeight,
            color: Color(0xFFFFF2DA).withOpacity(0.6),
          ),

          // Konten halaman
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Jadwal Adzan Semarang',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildPrayerTimeRow('Subuh', '04:30'),
                            Divider(),
                            _buildPrayerTimeRow('Dzuhur', '12:00'),
                            Divider(),
                            _buildPrayerTimeRow('Ashar', '15:15'),
                            Divider(),
                            _buildPrayerTimeRow('Maghrib', '18:00'),
                            Divider(),
                            _buildPrayerTimeRow('Isya', '19:30'),
                            SizedBox(height: 20),
                            Text(
                              'Waktu Sholat untuk wilayah Semarang dan sekitarnya',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: -1,
        onItemTapped: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Navbar(selectedIndex: index)),
          );
        },
      ),
    );
  }

  Widget _buildPrayerTimeRow(String prayerName, String prayerTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prayerName,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF275E76),
            ),
          ),
          Text(
            prayerTime,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF275E76),
            ),
          ),
        ],
      ),
    );
  }
}