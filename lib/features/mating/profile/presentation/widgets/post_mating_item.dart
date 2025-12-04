// import 'package:flutter/material.dart';
// import 'package:fast_cached_network_image/fast_cached_network_image.dart';
// import 'package:squeak/core/utils/export_path/export_files.dart';
// import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
// import '../../../../../core/service/global_widget/image_detail.dart';
// import '../../../../layout/post/domain/entities/post_entity.dart';
//
// class BuildPostItemMaying extends StatelessWidget {
//   const BuildPostItemMaying({
//     super.key,
//     required this.postItem,
//     required this.petEntities,
//   });
//
//   final PostEntity postItem;
//   final PetEntities petEntities;
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = MainCubit.get(context).isDark;
//     final textColor = isDark ? Colors.white : Colors.black;
//     final subTextColor = isDark ? Colors.white : Colors.grey;
//
//     final images = postItem.postSocialMedia
//         ?.where((e) => e.imagePath != null && e.imagePath!.isNotEmpty)
//         .toList() ??
//         [];
//     final videos = postItem.postSocialMedia
//         ?.where((e) => e.videoPath != null && e.videoPath!.isNotEmpty)
//         .toList() ??
//         [];
//
//     Widget buildImages() {
//       if (images.isEmpty) return const SizedBox.shrink();
//
//       if (images.length == 1) {
//         return InkWell(
//           onTap: () => navigateToScreen(
//             context,
//             ImageDetailSimple(
//               path: imageUrl + images.first.imagePath!,
//               title: postItem.title ?? '',
//               description: postItem.content ?? '',
//             ),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: FastCachedImage(
//               url: imageUrl + images.first.imagePath!,
//               fit: BoxFit.cover,
//               height: 250,
//               width: double.infinity,
//             ),
//           ),
//         );
//       } else {
//         return GridView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 8,
//             mainAxisSpacing: 8,
//             childAspectRatio: 1.0,
//           ),
//           itemCount: images.length,
//           itemBuilder: (context, index) {
//             final img = images[index];
//             return InkWell(
//               onTap: () => navigateToScreen(
//                 context,
//                 ImageDetailSimple(
//                   path: imageUrl + img.imagePath!,
//                   title: postItem.title ?? '',
//                   description: postItem.content ?? '',
//                 ),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: FastCachedImage(
//                   url: imageUrl + img.imagePath!,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             );
//           },
//         );
//       }
//     }
//
//     Widget buildVideos() {
//       if (videos.isEmpty) return const SizedBox.shrink();
//
//       if (videos.length == 1) {
//         return Padding(
//           padding: const EdgeInsets.only(top: 12),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: VideoStringApp(video: imageUrl + videos.first.videoPath!),
//           ),
//         );
//       } else {
//         return Column(
//           children: videos.map((vid) {
//             return Padding(
//               padding: const EdgeInsets.only(top: 12),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: VideoStringApp(video: imageUrl + vid.videoPath!),
//               ),
//             );
//           }).toList(),
//         );
//       }
//     }
//
//     return RepaintBoundary(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//         decoration: Decorations.kDecorationBoxShadow(context: context),
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Pet info
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: isDark ? Colors.black38 : Colors.white,
//                     backgroundImage: FastCachedImageProvider(
//                       imageUrl + (petEntities.imageName ?? ''),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           petEntities.petName ?? '',
//                           style: FontStyleThame.textStyle(context: context),
//                         ),
//                         const SizedBox(height: 5),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.7,
//                           child: Text(
//                             postItem.title ?? '',
//                             maxLines: 4,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall
//                                 ?.copyWith(
//                               fontSize: 14,
//                               color: subTextColor,
//                               height: 1.4,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//
//               // Post content
//               if (postItem.content != null)
//                 Text(postItem.content!, style: TextStyle(color: textColor)),
//               const SizedBox(height: 12),
//
//               // Images and videos
//               buildImages(),
//               buildVideos(),
//
//               if (images.isNotEmpty || videos.isNotEmpty)
//                 const SizedBox(height: 12),
//
//               // Post time
//               Text(
//                 formatFacebookTimePost(postItem.createdAt ?? ''),
//                 style: FontStyleThame.textStyle(
//                   context: context,
//                   fontWeight: FontWeight.w400,
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
