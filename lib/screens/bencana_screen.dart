import 'package:flutter/material.dart';

class BencanaScreen extends StatelessWidget {
  final List<Disaster> disasters = [
    Disaster(
      title: "Banjir Rob",
      location: "Pesisir Utara Semarang",
      status: "Aktif",
      icon: Icons.flood,
    ),
    Disaster(
      title: "Tanah Longsor",
      location: "Kawasan Bukit Semarang",
      status: "Siaga",
      icon: Icons.landslide,
    ),
    Disaster(
      title: "Kebakaran",
      location: "Kawasan Pemukiman Padat",
      status: "Waspada",
      icon: Icons.local_fire_department,
    ),
  ];

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
                  Text(
                    "Info Bencana",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: disasters.length,
                      itemBuilder: (context, index) => _buildDisasterCard(disasters[index]),
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

  Widget _buildDisasterCard(Disaster disaster) {
    Color statusColor;
    switch (disaster.status.toLowerCase()) {
      case 'aktif':
        statusColor = Colors.red;
        break;
      case 'siaga':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.yellow;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(disaster.icon, size: 40, color: Color(0xFF275E76)),
        title: Text(
          disaster.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(disaster.location),
        trailing: Chip(
          backgroundColor: statusColor.withOpacity(0.2),
          label: Text(
            disaster.status,
            style: TextStyle(color: statusColor),
          ),
        ),
      ),
    );
  }
}

class Disaster {
  final String title;
  final String location;
  final String status;
  final IconData icon;

  Disaster({
    required this.title,
    required this.location,
    required this.status,
    required this.icon,
  });
}