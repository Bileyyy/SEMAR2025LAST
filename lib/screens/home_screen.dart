import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:semar/screens/kuliner_screen.dart';
import 'package:semar/screens/layanan_screnn.dart';
import 'package:semar/screens/sejarah_screen.dart';
import 'package:semar/screens/bencana_cuaca_screen.dart';
import 'package:semar/screens/destinasi_screen.dart';
import 'package:semar/screens/callcenter_screen.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NearbyPlace> nearbyPlaces = [];
  List<NearbyPlace> allPlaces = [];
  bool _isLoading = false;
  Position? _currentPosition;
  bool _locationError = false;

  List<NewsEvent> newsEvents = [
    NewsEvent(
      title: "Semarang Night Carnival 2025",
      imagePath: "assets/bg/snc.jpg",
      date: "4 Mei 2025",
      location: "Titik 0KM - Balaikota",
      description: "Semarang Night Carnival (SNC) adalah karnaval malam tahunan untuk merayakan HUT Kota Semarang, menampilkan parade kostum, seni budaya, dan hiburan, serta bertujuan mempromosikan budaya dan pariwisata.",
    ),
    NewsEvent(
      title: "Dugderan",
      imagePath: "assets/bg/dugderan.jpeg",
      date: "28 Februari 2025",
      location: "Jl. Pemuda",
      description: "Dugderan adalah tradisi tahunan di Semarang untuk menyambut bulan Ramadan. Perayaan ini diisi dengan pawai budaya, beduk raksasa, kembang api, dan Pasar Rakyat yang menjajakan wahana, kuliner, pakaian, serta mainan tradisional.",
    )
  ];

  @override
  void initState() {
    super.initState();
    _initializePlaces();
    _getCurrentLocation();
  }

  void _initializePlaces() {
    allPlaces = [
      NearbyPlace(
        name: "Lawang Sewu",
        imagePath: "assets/bg/lawang1000.png",
        rating: 4.7,
        latitude: -6.983333,
        longitude: 110.409722,
      ),
      NearbyPlace(
        name: "Kota Lama",
        imagePath: "assets/bg/kotlam.png",
        rating: 4.5,
        latitude: -6.9675,
        longitude: 110.4256,
      ),
      NearbyPlace(
        name: "Museum Ronggowarsito",
        imagePath: "assets/bg/muser.png",
        rating: 4.3,
        latitude: -7.0056,
        longitude: 110.4389,
      ),
      NearbyPlace(
        name: "Sam Poo Kong",
        imagePath: "assets/bg/sampo.png",
        rating: 4.6,
        latitude: -7.0139,
        longitude: 110.4414,
      ),
      NearbyPlace(
        name: "Pagoda Avalokitesvara",
        imagePath: "assets/bg/pagoda.png",
        rating: 4.4,
        latitude: -7.0865,
        longitude: 110.4183,
      ),
      NearbyPlace(
        name: "Tugu Muda",
        imagePath: "assets/bg/tugmud.jpg",
        rating: 4.2,
        latitude: -6.9825,
        longitude: 110.4086,
      ),
      NearbyPlace(
        name: "Masjid Agung Jawa Tengah",
        imagePath: "assets/bg/majt.png",
        rating: 4.8,
        latitude: -7.0058,
        longitude: 110.4411,
      ),
      NearbyPlace(
        name: "Kampung Pelangi",
        imagePath: "assets/bg/kpelangi.jpg",
        rating: 4.1,
        latitude: -6.9892,
        longitude: 110.4228,
      ),
    ];
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _locationError = false;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Layanan lokasi tidak aktif');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Izin lokasi ditolak');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Izin lokasi ditolak permanen');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _currentPosition = position;
      });

      _refreshRecommendations();
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _locationError = true;
        nearbyPlaces = allPlaces.take(3).map((place) => place.copyWith(distance: null)).toList();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double _calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    const double earthRadius = 6371;
    double dLat = _toRadians(endLat - startLat);
    double dLng = _toRadians(endLng - startLng);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(startLat)) * cos(_toRadians(endLat)) *
        sin(dLng / 2) * sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * pi / 180;

  void _refreshRecommendations() {
    if (_currentPosition == null) return;

    setState(() => _isLoading = true);

    List<NearbyPlace> sortedPlaces = allPlaces.map((place) {
      double distance = _calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        place.latitude,
        place.longitude,
      );
      return place.copyWith(distance: distance);
    }).toList()
      ..sort((a, b) => a.distance!.compareTo(b.distance!));

    setState(() {
      nearbyPlaces = sortedPlaces.take(3).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double navbarHeight = 80;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background layers
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

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: navbarHeight + 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    _buildHeaderSection(),
                    
                    // Menu grid
                    _buildMenuGrid(context),
                    
                    // Gallery section
                    _buildGallerySection(),
                    
                    // Recommended places
                    _buildRecommendedPlaces(),
                    
                    // News & Events
                    _buildNewsEventsSection(),
                  ],
                ),
              ),
            ),
          ),

          // Semar AI Chat Bubble
          Positioned(
            bottom: 80,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => SemarAIChat(),
                );
              },
              backgroundColor: Color(0xFF275E76),
              child: Icon(Icons.chat_bubble_outline, color: Colors.white),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            "SEMAR",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Color(0xFF275E76),
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(0, -12),
            child: Text(
              "Seputar Semarang",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0xFF275E76),
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Center(
      child: Container(
        width: 340,
        height: 220,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildMenuButton(context, "Destinasi", Icons.map, DestinasiScreen()),
            _buildMenuButton(context, "Tempat Bersejarah", Icons.map_outlined, SejarahScreen()),
            _buildMenuButton(context, "Bencana & Cuaca", Icons.cloud, BencanaCuacaScreen()),
            _buildMenuButton(context, "Kuliner", Icons.restaurant, KulinerScreen()),
            _buildMenuButton(context, "Layanan Publik", Icons.help_outline, LayananScreen()),
            _buildMenuButton(context, "Call Center", Icons.phone, CallCenterScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF7EB7D9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF275E76),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 16),
          child: Text(
            "Galeri",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF275E76),
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildGalleryImage("assets/bg/lawubaru.jpg"),
                _buildGalleryImage("assets/bg/kotlam.png"),
                _buildGalleryImage("assets/bg/kariadi.png"),
                _buildGalleryImage("assets/bg/museum.png"),
                _buildGalleryImage("assets/bg/sampo.png"),
                _buildGalleryImage("assets/bg/wbabat.png"),
                _buildGalleryImage("assets/bg/lumpia.png"),
                _buildGalleryImage("assets/bg/majt.png"),
                _buildGalleryImage("assets/bg/snc.jpg"),
                _buildGalleryImage("assets/bg/dugderan.jpeg"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryImage(String assetPath) {
    return Container(
      width: 130,
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildRecommendedPlaces() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        width: 340,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rekomendasi Wisata",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF275E76),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Color(0xFF275E76)),
                  onPressed: _getCurrentLocation,
                ),
              ],
            ),
            if (_locationError)
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "Tidak dapat mengakses lokasi. Menampilkan rekomendasi umum",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),
            SizedBox(height: 12),
            if (_isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Column(
                children: nearbyPlaces.map((place) => _buildPlaceItem(place)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceItem(NearbyPlace place) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                place.imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF275E76),
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        place.rating.toString(),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.location_on, size: 16, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        place.distance != null 
                          ? "${place.distance!.toStringAsFixed(1)} km" 
                          : "-",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF7EB7D9).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Lihat Detail",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Color(0xFF275E76),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildNewsEventsSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Container(
      width: 340,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Acara",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF275E76),
            ),
          ),
          SizedBox(height: 12),
          Column(
            children: newsEvents
                .map((event) => _buildNewsEventCard(context, event))
                .toList(),
          ),
        ],
      ),
    ),
  );
}


Widget _buildNewsEventCard(BuildContext context, NewsEvent event) {
  return InkWell(
    onTap: () => _showNewsDetail(context, event),
    child: Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              event.imagePath,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF275E76),
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      event.date,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      event.location,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


void _showNewsDetail(BuildContext context, NewsEvent event) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                event.imagePath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              event.title,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF275E76)),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  event.date,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey[600]),
                ),
                SizedBox(width: 16),
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  event.location,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Deskripsi",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF275E76)),
            ),
            SizedBox(height: 8),
            Text(
              event.description,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF275E76),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Tutup",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class NearbyPlace {
  final String name;
  final String imagePath;
  final double rating;
  final double latitude;
  final double longitude;
  final double? distance;

  NearbyPlace({
    required this.name,
    required this.imagePath,
    required this.rating,
    required this.latitude,
    required this.longitude,
    this.distance,
  });

  NearbyPlace copyWith({double? distance}) => NearbyPlace(
    name: name,
    imagePath: imagePath,
    rating: rating,
    latitude: latitude,
    longitude: longitude,
    distance: distance ?? this.distance,
  );
}

class NewsEvent {
  final String title;
  final String imagePath;
  final String date;
  final String location;
  final String description;

  NewsEvent({
    required this.title,
    required this.imagePath,
    required this.date,
    required this.location,
    required this.description,
  });
}

class SemarAIChat extends StatefulWidget {
  @override
  _SemarAIChatState createState() => _SemarAIChatState();
}

class _SemarAIChatState extends State<SemarAIChat> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  static const String _apiKey = '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';

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: "Halo! Saya Semar AI, asisten virtual untuk informasi tentang kota Semarang. Ada yang bisa saya bantu?",
      isUser: false,
    ));
  }

  Future<void> sendToOpenRouter(String question) async {
    setState(() {
      _isLoading = true;
      _messages.add(ChatMessage(text: question, isUser: true));
      _messages.add(ChatMessage(text: '', isUser: false, isLoading: true));
      _scrollToBottom();
    });

    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_apiKey",
      "HTTP-Referer": "https://yourapp.example.com",
      "X-Title": "SemarAI Chat",
    };

    final body = jsonEncode({
      "model": "openai/gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": "Kamu adalah asisten ramah yang memberikan informasi tentang kota Semarang."},
        {"role": "user", "content": question}
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reply = data['choices'][0]['message']['content'];

        setState(() {
          _messages.removeLast();
          _messages.add(ChatMessage(text: reply.trim(), isUser: false));
          _isLoading = false;
          _scrollToBottom();
        });
      } else {
        throw Exception('Gagal: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(text: "Terjadi kesalahan: ${e.toString()}", isUser: false));
        _isLoading = false;
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF275E76),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.chat, color: Color(0xFF275E76)),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Semar AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    if (message.isLoading) return _buildLoadingIndicator();
                    return _buildMessageBubble(message);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _controller,
                          onTap: _scrollToBottom, // Tambahkan ini agar scroll otomatis saat input diklik
                          onSubmitted: (value) {
                            final text = value.trim();
                            if (text.isNotEmpty && !_isLoading) {
                              sendToOpenRouter(text);
                              _controller.clear();
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Tanyakan tentang Semarang...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(24),
                      color: Color(0xFF275E76),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: _isLoading
                            ? null
                            : () {
                                final text = _controller.text.trim();
                                if (text.isNotEmpty) {
                                  sendToOpenRouter(text);
                                  _controller.clear();
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFF275E76).withOpacity(0.1),
            child: Icon(Icons.chat, color: Color(0xFF275E76), size: 20),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF275E76).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Semar AI sedang mengetik...'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            CircleAvatar(
              backgroundColor: Color(0xFF275E76).withOpacity(0.1),
              child: Icon(Icons.chat, color: Color(0xFF275E76), size: 20),
            ),
          if (!message.isUser) SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Color(0xFF275E76)
                    : Color(0xFF275E76).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (message.isUser) SizedBox(width: 8),
          if (message.isUser)
            CircleAvatar(
              backgroundColor: Color(0xFF275E76).withOpacity(0.1),
              child: Icon(Icons.person, color: Color(0xFF275E76)),
            ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;

  ChatMessage({
    required this.text,
    this.isUser = false,
    this.isLoading = false,
  });
}