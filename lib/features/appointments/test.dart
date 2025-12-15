// import 'package:flutter/material.dart';

// class AppointmentBookingScreen extends StatefulWidget {
//   const AppointmentBookingScreen({super.key});

//   @override
//   State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
// }

// class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
//   // --- Dummy data ---
//   final pets = [
//     {
//       'name': 'Bella',
//       'breed': 'Golden Barthoor',
//       'meta': 'Female • 5 years',
//       'image': 'https://veticareapp.com/squeakUI/assets/pet1.jpg'
//     },
//   ];

//   final doctors = [
//     {'name': 'Dr. Sarah Johnson', 'title': 'General Practice', 'exp': '5+ years', 'rating': 4.9, 'image': 'https://veticareapp.com/squeakUI/assets/doc1.jpg'},
//     {'name': 'Dr. Michael Chen', 'title': 'Emergency Care', 'exp': '8+ years', 'rating': 4.8, 'image': 'https://veticareapp.com/squeakUI/assets/doc2.jpg'},
//     {'name': 'Dr. Emily Rodriguez', 'title': 'Surgery Specialist', 'exp': '12+ years', 'rating': 4.9, 'image': 'https://veticareapp.com/squeakUI/assets/doc3.jpg'},
//   ];

//   // Times
//   final times = [
//     '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM',
//     '2:00 PM', '2:30 PM', '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM'
//   ];

//   // Calendar data for September 2025
//   final List<List<int>> september2025 = [
//     [31, 1, 2, 3, 4, 5, 6],
//     [7, 8, 9, 10, 11, 12, 13],
//     [14, 15, 16, 17, 18, 19, 20],
//     [21, 22, 23, 24, 25, 26, 27],
//     [28, 29, 30, 1, 2, 3, 4],
//     [5, 6, 7, 8, 9, 10, 11],
//   ];

//   // --- State ---
//   int selectedPetIndex = 0;
//   int? selectedDoctorIndex;
//   DateTime selectedDate = DateTime(2025, 9, 1);
//   String? selectedTime;
//   String notes = '';

//   void _selectPet(int idx) => setState(() => selectedPetIndex = idx);
//   void _selectDoctor(int idx) => setState(() => selectedDoctorIndex = idx);
//   void _selectTime(String t) => setState(() => selectedTime = t);
//   void _selectDate(int day) => setState(() => selectedDate = DateTime(2025, 9, day));

//   void _bookAppointment() {
//     if (selectedDoctorIndex == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Please select a doctor'),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       );
//       return;
//     }
//     if (selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Please choose a time'),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       );
//       return;
//     }

//     // Show confirmation dialog
//     _showConfirmationDialog();
//   }

//   void _showConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'Appointment Booked',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text('Your appointment has been successfully scheduled.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Book Appointment',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         centerTitle: false,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Select Your Pet Section
//             _buildSectionTitle('Select Your Pet'),
//             const SizedBox(height: 16),
//             _buildPetCard(),
//             const SizedBox(height: 32),

//             // Choose Doctor Section
//             _buildSectionTitle('Choose Doctor'),
//             const SizedBox(height: 16),
//             _buildDoctorSection(),
//             const SizedBox(height: 32),

//             // Select Date & Time Section
//             _buildSectionTitle('Select Date & Time'),
//             const SizedBox(height: 16),
//             _buildCalendarSection(),
//             const SizedBox(height: 16),
//             _buildTimeSlots(),
//             const SizedBox(height: 32),

//             // Additional Notes Section
//             _buildSectionTitle('Additional Notes (Optional)'),
//             const SizedBox(height: 16),
//             _buildNotesField(),
//             const SizedBox(height: 32),

//             // Action Buttons
//             _buildActionButtons(),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.w600,
//         color: Colors.black87,
//       ),
//     );
//   }

//   Widget _buildPetCard() {
//     final pet = pets[selectedPetIndex];
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Row(
//         children: [
//           // Pet Image
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.grey.shade200,
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 pet['image']!.toString(),
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Icon(
//                   Icons.pets,
//                   size: 40,
//                   color: Colors.grey.shade400,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   pet['name']!.toString(),
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   pet['breed']!.toString(),
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   pet['meta']!.toString(),
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDoctorSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (selectedDoctorIndex == null) ...[
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'select a doctor',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Cleaner from available doctors',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ] else ...[
//           _buildDoctorCard(selectedDoctorIndex!),
//         ],
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 120,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: doctors.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () => _selectDoctor(index),
//                 child: Container(
//                   width: 100,
//                   margin: EdgeInsets.only(right: index == doctors.length - 1 ? 0 : 12),
//                   child: Column(
//                     children: [
//                       // Doctor Image
//                       Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: selectedDoctorIndex == index
//                                 ? Colors.blue.shade600
//                                 : Colors.grey.shade300,
//                             width: 2,
//                           ),
//                         ),
//                         child: ClipOval(
//                           child: Image.network(
//                             doctors[index]['image']!.toString(),
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) => Icon(
//                               Icons.person,
//                               size: 30,
//                               color: Colors.grey.shade400,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         doctors[index]['name']!.toString().split(' ').sublist(0, 2).join(' '),
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: selectedDoctorIndex == index
//                               ? FontWeight.w600
//                               : FontWeight.normal,
//                           color: selectedDoctorIndex == index
//                               ? Colors.blue.shade600
//                               : Colors.black87,
//                         ),
//                         textAlign: TextAlign.center,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDoctorCard(int index) {
//     final doctor = doctors[index];
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue.shade300),
//       ),
//       child: Row(
//         children: [
//           // Doctor Image
//           Container(
//             width: 60,
//             height: 60,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//             ),
//             child: ClipOval(
//               child: Image.network(
//                 doctor['image']!.toString(),
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Icon(
//                   Icons.person,
//                   size: 30,
//                   color: Colors.grey.shade400,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   doctor['name']!.toString(),
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${doctor['title']} • ${doctor['exp']}',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCalendarSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         children: [
//           // Month Header
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'September 2025',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Week days
//           const Row(
//             children: [
//               Expanded(child: Text('Sun', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey))),
//               Expanded(child: Text('Mon', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey))),
//               Expanded(child: Text('Tue', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey))),
//               Expanded(child: Text('Wed', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey))),
//               Expanded(child: Text('Thu', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey))),
//               Expanded(child: Text('Fri', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey))),
//               Expanded(child: Text('Sat', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey))),
//             ],
//           ),
//           const SizedBox(height: 8),

//           // Calendar grid
//           ...september2025.map((week) => Row(
//             children: week.map((day) => Expanded(
//               child: GestureDetector(
//                 onTap: day <= 30 ? () => _selectDate(day) : null,
//                 child: Container(
//                   height: 40,
//                   margin: const EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                     color: selectedDate.day == day && day <= 30
//                         ? Colors.blue.shade600
//                         : Colors.transparent,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Text(
//                       day.toString(),
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: day <= 30
//                             ? (selectedDate.day == day ? Colors.white : Colors.black87)
//                             : Colors.grey.shade400,
//                         fontWeight: selectedDate.day == day && day <= 30
//                             ? FontWeight.w600
//                             : FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             )).toList(),
//           )),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeSlots() {
//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: times.map((time) {
//         final isSelected = selectedTime == time;
//         return GestureDetector(
//           onTap: () => _selectTime(time),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: isSelected ? Colors.blue.shade600 : Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                 color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
//               ),
//             ),
//             child: Text(
//               time,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isSelected ? Colors.white : Colors.black87,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildNotesField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: TextFormField(
//         maxLines: 4,
//         maxLength: 500,
//         initialValue: notes,
//         decoration: const InputDecoration(
//           contentPadding: EdgeInsets.all(16),
//           border: InputBorder.none,
//           hintText: 'Add comment about your pet\'s condition, symptoms, or any special requirements...',
//           hintStyle: TextStyle(color: Colors.grey),
//         ),
//         onChanged: (v) => notes = v,
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: () => Navigator.pop(context),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               side: BorderSide(color: Colors.grey.shade300),
//             ),
//             child: const Text(
//               'Back',
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: _bookAppointment,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.shade600,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text(
//               'Book',
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
