import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeak/features/layout/post/presentation/community/controller/community_cubit.dart';
import '../../../../../core/service/global_widget/custom_text_form_field.dart';
import '../../../../../generated/l10n.dart';
import '../../../../profile_switch/Presentation/cubit/switch_profile_cubit.dart';
import '../screens/upload_post.dart';
import 'get_posts_when_user_follow.dart';

Widget buildWhatsonyourmindSanjay(BuildContext context, String petId) {
  final switchProfileCubit = SwitchProfileCubit.get(context);

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildProfileAvatar(switchProfileCubit),
        Expanded(
          child: _buildPostInputField(context, petId, switchProfileCubit),
        ),
        _buildGalleryButton(context, petId, switchProfileCubit),
      ],
    ),
  );
}

Widget _buildProfileAvatar(SwitchProfileCubit cubit) {
  return CircleAvatar(
    backgroundColor: Colors.blue,
    child:
        cubit.image.isNotEmpty
            ? _buildFastCachedImageProvider(cubit)
            : _buildInitialText(cubit),
  );
}

Widget _buildFastCachedImageProvider(SwitchProfileCubit cubit) {
  return ClipOval(
    child: SafeFastCachedImageExtension.safe(
      url: cubit.image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => _buildInitialText(cubit),
    ),
  );
}

Widget _buildInitialText(SwitchProfileCubit cubit) {
  return Center(
    child: Text(
      cubit.name.isNotEmpty ? cubit.name[0].toUpperCase() : '',
      style: const TextStyle(color: Colors.white),
    ),
  );
}

Widget _buildPostInputField(
  BuildContext context,
  String petId,
  SwitchProfileCubit cubit,
) {
  return Padding(
    padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8),
    child: SizedBox(
      height: 38,
      child: InkWell(
        onTap: () => _handlePostInputTap(context, petId, cubit),
        child: IgnorePointer(
          ignoring: true,
          child: MyTextForm(
            controller: TextEditingController(),
            hintText: S.of(context).labelPost,
            obscureText: false,
            enable: false,
          ),
        ),
      ),
    ),
  );
}

Widget _buildGalleryButton(
  BuildContext context,
  String petId,
  SwitchProfileCubit cubit,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadiusDirectional.circular(12),
      ),
      child: IconButton(
        onPressed: () => _handleGalleryButtonPress(context, petId, cubit),
        icon: const Icon(IconlyLight.image, size: 16),
      ),
    ),
  );
}

void _handlePostInputTap(
  BuildContext context,
  String petId,
  SwitchProfileCubit cubit,
) {
  if (petId.isEmpty) {
    showGuideOverlay(context);
    return;
  }
  _navigateToUploadPost(context, cubit);
}

Future<void> _handleGalleryButtonPress(
  BuildContext context,
  String petId,
  SwitchProfileCubit cubit,
) async {
  if (petId.isEmpty) {
    showGuideOverlay(context);
    return;
  }

  final communityCubit = CommunityCubit();
  await communityCubit.pickMixedMedia(context: context, source: ImageSource.gallery);

  if (communityCubit.mediaFiles.isNotEmpty && context.mounted) {
    _navigateToUploadPostWithCubit(context, cubit, communityCubit);
  }
}

void _navigateToUploadPost(BuildContext context, SwitchProfileCubit cubit) {
  Navigator.push(
    context,
    DialogRoute(
      context: context,
      builder:
          (context) => UploadPost(
            petID: cubit.petID,
            image: cubit.image,
            name: cubit.name,
          ),
    ),
  );
}

void _navigateToUploadPostWithCubit(
  BuildContext context,
  SwitchProfileCubit cubit,
  CommunityCubit communityCubit,
) {
  Navigator.push(
    context,
    DialogRoute(
      context: context,
      builder:
          (newContext) => BlocProvider<CommunityCubit>.value(
            value: communityCubit,
            child: Builder(
              builder:
                  (ctx) => UploadPost(
                    petID: cubit.petID,
                    image: cubit.image,
                    name: cubit.name,
                  ),
            ),
          ),
    ),
  );
}
