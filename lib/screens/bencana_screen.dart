import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

class BencanaScreen extends StatefulWidget {
  @override
  _BencanaScreenState createState() => _BencanaScreenState();
}

class _BencanaScreenState extends State<BencanaScreen> {
  List<Earthquake> earthquakes = [];
  bool isLoading = true;
  final MapController mapController = MapController();
  final LatLng semarangCenter = LatLng(-6.9667, 110.4167); // Koordinat Semarang

  @override
  void initState() {
    super.initState();
    fetchEarthquakeData();
  }

  Future<void> fetchEarthquakeData() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Earthquake> loadedEarthquakes = [];

        var gempaList = data['Infogempa']['gempa'] as List;
        for (var quake in gempaList) {
          loadedEarthquakes.add(Earthquake(
            magnitude: double.parse(quake['Magnitude']),
            location: quake['Wilayah'],
            time: DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse('${quake['Tanggal']} ${quake['Jam']}'),
            depth: double.parse(quake['Kedalaman'].split(' ')[0]),
            latitude: _parseCoordinate(quake['Lintang']),
            longitude: _parseCoordinate(quake['Bujur']),
          ));
        }

        setState(() {
          earthquakes = loadedEarthquakes;
          isLoading = false;
          if (earthquakes.isNotEmpty) {
            mapController.move(
              LatLng(earthquakes.first.latitude, earthquakes.first.longitude),
              9.0,
            );
          }
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
      );
    }
  }

  double _parseCoordinate(String coord) {
    var parts = coord.split(' ');
    double value = double.parse(parts[0]);
    if (parts[1].contains('LS') || parts[1].contains('BB')) {
      value = -value;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Gempa Semarang",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Color(0xFF275E76)),
                        onPressed: fetchEarthquakeData,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : earthquakes.isEmpty
                            ? Center(
                                child: Text(
                                  'Tidak ada data gempa terbaru',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : Column(
                                children: [
                                  // Map Section
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: FlutterMap(
                                        mapController: mapController,
                                       options: MapOptions(
  initialCenter: semarangCenter, 
  initialZoom: 9.0, 
),
                                        children: [
                                          TileLayer(
                                            urlTemplate:
                                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            subdomains: ['a', 'b', 'c'],
                                            userAgentPackageName:
                                                'com.example.app',
                                          ),
                                          MarkerLayer(
                                            markers: earthquakes
                                                .map(
                                                  (quake) => Marker(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    point: LatLng(
                                                      quake.latitude,
                                                      quake.longitude,
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        mapController.move(
                                                          LatLng(
                                                            quake.latitude,
                                                            quake.longitude,
                                                          ),
                                                          12.0,
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.location_on,
                                                        color:
                                                            _getMagnitudeColor(
                                                                quake
                                                                    .magnitude),
                                                        size: 30 +
                                                            quake.magnitude * 2,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    'Gempa Terkini (${earthquakes.length} kejadian)',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: earthquakes.length,
                                      itemBuilder: (context, index) =>
                                          _buildEarthquakeCard(
                                              earthquakes[index]),
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarthquakeCard(Earthquake earthquake) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          mapController.move(
            LatLng(earthquake.latitude, earthquake.longitude),
            12.0,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.landscape,
                        color: _getMagnitudeColor(earthquake.magnitude),
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${earthquake.magnitude.toStringAsFixed(1)} SR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getMagnitudeColor(earthquake.magnitude),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Kedalaman: ${earthquake.depth.toStringAsFixed(1)} km',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                earthquake.location,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 5),
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(earthquake.time),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMagnitudeColor(double magnitude) {
    if (magnitude < 4.0) return Colors.green;
    if (magnitude < 6.0) return Colors.orange;
    return Colors.red;
  }
}

class Earthquake {
  final double magnitude;
  final String location;
  final DateTime time;
  final double depth;
  final double latitude;
  final double longitude;

  Earthquake({
    required this.magnitude,
    required this.location,
    required this.time,
    required this.depth,
    required this.latitude,
    required this.longitude,
  });
}
