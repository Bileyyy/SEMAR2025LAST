import 'package:flutter/material.dart';
import 'package:semar/widgets/custom_navbar.dart';
import 'package:semar/widgets/navbar.dart';

class LayananScreen extends StatelessWidget {
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
                  // Tombol kembali
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),

                  // Search Bar
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

                  // Judul kategori
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
  child: Column(
    children: [
      buildLayananItem("Museum", null),
      buildLayananItem("Rumah Sakit", null),
      buildLayananItem("Tempat Kebugaran", null),
      buildLayananItem("Pemerintahan", null),
      buildLayananItem("Tempat Penginapan", null),
    ],
  ),
),


                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.all(25),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(20),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.1),
                  //         blurRadius: 10,
                  //         spreadRadius: 2,
                  //         offset: Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       SizedBox(width: 150),
                  //       Text(
                  //     "Museum",
                  //     style: TextStyle(
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16,
                  //       color: Colors.black
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 15),

                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.all(25),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(20),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.1),
                  //         blurRadius: 10,
                  //         spreadRadius: 2,
                  //         offset: Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       SizedBox(width: 150),
                  //       Text(
                  //     "Rumah Sakit",
                  //     style: TextStyle(
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16,
                  //       color: Colors.black
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 15),

                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.all(25),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(20),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.1),
                  //         blurRadius: 10,
                  //         spreadRadius: 2,
                  //         offset: Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       SizedBox(width: 150),
                  //       Text(
                  //     "Tempat Kebugaran",
                  //     style: TextStyle(
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16,
                  //       color: Colors.black
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 15),

                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.all(25),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(20),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.1),
                  //         blurRadius: 10,
                  //         spreadRadius: 2,
                  //         offset: Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       SizedBox(width: 150),
                  //       Text(
                  //     "Pemerintahan",
                  //     style: TextStyle(
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16,
                  //       color: Colors.black
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 15),

                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.all(25),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(20),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.1),
                  //         blurRadius: 10,
                  //         spreadRadius: 2,
                  //         offset: Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       SizedBox(width: 150),
                  //       Text(
                  //     "Tempat Penginapan",
                  //     style: TextStyle(
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 14,
                  //       color: Colors.black
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 15),

                  // Grid destinasi
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: -1, // ✅ Tidak ada opsi navbar yang dipilih
        onItemTapped: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Navbar(selectedIndex: index)),
          );
        },
      ),
    );
  }

  // Widget untuk item destinasi
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
