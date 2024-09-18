// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../controller/splash_controller.dart';

// class SplashScreeen extends StatefulWidget {
//   const SplashScreeen({super.key});

//   @override
//   State<SplashScreeen> createState() => _SplashScreeenState();
// }

// class _SplashScreeenState extends State<SplashScreeen> {
//   final SplashController _controller = Get.put(SplashController());

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Text(
//               "Premier League",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }
