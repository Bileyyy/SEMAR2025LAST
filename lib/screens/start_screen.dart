// import 'package:flutter/material.dart';
// import '../widgets/navbar.dart'; // Import Navbar untuk navigasi

// class StartScreen extends StatelessWidget {
//   const StartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('Flutter Demo Home Page'),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/bg/lawang1000.png"), // Gambar background
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               // Navigasi ke Navbar saat tombol ditekan
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => Navbar()),
//               );
//             },
//             child: const Text('Start'),
//           ),
//         ),
//       ),
//     );
//   }
// }