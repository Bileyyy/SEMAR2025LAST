import 'package:flutter/material.dart';
import 'package:semar/widgets/custom_navbar.dart';
import 'package:semar/screens/detail_event.dart';
// Import HomeScreen, sesuaikan pathnya
import 'package:semar/screens/home_screen.dart';

class EventsScreen extends StatelessWidget {
  final List<Map<String, String>> events = [
    {
      "title": "Semarang Night Carnival",
      "description": "Semarang (ANTARA) - Pergelaran seni budaya Semarang Night Carnival (SNC) 2025 berlangsung meriah dengan didatangi ribuan penonton yang memadati sepanjang rute karnaval di Jalan Pemuda Kota Semarang, Jawa Tengah, Minggu malam.\n\n"
          "Persis di depan Balai Kota Semarang, warga yang menonton SNC berjubel sampai tengah jalan hingga menutupi rute karnaval. Arak-arakan SNC 2025 dimulai dari Titik Nol Kota Semarang, diawali oleh barisan drum band dari Akademi Kepolisian (Akpol) yang memimpin barisan.\n\n"
          "Selanjutnya, defile tamu dari pemerintah daerah sekitar, seperti Kabupaten Grobogan, Kota Salatiga, diikuti barisan Perisai Nusantara yang menampilkan parade penjor. Berbagai kostum megah dan ikonik dengan warna-warni ditampilkan para peserta SNC 2025 semakin menyemarakkan karnaval yang menjadi agenda wisata tahunan Kota Semarang itu.\n\n"
          "Kepala Dinas Kebudayaan dan Pariwisata Kota Semarang, Wing Wiyarso, menjelaskan SNC 2025 yang merupakan agenda ke-13 itu mengangkat tema \"Perisai Nusantara\" dengan filosofi melindungi nusantara dari intervensi budaya-budaya asing yang masuk. Tema tersebut memiliki empat subtema, di antaranya bunga anggrek, burung cenderawasih, burung merak, dan penjor yang sering digunakan dalam prosesi adat dan kesenian.\n\n"
          "Wali Kota Semarang Agustina Wilujeng Pramestuti berterima kasih kepada seluruh peserta dan masyarakat yang telah menyemarakkan pergelaran SNC 2025. Meskipun ada beberapa kontingen membatalkan keikutsertaan karena efisiensi anggaran, acara tetap berlangsung meriah. Bahkan, ada penonton yang pingsan akibat berdesak-desakan. Ketika hujan deras turun, sebagian penonton menepi berteduh namun parade tetap berjalan.",
      "image": "assets/bg/snc.jpg",
      "date": "15 Juni 2025"
    },
    {
      "title": "Pawai Ogoh-Ogoh",
      "description": "Tradisi budaya Bali yang diadakan menjelang Hari Nyepi. Arak-arakan Ogoh-Ogoh menyusuri jalan utama kota.",
      "image": "assets/bg/ogoh.jpg",
      "date": "8 Maret 2025"
    },
    {
      "title": "Wayang on the Street",
      "description": "Pertunjukan seni tradisional wayang yang diadakan di ruang terbuka, menampilkan dalang terkenal dan edukasi budaya.",
      "image": "assets/bg/wayang.jpg",
      "date": "20 April 2025"
    },
    {
      "title": "Dugderan",
      "description": "Festival rakyat menyambut bulan Ramadan dengan parade budaya, bazar, dan pertunjukan seni lokal.",
      "image": "assets/bg/dugderan.jpeg",
      "date": "5 Maret 2025"
    },
    {
      "title": "Pasar Imlek Semawis",
      "description": "Pasar malam tahunan menyambut Tahun Baru Imlek di kawasan Pecinan, menghadirkan kuliner khas dan pertunjukan barongsai.",
      "image": "assets/bg/semawis.jpg",
      "date": "30 Januari 2025"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg/lawang1000.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Color overlay
          Container(
            color: Color(0xFFFFF2DA).withOpacity(0.6),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {
                        // Kembali ke HomeScreen menggantikan EventsScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      },
                      child: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    ),
                  ),

                  // Title "Events"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Events",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // List event
                  Center(
                    child: Container(
                      width: 360,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: events.map((event) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailEvent(
                                        title: event['title']!,
                                        imagePath: event['image']!,
                                        description: event['description']!,
                                        date: event['date']!,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        event['image']!,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event['title']!,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            event['description']!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.grey.shade300, height: 24),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: -1,
        onItemTapped: (index) {},
      ),
    );
  }
}
