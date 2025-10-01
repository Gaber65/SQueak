import 'package:flutter/material.dart';
import 'package:squeak/core/network/end-points.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/features/profile_switch/Presentation/widget/component/profile_switcher_controller.dart';
import 'package:squeak/features/profile_switch/source/data/profile_local_data_source.dart';
class ProfileSwitcherButton extends StatefulWidget {
  const ProfileSwitcherButton({
    super.key,
    required this.image,
    required this.name,
  });
  final String image;
  final String name;

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

    return CompositedTransformTarget(
      link: _controller.layerLink,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: GestureDetector(
          onTap: _controller.toggleDropdown,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: NetworkImage(
                  widget.image == imageUrl ? "" : widget.image,
                ),
                child: Text(
                  widget.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
