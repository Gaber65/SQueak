import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/layout/post/domain/entities/post_entity.dart';
import 'package:squeak/features/layout/post/presentation/controller/post_cubit.dart';
import '../community/controller/community_cubit.dart';
import '../widget/edit_post/edit_post_controller.dart';
import '../widget/edit_post/edit_post_ui.dart';


class EditPostScreen extends StatefulWidget {
  final PostEntity postEntity;

  const EditPostScreen({
    super.key,
    required this.postEntity,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen>
    with TickerProviderStateMixin {
  late EditPostController _controller;
  late String petID;
  late String name;
  late String image;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _controller = EditPostController(
      vsync: this,
      postEntity: widget.postEntity,
      petID: petID,
      name: name,
      image: image,
    );
    _controller.initialize();
  }

  void _initializeData() {
    petID =
        widget.postEntity.petOwner?.petId ?? CacheHelper.getData('petId') ?? '';
    name = widget.postEntity.petOwner?.petName ?? CacheHelper.getData('name') ??
        '';
    image = widget.postEntity.petOwner?.imageName != null
        ? imageUrl + widget.postEntity.petOwner!.imageName!
        : '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PostCubit>(),
        ),
        BlocProvider(
          create: (context) => CommunityCubit(),
        ),
      ],
      child: BlocListener<PostCubit, PostState>(
        listener: (context, state) =>
            _controller.handlePostStateChanges(context, state),
        child: EditPostUI(controller: _controller, widget: widget),
      ),
    );
  }
}
