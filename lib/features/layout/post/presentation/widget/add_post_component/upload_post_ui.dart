import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../../../../../core/utils/theme/color_mangment/color_manager.dart'
    show ColorManager;
import '../../community/controller/community_cubit.dart';
import '../../screens/upload_post.dart';
import 'upload_post_controller.dart';

class UploadPostUI extends StatelessWidget {
  final UploadPostController controller;
  final UploadPost widget;

  const UploadPostUI({
    super.key,
    required this.controller,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:
          () => controller.onWillPop(context, CommunityCubit.get(context)),
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
    final bool hasContent =
        controller.textContentEditingController.text.trim().isNotEmpty ||
        cubit.mediaFiles.isNotEmpty;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: _buildLeadingButton(context, cubit),
      title: _buildAppBarTitle(),
      centerTitle: true,
      actions: [_buildPostButton(hasContent, context, cubit)],
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
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorManager.primaryColor,
            ),
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
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.grey[800],
          size: 18,
        ),
      ),
      onPressed: () => controller.handleClose(context, cubit),
      splashRadius: 24,
    );
  }

  Widget _buildAppBarTitle() {
    return Text(
      'Create Post',
      style: TextStyle(
        color: Colors.grey[900],
        fontSize: 19,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildPostButton(
    bool hasContent,
    BuildContext context,
    CommunityCubit cubit,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: TextButton(
          onPressed:
              hasContent && !controller.isLoading
                  ? () => controller.handlePostSubmit(context, cubit)
                  : null,
          style: TextButton.styleFrom(
            backgroundColor:
                hasContent && !controller.isLoading
                    ? ColorManager.primaryColor
                    : Colors.grey[300],
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.grey[500],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: hasContent && !controller.isLoading ? 2 : 0,
            shadowColor: ColorManager.primaryColor.withOpacity(0.3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.isLoading) ...[
                SizedBox(
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
                controller.isLoading ? 'Posting...' : 'Post',
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
                if (cubit.mediaFiles.isNotEmpty) ...[
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
          // _buildTextField(),
          // const SizedBox(height: 10),
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
                widget.name,
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
      tag: 'pet_avatar_${widget.petID}',
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
            image: DecorationImage(
              image: NetworkImage(widget.image),
              fit: BoxFit.cover,
            ),
          ),
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
            'Public',
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
      textDirection: controller.getTextDirection(
        controller.textContentEditingController.text,
      ),
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[900],
        height: 1.6,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: 'What\'s on your mind, ${widget.name.split(' ').first}?',
        hintStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey[400],
          fontWeight: FontWeight.w400,
        ),
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
          children: [_buildMediaGrid(cubit), _buildMediaInfo(cubit)],
        ),
      ),
    );
  }

  Widget _buildMediaGrid(CommunityCubit cubit) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cubit.mediaFiles.length == 1 ? 1 : 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: cubit.mediaFiles.length > 4 ? 4 : cubit.mediaFiles.length,
      itemBuilder: (context, index) {
        if (index == 3 && cubit.mediaFiles.length > 4) {
          return _buildMoreItemsOverlay(
            cubit.mediaFiles.length - 4,
            cubit,
            index,
          );
        }
        return _buildMediaItem(cubit, index);
      },
    );
  }

  Widget _buildMediaItem(CommunityCubit cubit, int index) {
    final isUploading = controller.isLoading;

    return Stack(
      children: [
        Container(
          color: Colors.grey[200],
          child:
              cubit.mediaTypes[index] == 'image'
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
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),

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
              child: const Text(
                'VIDEO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMoreItemsOverlay(
    int remainingCount,
    CommunityCubit cubit,
    int index,
  ) {
    return Stack(
      children: [
        _buildMediaItem(cubit, index),
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

  Widget _buildMediaInfo(CommunityCubit cubit) {
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
          Text(
            '${cubit.mediaFiles.length} media files selected',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (cubit.mediaFiles.length > 4)
            Text(
              '+${cubit.mediaFiles.length - 4} more',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsSection(
    BuildContext context,
    CommunityCubit cubit,
  ) {
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
                    'Add to your post',
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
              if (cubit.mediaFiles.isNotEmpty) ...[
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
    final imageCount = cubit.mediaTypes.where((type) => type == 'image').length;
    final videoCount = cubit.mediaTypes.where((type) => type == 'video').length;

    return Row(
      children: [
        if (imageCount > 0) ...[
          Row(
            children: [
              Icon(Icons.photo, size: 16, color: Colors.green[600]),
              const SizedBox(width: 4),
              Text('$imageCount photo${imageCount > 1 ? 's' : ''}'),
            ],
          ),
        ],
        if (videoCount > 0) ...[
          if (imageCount > 0) const SizedBox(width: 16),
          Row(
            children: [
              Icon(Icons.videocam, size: 16, color: Colors.red[600]),
              const SizedBox(width: 4),
              Text('$videoCount video${videoCount > 1 ? 's' : ''}'),
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
          label: 'Photos',
          color: const Color(0xFF10B981),
          onTap: () {
            if (controller.isLoading) return;
            controller.pickMultipleImages(cubit, context);
          },
        ),
        const SizedBox(width: 10),
        _buildMediaActionButton(
          icon: Icons.videocam_rounded,
          label: 'Videos',
          color: const Color(0xFFEF4444),
          onTap: () {
            if (controller.isLoading) return;
            controller.pickMultipleVideos(cubit, context);
          },
        ),
        const SizedBox(width: 10),
        if (cubit.mediaFiles.isNotEmpty && !controller.isLoading)
          _buildMediaActionButton(
            icon: Icons.clear_all,
            label: 'Clear All',
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
