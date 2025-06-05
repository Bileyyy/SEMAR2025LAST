import 'package:flutter/material.dart';
import 'package:semar/widgets/custom_navbar.dart';
import 'package:semar/widgets/navbar.dart';

class LayananScreen extends StatefulWidget {
  @override
  _LayananScreenState createState() => _LayananScreenState();
}

class _LayananScreenState extends State<LayananScreen> {
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

  List<Map<String, String>> filteredLayanan = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredLayanan = List.from(layanan);
  }

  void filterLayanan(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        filteredLayanan = List.from(layanan);
      } else {
        filteredLayanan = layanan
            .where((item) =>
                item["nama"]!.toLowerCase().contains(searchQuery))
            .toList();
      }
    });
  }

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
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
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
                      onChanged: filterLayanan,
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
                    child: filteredLayanan.isEmpty
                      ? Center(
                          child: Text(
                            "Tidak ada data",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredLayanan.length,
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
                                    filteredLayanan[index]["gambar"]!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  filteredLayanan[index]["nama"]!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins'
                                  ),
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
}