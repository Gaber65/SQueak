import 'package:flutter/material.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/features/profile_switch/Presentation/widget/component/profile_switcher_controller.dart';
import 'package:squeak/features/profile_switch/source/data/profile_local_data_source.dart';

class ProfileSwitcherButton extends StatefulWidget {
  const ProfileSwitcherButton({
    super.key,
    required this.image,
    required this.name,
    this.width = 40,
    this.height = 40,
  });
  final String image;
  final String name;
  final double width;
  final double height;

  @override
  State<ProfileSwitcherButton> createState() => _ProfileSwitcherButtonState();
}

class _ProfileSwitcherButtonState extends State<ProfileSwitcherButton>
    with SingleTickerProviderStateMixin {
  late final ProfileSwitcherController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileSwitcherController(context, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CacheHelper.getData(activeProfileKey);

    final hasImage = widget.image.isNotEmpty && widget.image != imageUrl;

    return CompositedTransformTarget(
      link: _controller.layerLink,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: GestureDetector(
          onTap: _handleButtonTap,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.blueAccent, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: const Color(0xFFFF6B9D).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child:
                  hasImage
                      ? ClipOval(
                        child: Container(
                          width: widget.width - 4,
                          height: widget.height - 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              widget.image,
                              width: widget.width - 7,
                              height: widget.height - 7,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.pets,
                                    color: Colors.white,
                                  ),
                                );
                              },
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                      strokeWidth: 2,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                      : SizedBox(
                        width: widget.width - 4,
                        height: widget.height - 4,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: widget.width * 0.4,
                              ),
                            ),
                          ),
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
  void _handleButtonTap() {
  _controller.toggleDropdown();
  
}
}


