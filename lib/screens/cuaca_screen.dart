import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CuacaScreen extends StatefulWidget {
  @override
  _CuacaScreenState createState() => _CuacaScreenState();
}

class _CuacaScreenState extends State<CuacaScreen> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    const apiKey = '6c2f8ee6115c71ae31a6531fb8e5d082';
    const city = 'Semarang';
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          weatherData = data;
          isLoading = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Gagal memuat data cuaca (kode: ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Terjadi kesalahan: $e';
      });
    }
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator()
                          : errorMessage != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      errorMessage!,
                                      style: TextStyle(color: Colors.red, fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isLoading = true;
                                          errorMessage = null;
                                        });
                                        _fetchWeatherData();
                                      },
                                      child: Text('Coba Lagi'),
                                    )
                                  ],
                                )
                              : _buildWeatherCard(),
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

  Widget _buildWeatherCard() {
    final temp = weatherData?['main']?['temp']?.round() ?? 0;
    final humidity = weatherData?['main']?['humidity'] ?? 0;
    final windSpeed = weatherData?['wind']?['speed'] ?? 0;
    final description = weatherData?['weather']?[0]?['description'] ?? '';

    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 10,
      child: Container(
        width: 300,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Cuaca Semarang',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF275E76),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.thermostat, size: 40, color: Color(0xFF275E76)),
                SizedBox(width: 10),
                Text(
                  '$temp°C',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildWeatherRow('Kelembapan', '$humidity%', Icons.opacity),
            _buildWeatherRow('Kecepatan Angin', '${windSpeed}m/s', Icons.air),
            _buildWeatherRow('Kondisi', description, Icons.cloud),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF275E76)),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(value),
        ],
      ),
    );
  }
}
