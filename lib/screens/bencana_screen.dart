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
          try {
            final dateTimeStr = '${quake['Tanggal']} ${quake['Jam']}';
            final dateTime = DateFormat("dd-MM-yyyy HH:mm:ss").parse(dateTimeStr);

            loadedEarthquakes.add(Earthquake(
              magnitude: double.parse(quake['Magnitude']),
              location: quake['Wilayah'],
              time: dateTime,
              depth: double.parse(quake['Kedalaman'].split(' ')[0]),
              latitude: _parseCoordinate(quake['Lintang']),
              longitude: _parseCoordinate(quake['Bujur']),
            ));
          } catch (_) {
            continue;
          }
        }

        setState(() {
          earthquakes = loadedEarthquakes;
          isLoading = false;
          if (earthquakes.isNotEmpty) {
            mapController.move(
              LatLng(earthquakes.first.latitude, earthquakes.first.longitude),
              5.0,
            );
          }
        });
      } else {
        throw Exception('Status bukan 200');
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

  Color _getMagnitudeColor(double magnitude) {
    if (magnitude < 4.0) return Colors.green;
    if (magnitude < 6.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg/lawang1000.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Color(0xFFFFF2DA).withOpacity(0.6),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Gempa Semarang',
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
                                  // Map section
                                  Container(
                                    height: 200,
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: FlutterMap(
                                        mapController: mapController,
                                        options: MapOptions(
                                          initialCenter: LatLng(
                                            earthquakes.first.latitude,
                                            earthquakes.first.longitude,
                                          ),
                                          initialZoom: 5.0,
                                        ),
                                        children: [
                                          TileLayer(
                                            urlTemplate:
                                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            subdomains: ['a', 'b', 'c'],
                                          ),
                                          MarkerLayer(
                                            markers: earthquakes.map((quake) {
                                              return Marker(
                                                width: 40,
                                                height: 40,
                                                point: LatLng(
                                                    quake.latitude,
                                                    quake.longitude),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    mapController.move(
                                                      LatLng(quake.latitude,
                                                          quake.longitude),
                                                      7.5,
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.location_on,
                                                    size: 30 +
                                                        quake.magnitude * 2,
                                                    color: _getMagnitudeColor(
                                                        quake.magnitude),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Daftar Gempa (${earthquakes.length} data)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: earthquakes.length,
                                      itemBuilder: (context, index) {
                                        final quake = earthquakes[index];
                                        return Card(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.terrain,
                                              color: _getMagnitudeColor(
                                                  quake.magnitude),
                                              size: 30,
                                            ),
                                            title: Text(
                                              '${quake.magnitude.toStringAsFixed(1)} SR - ${quake.location}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              DateFormat('dd MMM yyyy, HH:mm')
                                                  .format(quake.time),
                                            ),
                                            onTap: () {
                                              mapController.move(
                                                  LatLng(quake.latitude,
                                                      quake.longitude),
                                                  7.5);
                                            },
                                          ),
                                        );
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
        ],
      ),
    );
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
