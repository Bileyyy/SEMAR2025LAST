import 'package:flutter/material.dart';
import 'package:semar/widgets/custom_navbar.dart';
import 'package:semar/widgets/navbar.dart';
import 'detail_informasi.dart';

class KulinerScreen extends StatefulWidget {
  @override
  _KulinerScreenState createState() => _KulinerScreenState();
}

class _KulinerScreenState extends State<KulinerScreen> {
  final List<Map<String, String>> kulinerList = [
    {
      "title": "Lumpia Semarang",
      "image": "assets/bg/lump.png",
      "description": "Kuliner khas Semarang berupa rollade goreng berisi rebung dan daging."
    },
    {
      "title": "Wingko Babat",
      "image": "assets/bg/wibat.png",
      "description": "Kue tradisional berbahan dasar tepung ketan dan kelapa."
    },
    {
      "title": "Tahu Gimbal",
      "image": "assets/bg/tagimbal.png",
      "description": "Tahu goreng disajikan dengan udang goreng dan saus kacang."
    },
    {
      "title": "Wedang Tahu",
      "image": "assets/bg/wedahu.png",
      "description": "Minuman hangat dari sari kacang hijau dengan jahe dan gula merah."
    },
    {
      "title": "Es Gempol",
      "image": "assets/bg/esgem.png",
      "description": "Es campur dengan bola-bola tepung kenyal dan sirup gula merah."
    },
    {
      "title": "Bandung Presto",
      "image": "assets/bg/bapres.png",
      "description": "Daging bandung dimasak presto hingga empuk dengan bumbu rempah."
    },
    {
      "title": "Mie Kopyok",
      "image": "assets/bg/mikopyok.png",
      "description": "Mie kering disajikan dengan tauge dan kuah kental khas Semarang."
    },
  ];

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, String>> filteredList = kulinerList
        .where((kuliner) => kuliner['title']!
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
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
          Container(
            width: double.infinity,
            height: screenHeight,
            color: Color(0xFFFFF2DA).withOpacity(0.6),
          ),
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
                      onChanged: (value) => setState(() => searchText = value),
                      decoration: InputDecoration(
                        hintText: "Cari di sini",
                        hintStyle: TextStyle(fontFamily: 'Poppins'),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Color(0xFF275E76)),
                      ),
                    ),
                  ),
                  Text(
                    "Kuliner",
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
                  SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      itemCount: filteredList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        return _buildKulinerItem(
                          filteredList[index]['title']!,
                          filteredList[index]['image']!,
                          filteredList[index]['description']!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(selectedIndex: -1, onItemTapped: (index) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Navbar(selectedIndex: index)),
        );
      }),
    );
  }

  Widget _buildKulinerItem(String title, String imagePath, String description) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailInformasi(
              title: title,
              description: description,
              image: imagePath,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}