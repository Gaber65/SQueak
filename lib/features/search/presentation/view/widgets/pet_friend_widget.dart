// import 'package:flutter/material.dart';

// class PetFriendWidget extends StatelessWidget {
//   const PetFriendWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ListTile(
//           leading: const CircleAvatar(radius: 26),
//           title: const Text('Buddy'),
//           subtitle: Column(
//             children: [const Text('Golden Retriever • 3 years old')],
//           ),
//           trailing: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.blueAccent,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: const [
//                 Icon(Icons.pets, size: 16, color: Colors.white),
//                 SizedBox(width: 4),
//                 Text("Adopt", style: TextStyle(color: Colors.white)),
//               ],
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 16),
//           child: Row(
//             children: [
//               Icon(Icons.not_listed_location_sharp),
//               Text('Egypt'),
//               SizedBox(width: 8),
//               Icon(Icons.people),
//               Text('15 Friends'),
//               SizedBox(width: 8),
//               Icon(Icons.ac_unit),
//             ],
//           ),
//         ),
//         SizedBox(height: 12),
//         Padding(
//           padding: const EdgeInsets.only(left: 16),
//           child: Row(
//             children: [
//               const CircleAvatar(radius: 12),
//               CircleAvatar(radius: 12),
//               SizedBox(width: 12),

//               Text('2 Mutual Friend'),
//             ],
//           ),
//         ),
//         Row(children: [Container()],)
//       ],
//     );
//   }
// }
