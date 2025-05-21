import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                // Stack untuk lingkaran profil dan tombol edit
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50, // Ukuran lingkaran profil
                      backgroundImage: AssetImage("assets/profile_picture.png"),
                    ),

                    // Tombol edit profil di kanan bawah lingkaran
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Color(0xFF275E76), size: 20),
                          onPressed: () {
                            // Aksi edit profil
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Text(
                  "Nama Pengguna",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF275E76),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "user@example.com",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF275E76),
                  ),
                ),
                SizedBox(height: 20),

                // Container putih untuk menu lainnya
                Center(
                  child: Container(
                    width: screenWidth * 0.75, // Lebih kecil agar proporsional
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.lock, color: Color(0xFF275E76), size: 20),
                          title: Text(
                            "Ubah Password",
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                          ),
                          onTap: () {},
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.logout, color: Colors.redAccent, size: 20),
                          title: Text(
                            "Keluar",
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.redAccent),
                          ),
                          onTap: () {},
                        ),
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
}
