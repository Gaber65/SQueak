import 'package:flutter/material.dart';
import 'package:squeak/features/settings/persentaion/controller/setting_cubit.dart';
import 'profile_switcher_overlay.dart';

class ProfileSwitcherController {
  final BuildContext context;
  final TickerProvider vsync;
  final LayerLink layerLink = LayerLink();

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  ProfileSwitcherController(this.context, {required this.vsync}) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 200),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  bool get isOpen => _isOpen;

  void toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _ensureOwnerDataLoaded();
      _showOverlay();
    }
  }

  void _ensureOwnerDataLoaded() {
    final settingCubit = SettingCubit.get(context);
    // If profile is null, it means it hasn't been loaded yet, so fetch it
    if (settingCubit.profile == null) {
      settingCubit.getOwnerData();
    }
  }

  void _showOverlay() {
    if (!mounted) return;
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder:
          (_) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _removeOverlay,
                  child: Container(color: Colors.transparent),
                ),
              ),
              buildProfileSwitcherOverlay(
                context: context,
                layerLink: layerLink,
                fade: _fade,
                scale: _scale,
                onClose: _removeOverlay,
              ),
            ],
          ),
    );

    overlay.insert(_overlayEntry!);
    _isOpen = true;
    _controller.forward();
  }

  void showTemporaryOverlay({Duration duration = const Duration(seconds: 2)}) {
    if (!mounted) return;
    _showOverlay();
    Future.delayed(duration, () {
      if (_isOpen) _removeOverlay();
    });
  }

  void _removeOverlay() {
    if (_overlayEntry != null && _isOpen) {
      _isOpen = false;
      _controller.reverse().then((_) {
        if (_overlayEntry != null) {
          _overlayEntry?.remove();
          _overlayEntry = null;
        }
      });
    }
  }

  void dispose() {
    _controller.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void closeDropdown() => _removeOverlay();

  bool get mounted =>
      context.mounted; // Use extension for safety in Flutter >=3.7
}
