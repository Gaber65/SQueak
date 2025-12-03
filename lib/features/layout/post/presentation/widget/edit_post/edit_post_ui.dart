import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../community/controller/community_cubit.dart';
import '../../screens/edit_post_screen.dart';
import 'edit_post_controller.dart';

class EditPostUI extends StatelessWidget {
  final EditPostController controller;
  final EditPostScreen widget;

  const EditPostUI({
    super.key,
    required this.controller,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.onWillPop(context, CommunityCubit.get(context)),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocBuilder<CommunityCubit, CommunityState>(
          builder: (context, state) {
            final cubit = CommunityCubit.get(context);
            return Scaffold(
              backgroundColor: const Color(0xFFF5F7FA),
              appBar: _buildAppBar(context, cubit),
              body: _buildAnimatedBody(context, cubit),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, CommunityCubit cubit) {
    final bool hasChanges = controller.textContentEditingController.text.trim() !=
        (widget.postEntity.content ?? '') ||
        cubit.mediaFiles.isNotEmpty ||
        controller.existingMedia.length != (widget.postEntity.postSocialMedia?.length ?? 0);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: _buildLeadingButton(context, cubit),
      title: _buildAppBarTitle(),
      centerTitle: true,
      actions: [_buildUpdateButton(hasChanges, context, cubit)],
      bottom: _buildAppBarDivider(),
    );
  }

  Widget _buildLeadingButton(BuildContext context, CommunityCubit cubit) {
    if (controller.isLoading) {
      return Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primaryColor),
          ),
        ),
      );
    }

    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey[800], size: 18),
      ),
      onPressed: () => controller.handleClose(context, cubit),
      splashRadius: 24,
    );
  }

  Widget _buildAppBarTitle() {
    return Text(
      isArabic() ? 'تعديل المنشور' : 'Edit Post',
      style: TextStyle(
        color: Colors.grey[900],
        fontSize: 19,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildUpdateButton(bool hasChanges, BuildContext context, CommunityCubit cubit) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: TextButton(
          onPressed: hasChanges && !controller.isLoading
              ? () => controller.handlePostUpdate(context, cubit)
              : null,
          style: TextButton.styleFrom(
            backgroundColor: hasChanges && !controller.isLoading
                ? ColorManager.primaryColor
                : Colors.grey[300],
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.grey[500],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: hasChanges && !controller.isLoading ? 2 : 0,
            shadowColor: ColorManager.primaryColor.withOpacity(0.3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.isLoading) ...[
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                controller.isLoading
                    ? (isArabic() ? 'جاري التحديث...' : 'Updating...')
                    : (isArabic() ? 'حفظ' : 'Save'),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _buildAppBarDivider() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[200]!, Colors.grey[300]!, Colors.grey[200]!],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBody(BuildContext context, CommunityCubit cubit) {
    return FadeTransition(
      opacity: controller.fadeAnimation,
      child: SlideTransition(
        position: controller.slideAnimation,
        child: _buildBody(context, cubit),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CommunityCubit cubit) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildTextInputSection(cubit),
                if (controller.getTotalMediaCount(cubit) > 0) ...[
                  const SizedBox(height: 16),
                  _buildMediaPreview(cubit),
                ],
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        _buildActionButtonsSection(context, cubit),
      ],
    );
  }

  Widget _buildTextInputSection(CommunityCubit cubit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          const SizedBox(height: 20),
          _buildTextFieldContent(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.name,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[900],
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              _buildPrivacyBadge(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Hero(
      tag: 'pet_avatar_edit_${controller.petID}',
      child: Container(
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              ColorManager.primaryColor,
              ColorManager.primaryColor.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            image: controller.image.isNotEmpty
                ? DecorationImage(image: NetworkImage(controller.image), fit: BoxFit.cover)
                : null,
          ),
          child: controller.image.isEmpty
              ? Icon(Icons.pets, color: Colors.grey[400], size: 28)
              : null,
        ),
      ),
    );
  }

  Widget _buildPrivacyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue[50]!, Colors.blue[100]!]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.public_rounded, size: 14, color: Colors.blue[800]),
          const SizedBox(width: 5),
          Text(
            isArabic() ? 'عام' : 'Public',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.blue[800],
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldContent() {
    return TextField(
      controller: controller.textContentEditingController,
      maxLines: null,
      minLines: 5,
      maxLength: 1000,
      textDirection: controller.getTextDirection(controller.textContentEditingController.text),
      style: TextStyle(fontSize: 16, color: Colors.grey[900], height: 1.6, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        hintText: isArabic()
            ? 'ماذا يدور في ذهنك، ${controller.name.split(' ').first}؟'
            : "What's on your mind, ${controller.name.split(' ').first}?",
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey[400], fontWeight: FontWeight.w400),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        counterText: '',
      ),
      onChanged: (text) => controller.setState(() {}),
    );
  }

  Widget _buildMediaPreview(CommunityCubit cubit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            _buildMediaGrid(cubit),
            _buildMediaInfo(cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaGrid(CommunityCubit cubit) {
    final totalMedia = controller.getTotalMediaCount(cubit);
    final displayCount = totalMedia > 4 ? 4 : totalMedia;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: totalMedia == 1 ? 1 : 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: displayCount,
      itemBuilder: (context, index) {
        if (index == 3 && totalMedia > 4) {
          return _buildMoreItemsOverlay(totalMedia - 4, cubit, index);
        }

        // Show existing media first
        if (index < controller.existingMedia.length) {
          return _buildExistingMediaItem(controller.existingMedia[index], index);
        }

        // Then show new media
        final newMediaIndex = index - controller.existingMedia.length;
        return _buildNewMediaItem(cubit, newMediaIndex);
      },
    );
  }

  Widget _buildExistingMediaItem(ExistingMediaItem media, int index) {
    return Stack(
      children: [
        Container(
          color: Colors.grey[200],
          child: media.type == 'image'
              ? FastCachedImage(
            url: imageUrl + media.path,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Icon(Icons.broken_image, color: Colors.grey[600]),
              );
            },
          )
              : _buildVideoPlaceholder(),
        ),

        // Remove button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: controller.isLoading ? null : () => controller.removeExistingMedia(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: controller.isLoading ? Colors.grey : Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),

        // Video badge
        if (media.type == 'video')
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isArabic() ? 'فيديو' : 'VIDEO',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Network badge
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_done, color: Colors.white, size: 10),
                const SizedBox(width: 2),
                Text(
                  isArabic() ? 'محفوظ' : 'SAVED',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewMediaItem(CommunityCubit cubit, int index) {
    final isUploading = controller.isLoading;

    return Stack(
      children: [
    Container(
    color: Colors.grey[200],
      child: cubit.mediaTypes[index] == 'image'
          ? Image.file(
        cubit.mediaFiles[index],
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      )
          : _buildVideoThumbnail(cubit.mediaFiles[index]),
    ),

    // Upload overlay
    if (isUploading)
    Container(
    color: Colors.black54,
    child: const Center(
    child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    ),
    ),

    ),

        // Remove button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: controller.isLoading ? null : () => cubit.removeMedia(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: controller.isLoading ? Colors.grey : Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),

        // Video badge
        if (cubit.mediaTypes[index] == 'video')
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isArabic() ? 'فيديو' : 'VIDEO',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // New badge
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange[700],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isArabic() ? 'جديد' : 'NEW',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreItemsOverlay(int remainingCount, CommunityCubit cubit, int index) {
    if (index < controller.existingMedia.length) {
      return Stack(
        children: [
          _buildExistingMediaItem(controller.existingMedia[index], index),
          Container(
            color: Colors.black54,
            child: Center(
              child: Text(
                '+$remainingCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    final newMediaIndex = index - controller.existingMedia.length;
    return Stack(
      children: [
        _buildNewMediaItem(cubit, newMediaIndex),
        Container(
          color: Colors.black54,
          child: Center(
            child: Text(
              '+$remainingCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoThumbnail(File videoFile) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Icon(Icons.play_circle_filled, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Icon(Icons.play_circle_filled, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildMediaInfo(CommunityCubit cubit) {
    final totalMedia = controller.getTotalMediaCount(cubit);
    final existingCount = controller.existingMedia.length;
    final newCount = cubit.mediaFiles.length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Icon(Icons.photo_library, color: Colors.grey[600], size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isArabic()
                  ? '$totalMedia ملف وسائط'
                  : '$totalMedia media file${totalMedia > 1 ? 's' : ''}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (existingCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_done, size: 12, color: Colors.green[700]),
                  const SizedBox(width: 4),
                  Text(
                    '$existingCount ${isArabic() ? 'محفوظ' : 'saved'}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          if (newCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_circle, size: 12, color: Colors.orange[700]),
                  const SizedBox(width: 4),
                  Text(
                    '$newCount ${isArabic() ? 'جديد' : 'new'}',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtonsSection(BuildContext context, CommunityCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    isArabic() ? 'إضافة إلى منشورك' : 'Add to your post',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                      letterSpacing: -0.2,
                    ),
                  ),
                  const Spacer(),
                  _buildMediaActionButtons(cubit, context),
                ],
              ),
              if (controller.getTotalMediaCount(cubit) > 0) ...[
                const SizedBox(height: 12),
                _buildMediaStats(cubit),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaStats(CommunityCubit cubit) {
    final existingImages =
        controller.existingMedia.where((m) => m.type == 'image').length;
    final existingVideos =
        controller.existingMedia.where((m) => m.type == 'video').length;
    final newImages = cubit.mediaTypes.where((type) => type == 'image').length;
    final newVideos = cubit.mediaTypes.where((type) => type == 'video').length;

    final totalImages = existingImages + newImages;
    final totalVideos = existingVideos + newVideos;

    return Row(
      children: [
        if (totalImages > 0) ...[
          Row(
            children: [
              Icon(Icons.photo, size: 16, color: Colors.green[600]),
              const SizedBox(width: 4),
              Text(
                '$totalImages ${isArabic() ? 'صورة' : 'photo${totalImages > 1 ? 's' : ''}'}',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
        if (totalVideos > 0) ...[
          if (totalImages > 0) const SizedBox(width: 16),
          Row(
            children: [
              Icon(Icons.videocam, size: 16, color: Colors.red[600]),
              const SizedBox(width: 4),
              Text(
                '$totalVideos ${isArabic() ? 'فيديو' : 'video${totalVideos > 1 ? 's' : ''}'}',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMediaActionButtons(CommunityCubit cubit, BuildContext context) {
    return Row(
      children: [
        _buildMediaActionButton(
          icon: IconlyBold.image,
          label: isArabic() ? 'صور' : 'Photos',
          color: const Color(0xFF10B981),
          onTap: () {
            if (controller.isLoading) return;
            controller.pickMultipleImages(cubit, context);
          },
        ),
        const SizedBox(width: 10),
        _buildMediaActionButton(
          icon: Icons.videocam_rounded,
          label: isArabic() ? 'فيديو' : 'Videos',
          color: const Color(0xFFEF4444),
          onTap: () {
            if (controller.isLoading) return;
            controller.pickMultipleVideos(cubit, context);
          },
        ),
        const SizedBox(width: 10),
        if (controller.getTotalMediaCount(cubit) > 0 && !controller.isLoading)
          _buildMediaActionButton(
            icon: Icons.delete_outline,
            label: isArabic() ? 'مسح الكل' : 'Clear All',
            color: Colors.orange,
            onTap: () => controller.clearAllMedia(cubit),
          ),
      ],
    );
  }

  Widget _buildMediaActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: controller.isLoading ? Colors.grey[400] : color,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
