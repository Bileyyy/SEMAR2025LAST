import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg/lawang1000.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay Transparan
          Container(
            width: double.infinity,
            color: Colors.white.withOpacity(0.8),
          ),

          // Konten Dashboard
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        onPressed: () {},
                      ),
                      Text(
                        "Dashboard",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[300],
                        child: Text("AS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                // Card Container (DIPERPANJANG)
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.72, 
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Baris pertama: Tambah Informasi & Keluar (di kanan)
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _actionButton("Tambah\nInformasi", Colors.green, Icons.add, () {}, 80),
                                  _actionButton("Edit Profil", Colors.amber, Icons.edit, () {}, 80),
                                ],
                              ),
                            ),
                            Expanded(child: _actionButton("Keluar", Colors.red, Icons.exit_to_app, () {}, 170)), // Ukuran lebih panjang
                          ],
                        ),
                        SizedBox(height: 10), // Pisahkan margin dengan tombol kategori
                        // Button Kategori
                        Wrap(
                          spacing: 4,
                          runSpacing: -3, // Perkecil jarak vertikal
                          children: [
                            _categoryButton("Kuliner"),
                            _categoryButton("Destinasi"),
                            _categoryButton("Tempat Bersejarah"),
                            _categoryButton("Call Center"),
                            _categoryButton("Layanan Publik"),
                          ],
                        ),
                        SizedBox(height: 10), // Kurangi jarak di bawah
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Tombol Aksi
  Widget _actionButton(String text, Color color, IconData icon, VoidCallback onTap, double height) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(vertical: 2), // Rekatkan tombol satu sama lain
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(height: 5),
            Text(text, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }

  // Widget Button Kategori
  Widget _categoryButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.black)),
      ),
      onPressed: () {},
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.black)),
    );
  }
}
