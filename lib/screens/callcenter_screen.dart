import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semar/widgets/custom_navbar.dart';
import 'package:semar/widgets/navbar.dart';

class CallCenterScreen extends StatefulWidget {
  const CallCenterScreen({super.key});

  @override
  State<CallCenterScreen> createState() => _CallCenterScreenState();
}

class _CallCenterScreenState extends State<CallCenterScreen> {
  final List<Map<String, String>> _callCenterList = [
    {
      "title": "Pemadam Kebakaran",
      "subtitle": "113",
      "image": "assets/bg/damkar.png"
    },
    {
      "title": "Polisi",
      "subtitle": "110",
      "image": "assets/bg/polisije.jpg"
    },
    {
      "title": "Ambulance Kecelakaan",
      "subtitle": "8313416",
      "image": "assets/bg/ambulance.png"
    },
    {
      "title": "Palang Merah Indonesia",
      "subtitle": "118",
      "image": "assets/bg/pmise.jpg"
    },
    {
      "title": "Tim Sar Semarang",
      "subtitle": "8315514",
      "image": "assets/bg/sar.png"
    },
  ];

  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nomor "$text" berhasil disalin'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final filteredList = _callCenterList.where((item) {
      final query = _searchQuery.toLowerCase();
      return item['title']!.toLowerCase().contains(query) ||
          item['subtitle']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg/lawang1000.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: screenHeight,
            color: const Color(0xFFFFF2DA).withOpacity(0.6),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Cari di sini",
                        hintStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: InputBorder.none,
                        icon: const Icon(Icons.search, color: Color(0xFF275E76)),
                        
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      "Call Center",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black54,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: filteredList.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              return callItem(
                                context,
                                imagePath: item['image']!,
                                title: item['title']!,
                                subtitle: item['subtitle']!,
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              "Tidak ada data ditemukan.",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
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
              builder: (context) => Navbar(selectedIndex: index),
            ),
          );
        },
      ),
    );
  }

  Widget callItem(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onLongPress: () => copyToClipboard(context, subtitle),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          subtitle,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                        ),
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