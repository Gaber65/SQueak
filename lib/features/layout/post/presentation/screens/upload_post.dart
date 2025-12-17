// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/layout/post/presentation/community/controller/community_cubit.dart';
import '../../../../../core/service/service_locator/service_locator.dart';
import '../controller/post_cubit.dart';
import '../widget/add_post_component/upload_post_controller.dart';
import '../widget/add_post_component/upload_post_ui.dart';

class UploadPost extends StatefulWidget {
  const UploadPost({
    super.key,
    required this.image,
    required this.name,
    required this.petID,
  });

  final String image;
  final String name;
  final String petID;

  @override
  State<UploadPost> createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost>
    with SingleTickerProviderStateMixin {
  late UploadPostController controller;

  @override
  void initState() {
    super.initState();
    controller = UploadPostController(
      vsync: this,
      petID: widget.petID,
      name: widget.name,
      image: widget.image,
    );
    controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CommunityCubit? cubitValue;
    // Try to get value of CommunityCubit from context instead of creating a new one
    try {
      cubitValue = context.read<CommunityCubit>();
    } catch (e) {}

    return MultiBlocProvider(
      providers: [
        //check if cubitValue is not null then provide it using BlocProvider.value else create a new one
        if (cubitValue != null)
          BlocProvider<CommunityCubit>.value(value: cubitValue)
        else
          BlocProvider(create: (context) => CommunityCubit()),
        BlocProvider(create: (context) => sl<PostCubit>()),
      ],
      child: BlocListener<PostCubit, PostState>(
        listener: controller.handlePostStateChanges,
        child: UploadPostUI(controller: controller, widget: widget),
      ),
    );
  }
}
