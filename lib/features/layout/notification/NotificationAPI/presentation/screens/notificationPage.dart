import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/layout/notification/NotificationAPI/presentation/controller/notifications_cubit.dart';

import 'package:squeak/generated/l10n.dart';

import '../../domain/entities/notification_entities.dart';
import '../widget/get_color_for_notification.dart';
import '../widget/get_notification_icon.dart';
import '../widget/show_notification_dialog.dart';

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
              elevation: 0,
              title: Text(S.of(context).notifications),
              centerTitle: true,
            ),
            body:
                (state is NotificationsLoadingState)
                    ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade700,
                      highlightColor: Colors.grey.shade600,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            height: 60,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  !MainCubit.get(context).isDark
                                      ? Colors.blue.shade50
                                      : Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                        itemCount: 10,
                      ),
                    )
                    : (cubit.notifications.isNotEmpty)
                    ? ListView.builder(
                      itemBuilder: (context, index) {
                        return _buildContent(
                          cubit.notifications[index],
                          context,
                        );
                      },
                      itemCount: cubit.notifications.length,
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

  Widget _buildContent(NotificationEntities model,BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 65,
      decoration: BoxDecoration(
        color:
            !MainCubit.get(context).isDark ? Colors.blue.shade50 : Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          showNotificationDialog(context, model);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: getColorForNotification(model),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(getNotificationIcon(model), color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'bold',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      model.message,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  formatFacebookTimePost(model.createdAt),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
