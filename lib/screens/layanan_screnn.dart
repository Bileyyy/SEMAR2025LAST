import 'package:flutter/material.dart';
import 'package:semar/widgets/custom_navbar.dart';
import 'package:semar/widgets/navbar.dart';

class LayananScreen extends StatelessWidget {
  final List<Map<String, String>> layanan = [
    {
      "nama": "Museum",
      "gambar": "assets/bg/museum.png",
    },
    {
      "nama": "Rumah Sakit",
      "gambar": "assets/bg/rusa.png",
    },
    {
      "nama": "Tempat Kebugaran",
      "gambar": "assets/bg/kebugaran.png",
    },
    {
      "nama": "Pemerintahan",
      "gambar": "assets/bg/pemerintah.png",
    },
    {
      "nama": "Tempat Penginapan",
      "gambar": "assets/bg/tepengi.png",
    },
  ];
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
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Cari di sini",
                        hintStyle: TextStyle(fontFamily: 'Poppins'),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Color(0xFF275E76)),
                      ),
                    ),
                  ),

                  Text(
                    "Layanan Publik",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
              child: ListView.builder(
                itemCount: layanan.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          layanan[index]["gambar"]!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        layanan[index]["nama"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                      )
                    )
                      );
                }
              )
                  )
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
            MaterialPageRoute(builder: (context) => Navbar(selectedIndex: index)),
          );
        },
      ),
    );
  }


  Widget buildLayananItem(String title, String? imagePath) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath, width: 40, height: 40, fit: BoxFit.cover),
            ),
          if (imagePath != null) SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
