import 'package:flutter/material.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:squeak/features/layout/post/presentation/widget/post_item.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../layout/post/domain/entities/post_entity.dart';

class PostsTab extends StatefulWidget {
  final PetEntities pet;
  final bool isDarkMode;

  const PostsTab({super.key, required this.pet, required this.isDarkMode});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  bool _isGridView = true;
  int? _selectedPostIndex;

  List get _posts => widget.pet.post;

  @override
  Widget build(BuildContext context) {
    // If a post is selected, show it in single view
    if (_selectedPostIndex != null) {
      return _SinglePostView(
        pet: widget.pet,
        post: _posts[_selectedPostIndex!],
        onBack: () => setState(() => _selectedPostIndex = null),
      );
    }

    return Column(
      children: [
        _PostsHeader(
          postsCount: _posts.length,
          isGridView: _isGridView,
          onViewChanged: _toggleView,
        ),
        Expanded(
          child:
              _isGridView
                  ? _PostsGridView(
                    pet: widget.pet,
                    posts: _posts,
                    onPostTap:
                        (index) => setState(() => _selectedPostIndex = index),
                  )
                  : _PostsListView(
                    pet: widget.pet,
                    posts: _posts,
                    onPostTap:
                        (index) => setState(() => _selectedPostIndex = index),
                  ),
        ),
      ],
    );
  }

  void _toggleView(bool isGrid) {
    setState(() => _isGridView = isGrid);
  }
}

//  Single Post View
class _SinglePostView extends StatelessWidget {
  final PetEntities pet;
  final PostEntity post;
  final VoidCallback onBack;

  const _SinglePostView({
    required this.pet,
    required this.post,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with back button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
                tooltip: 'Back to posts',
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  post.title ?? 'Post',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Post content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: BuildPostItem(postItem: post, petId: pet.petId),
          ),
        ),
      ],
    );
  }
}

//Header Widget
class _PostsHeader extends StatelessWidget {
  final int postsCount;
  final bool isGridView;
  final ValueChanged<bool> onViewChanged;

  const _PostsHeader({
    required this.postsCount,
    required this.isGridView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '$postsCount ${postsCount == 1 ? 'post' : 'posts'}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          _ViewToggleButton(
            isGridView: isGridView,
            onViewChanged: onViewChanged,
          ),
        ],
      ),
    );
  }
}

// View Toggle Button
class _ViewToggleButton extends StatelessWidget {
  final bool isGridView;
  final ValueChanged<bool> onViewChanged;

  const _ViewToggleButton({
    required this.isGridView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleIconButton(
            icon: Icons.grid_view_rounded,
            isSelected: isGridView,
            onPressed: () => onViewChanged(true),
            tooltip: 'Grid View',
          ),
          Container(
            width: 1,
            height: 24,
            color: theme.dividerColor.withOpacity(0.2),
          ),
          _ToggleIconButton(
            icon: Icons.view_agenda_rounded,
            isSelected: !isGridView,
            onPressed: () => onViewChanged(false),
            tooltip: 'List View',
          ),
        ],
      ),
    );
  }
}

class _ToggleIconButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;
  final String tooltip;

  const _ToggleIconButton({
    required this.icon,
    required this.isSelected,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.blue : theme.textTheme.bodySmall?.color,
          ),
        ),
      ),
    );
  }
}

// List View
class _PostsListView extends StatelessWidget {
  final PetEntities pet;
  final List posts;
  final ValueChanged<int> onPostTap;

  const _PostsListView({
    required this.pet,
    required this.posts,
    required this.onPostTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onPostTap(index),
          child: BuildPostItem(postItem: posts[index], petId: pet.petId),
        );
      },
    );
  }
}

//  Grid View
class _PostsGridView extends StatelessWidget {
  final PetEntities pet;
  final List posts;
  final ValueChanged<int> onPostTap;

  const _PostsGridView({
    required this.pet,
    required this.posts,
    required this.onPostTap,
  });

  static const _gridSpacing = 12.0;
  static const _crossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        crossAxisSpacing: _gridSpacing,
        mainAxisSpacing: _gridSpacing,
        childAspectRatio: 1,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return _PostGridItem(
          pet: pet,
          post: posts[index],
          index: index,
          onTap: () => onPostTap(index),
        );
      },
    );
  }
}

//  Grid Item
class _PostGridItem extends StatelessWidget {
  final PetEntities pet;
  final PostEntity post;
  final int index;
  final VoidCallback onTap;

  const _PostGridItem({
    required this.pet,
    required this.post,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Theme.of(context).cardColor,
          child: _buildPostContent(context),
        ),
      ),
    );
  }

  Widget _buildPostContent(BuildContext context) {
    final images =
        post.postSocialMedia
            ?.where((e) => e.imagePath != null && e.imagePath!.isNotEmpty)
            .toList() ??
        [];

    final videos =
        post.postSocialMedia
            ?.where((e) => e.videoPath != null && e.videoPath!.isNotEmpty)
            .toList() ??
        [];

    if (images.isEmpty && videos.isEmpty) {
      return _PostPlaceholder(index: index, title: post.title);
    }

    // لو في صورة واحدة فقط
    if (images.length == 1 && videos.isEmpty) {
      return _PostImage(imagePath: images.first.imagePath!);
    }

    // لو في فيديو واحد فقط وبدون صور - نعرض thumbnail مع أيقونة play
    if (videos.length == 1 && images.isEmpty) {
      return _VideoThumbnail(videoPath: videos.first.videoPath!);
    }

    // لو في عدة صور أو فيديوهات أو خليط
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: images.length + videos.length,
      itemBuilder: (context, i) {
        if (i < images.length) {
          return _PostImage(imagePath: images[i].imagePath!);
        } else {
          final vidIndex = i - images.length;
          return _VideoThumbnail(videoPath: videos[vidIndex].videoPath!);
        }
      },
    );
  }
}

//Video Thumbnail for Grid
class _VideoThumbnail extends StatelessWidget {
  final String videoPath;

  const _VideoThumbnail({required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // يمكنك إضافة صورة thumbnail هنا إذا كانت متاحة
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Post Image
class _PostImage extends StatelessWidget {
  final String imagePath;

  const _PostImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return FastCachedImage(
      url: imageUrl + imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, exception, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }
}

//  Post Placeholder
class _PostPlaceholder extends StatelessWidget {
  final int index;
  final String? title;

  const _PostPlaceholder({required this.index, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(),
        ),
      ),
      child: Stack(
        children: [
          _buildCenterIcon(),
          if (title != null && title!.isNotEmpty) _buildTitleOverlay(),
        ],
      ),
    );
  }

  List<Color> _getGradientColors() {
    return [
      Colors.primaries[index % Colors.primaries.length].withOpacity(0.9),
      Colors.primaries[(index + 3) % Colors.primaries.length].withOpacity(0.9),
    ];
  }

  Widget _buildCenterIcon() {
    return Center(
      child: Icon(Icons.pets, size: 40, color: Colors.white.withOpacity(0.95)),
    );
  }

  Widget _buildTitleOverlay() {
    return Positioned(
      left: 8,
      right: 8,
      bottom: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}