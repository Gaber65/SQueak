// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:squeak/core/service/global_function/format_utils.dart';
// import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
// // import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';
// import 'package:squeak/features/friendship/presentation/controllers/pet_friend_cubit.dart';
// import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
// import '../widgets/send_pets_request/start_sugget_tab.dart';
// import '../widgets/find_friends/bottom_buttons.dart';
// import '../widgets/find_friends/search_bar_widget.dart';

// class SuggestionFriendsScreen extends StatefulWidget {
//   final String petId;
//   final String specieId;

//   const SuggestionFriendsScreen({
//     super.key,
//     required this.petId,
//     required this.specieId,
//   });

//   @override
//   State<SuggestionFriendsScreen> createState() => _SuggestionFriendsScreenState();
// }

// class _SuggestionFriendsScreenState extends State<SuggestionFriendsScreen> {
//   late TextEditingController _searchController;

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create:
//           (context) =>
//               sl<PetFriendsCubit>()..loadSuggestedFriends(specieId: widget.specieId),
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text(
//             isArabic() ? 'الأصدقاء المقترحون' : 'Suggested Friends',
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: ColorManager.black87,
//             ),
//           ),
//         ),
//         body: BlocConsumer<PetFriendsCubit, PetFriendsState>(
//           listener: (context, state) {},
//           builder: (context, state) {
//             var cubit = PetFriendsCubit.get(context);
//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SearchBarWidget(
//                     controller: _searchController,
//                     specieId: widget.specieId,
//                     onChanged: (value) {
//                       // Trigger search when text changes
//                       cubit.loadSuggestedFriends(
//                         specieId: widget.specieId,
//                         name: value.isEmpty ? null : value,
//                       );
//                     },
//                     onClear: () {
//                       // Reload all suggestions when search is cleared
//                       cubit.loadSuggestedFriends(specieId: widget.specieId);
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color:
//                         Theme.of(context).brightness == Brightness.dark
//                             ? const Color(0xFF1E1E1E)
//                             : const Color(0xFFE8F2FF),
//                     border: const Border(
//                       top: BorderSide(
//                         color: ColorManager.primaryColor,
//                         width: 1,
//                       ),
//                       bottom: BorderSide(
//                         color: ColorManager.primaryColor,
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.info_outline,
//                         color: Colors.blue[700],
//                         size: 16,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           isArabic()
//                               ? 'إقترحنا لك بعض الأصدقاء الجدد'
//                               : 'We suggested some new friends for you.',
//                           style: TextStyle(
//                             color: Colors.blue[700],
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: StartSuggetTab(
//                     suggested: cubit.suggestedFriends,
//                     specieId: widget.specieId,
//                     activePetId: widget.petId,
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//         bottomNavigationBar: const BottomButtons(),
//       ),
//     );
//   }
// }