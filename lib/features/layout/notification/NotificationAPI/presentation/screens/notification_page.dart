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
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = NotificationsCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(S.of(context).notifications),
              centerTitle: true,
            ),
            body: _buildBody(context, state, cubit),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationsState state,
    NotificationsCubit cubit,
  ) {
    if (state is NotificationsStateData) {
      final data = state;

      // Show loading shimmer only on initial load, not on refresh
      if (data.isLoading && !data.isRefreshing && data.notifications.isEmpty) {
        return _buildShimmerLoading(MainCubit.get(context).isDark);
      }

      return _buildContent(context, data, cubit);
    }

    // Fallback for initial state
    return _buildShimmerLoading(MainCubit.get(context).isDark);
  }

  Widget _buildContent(
    BuildContext context,
    NotificationsStateData data,
    NotificationsCubit cubit,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await cubit.fetchNotifications(isRefreshing: true);
      },
      child: Container(
        decoration: BoxDecoration(
          color: !MainCubit.get(context).isDark ? Colors.white : Colors.black,
        ),
        child: _buildNotificationList(context, data, cubit),
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    NotificationsStateData data,
    NotificationsCubit cubit,
  ) {
    if (data.notifications.isEmpty) {
      return Center(
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/rb_1220.png?alt=media&token=8c71b107-7849-475e-91d8-feab8b7a4f27',
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return NotificationCard(notification: data.notifications[index]);
      },
      itemCount: data.notifications.length,
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
            height: 90,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
        itemCount: 6,
      ),
    );
  }
}
