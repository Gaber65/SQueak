import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/layout/notification/NotificationAPI/presentation/controller/notifications_cubit.dart';
import 'package:squeak/features/layout/notification/NotificationAPI/presentation/screens/test.dart';



class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationsCubit>()..fetchNotifications(),
      child: BlocConsumer<NotificationsCubit, NotificationsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = NotificationsCubit.get(context);
          return Scaffold(

            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(S.of(context).notifications),
              centerTitle: true,
            ),
            body:
                (state is NotificationsLoadingState)
                    ? _buildShimmerLoading(MainCubit.get(context).isDark)
                    : (cubit.notifications.isNotEmpty)
                    ? Container(
                  decoration: BoxDecoration(
                    color: !MainCubit.get(context).isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return NotificationCard(
                            notification: cubit.notifications[index],
                          );
                        },
                        itemCount: cubit.notifications.length,
                      ),
                    )
                    : Center(
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/rb_1220.png?alt=media&token=8c71b107-7849-475e-91d8-feab8b7a4f27',
                      ),
                    ),
          );
        },
      ),
    );
  }
  Widget _buildShimmerLoading(bool isDarkMode) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8.0),
        itemBuilder: (context, index) {
          return Container(
            height: 90, // Adjusted height for shimmer to match card
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Shimmer base color
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
        itemCount: 6, // Show a few shimmer items
      ),
    );
  }
  // Widget _buildContent(NotificationEntities model,BuildContext context) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //     height: 65,
  //     decoration: BoxDecoration(
  //       color:
  //           !MainCubit.get(context).isDark ? Colors.blue.shade50 : Colors.black,
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: InkWell(
  //       onTap: () {
  //         showNotificationDialog(context, model);
  //       },
  //       child: Container(
  //         width: double.infinity,
  //         padding: const EdgeInsets.all(10),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               height: 40,
  //               width: 40,
  //               decoration: BoxDecoration(
  //                 color: getColorForNotification(model),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Center(
  //                 child: Icon(getNotificationIcon(model), color: Colors.white),
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             Expanded(
  //               flex: 3,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     model.title,
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: const TextStyle(
  //                       fontFamily: 'bold',
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 5),
  //                   Text(
  //                     model.message,
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 1,
  //                     style: const TextStyle(color: Colors.grey, fontSize: 13),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             Expanded(
  //               child: Text(
  //                 formatFacebookTimePost(model.createdAt),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
