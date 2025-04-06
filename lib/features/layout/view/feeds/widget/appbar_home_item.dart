import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/layout/view/notifications/notificationPage.dart';
import 'package:squeak/features/layout/view/search/search_screen.dart';

AppBar buildAppBarHome(context) {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: false,
    title: ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.blue.shade900, Colors.blue.shade400], // Gradient colors
        tileMode: TileMode.decal,
      ).createShader(bounds),
      child: Text(
        'SQueak',
        style: TextStyle(
          fontSize: 25.0,
          color: Colors.white, // Color here is ignored
        ),
      ),
    ),
    // title:  Stack(
    //   children: [
    //     IconButton(
    //       iconSize: 32,
    //       onPressed: () {
    //         navigateToScreen(context, FollowRequestScreen());
    //       },
    //       icon: const Icon(IconlyLight.add_user),
    //     ),
    //     if (CacheHelper.getData('notificationsNum') != null)
    //       PositionedDirectional(
    //         start: 2, // Adjust the position as needed
    //         top: 5, // Adjust the position as needed
    //         child: CircleAvatar(
    //           radius: 10,
    //           backgroundColor: Colors.red,
    //           child: Text(
    //             CacheHelper.getData('notificationsNum').toString(),
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //       ),
    //   ],
    // ),
    actions: [
      IconButton(
        onPressed: () {
          navigateToScreen(context, SearchScreen());
        },
        icon: const Icon(
          IconlyLight.search,
        ),
      ),
      IconButton(
        iconSize: 32,
        onPressed: () {
          navigateToScreen(context, NotificationScreen());
        },
        icon: (CacheHelper.getData('notificationsNum') != null)
            ? Badge.count(
                alignment: AlignmentDirectional.topCenter,
                count: CacheHelper.getData('notificationsNum'),
                textColor: Colors.white,
                child: const Icon(
                  IconlyLight.notification,
                ),
              )
            : const Icon(IconlyLight.notification),
      ),
    ],
    // title: BlocConsumer<LayoutCubit, LayoutState>(
    //   listener: (context, state) {
    //     // TODO: implement listener
    //   },
    //   builder: (context, state) {
    //     var cubit = LayoutCubit.get(context);
    //     return (state is SqueakUpdateProfilelaodingUpdated)
    //         ? Row(
    //             children: [
    //               WidgetCircularAnimator(
    //                 size: 50,
    //                 innerIconsSize: 3,
    //                 outerIconsSize: 3,
    //                 innerAnimation: Curves.easeInOutBack,
    //                 outerAnimation: Curves.easeInOutBack,
    //                 innerColor: Colors.deepPurple,
    //                 outerColor: Colors.orangeAccent,
    //                 innerAnimationSeconds: 10,
    //                 outerAnimationSeconds: 10,
    //                 child: Container(
    //                   decoration: BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     color: Colors.grey[200],
    //                   ),
    //                   child: Icon(
    //                     Icons.person_outline,
    //                     color: Colors.deepOrange[200],
    //                     size: 30,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           )
    //         : (CacheHelper.getData('ImageActive') == null)
    //             ? InkWell(
    //                 onTap: () {
    //                   LayoutCubit.get(context).getOwnerPet().then((value) {
    //                     cubit.addUserToProfile();
    //                     showModalBottomSheet(
    //                       context: context,
    //                       isScrollControlled: true,
    //                       // Allow the sheet to expand to full height
    //                       builder: (BuildContext context) {
    //                         if (cubit.pets.isNotEmpty) {
    //                           return SingleChildScrollView(
    //                             child: Container(
    //                               padding: EdgeInsets.only(
    //                                 bottom:
    //                                 MediaQuery.of(context).viewInsets.bottom,
    //                               ),
    //                               child: SizedBox(
    //                                 height:
    //                                 MediaQuery.of(context).size.height * 0.4,
    //                                 child: ListView.builder(
    //                                   itemBuilder: (context, index) {
    //                                     return buildDropDownSpeciesTest(
    //                                       cubit.pets[index],
    //                                       context,
    //                                       cubit,
    //                                     );
    //                                   },
    //                                   itemCount: cubit.pets.length,
    //                                 ),
    //                               ),
    //                             ),
    //                           );
    //                         } else {
    //                           return Container(
    //                             padding: EdgeInsets.only(
    //                               bottom:
    //                               MediaQuery.of(context).viewInsets.bottom,
    //                             ),
    //                             child: SizedBox(
    //                               // Use SizedBox to limit the height
    //                                 height:
    //                                 MediaQuery.of(context).size.height * 0.5,
    //                                 // Adjust the fraction to control the height
    //                                 child: Center(
    //                                   child: Image.network(
    //                                       'https://img.freepik.com/free-vector/no-data-concept-illustration_114360-536.jpg?w=740&t=st=1711500004~exp=1711500604~hmac=a8caa2ffe35a9993e4130c9c1d9786c949807796be4d6794519bcbe59997601f'),
    //                                 )),
    //                           );
    //                         }
    //                       },
    //                     );
    //                   });
    //
    //
    //                 },
    //                 child: CircleAvatar(
    //                   radius: 22,
    //                   backgroundColor:
    //                       Theme.of(context).scaffoldBackgroundColor,
    //                   backgroundImage: NetworkImage(
    //                       '$imageUrl${cubit.profile.imageName}'),
    //                 ),
    //               )
    //             : InkWell(
    //                 onTap: () {
    //                   LayoutCubit.get(context).getOwnerPet().then((value) {
    //                     cubit.addUserToProfile();
    //                     showModalBottomSheet(
    //                       context: context,
    //                       isScrollControlled: true,
    //                       // Allow the sheet to expand to full height
    //                       builder: (BuildContext context) {
    //                         if (cubit.pets.isNotEmpty) {
    //                           return SingleChildScrollView(
    //                             // Wrap the content in a SingleChildScrollView for scrolling
    //                             child: Container(
    //                               padding: EdgeInsets.only(
    //                                 bottom:
    //                                 MediaQuery.of(context).viewInsets.bottom,
    //                               ),
    //                               child: SizedBox(
    //                                 // Use SizedBox to limit the height
    //                                 height:
    //                                 MediaQuery.of(context).size.height * 0.4,
    //                                 // Adjust the fraction to control the height
    //                                 child: ListView.builder(
    //                                   itemBuilder: (context, index) {
    //                                     return buildDropDownSpeciesTest(
    //                                       cubit.pets[index],
    //                                       context,
    //                                       cubit,
    //                                     );
    //                                   },
    //                                   itemCount: cubit.pets.length,
    //                                 ),
    //                               ),
    //                             ),
    //                           );
    //                         } else {
    //                           return Container(
    //                             padding: EdgeInsets.only(
    //                               bottom:
    //                               MediaQuery.of(context).viewInsets.bottom,
    //                             ),
    //                             child: SizedBox(
    //                               // Use SizedBox to limit the height
    //                               height:
    //                               MediaQuery.of(context).size.height * 0.5,
    //                               // Adjust the fraction to control the height
    //                               child: Center(
    //                                 child: Image.network(
    //                                     'https://img.freepik.com/free-vector/no-data-concept-illustration_114360-536.jpg?w=740&t=st=1711500004~exp=1711500604~hmac=a8caa2ffe35a9993e4130c9c1d9786c949807796be4d6794519bcbe59997601f'),
    //                               ),
    //                             ),
    //                           );
    //                         }
    //                       },
    //                     );
    //                   });
    //
    //
    //                 },
    //                 child: CircleAvatar(
    //                   radius: 22,
    //                   backgroundColor:
    //                       Theme.of(context).scaffoldBackgroundColor,
    //                   backgroundImage: NetworkImage(
    //                       '$imageUrl${CacheHelper.getData('ImageActive')}'),
    //                 ),
    //               );
    //   },
    // ),
  );
}
