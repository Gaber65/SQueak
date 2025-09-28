import 'package:flutter/material.dart';
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
    _scale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  void toggleDropdown() {
    _isOpen ? _removeOverlay() : _showOverlay();
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (_) => buildProfileSwitcherOverlay(
        context: context,
        layerLink: layerLink,
        fade: _fade,
        scale: _scale,
        onClose: _removeOverlay,
      ),
    );
    overlay.insert(_overlayEntry!);
    _isOpen = true;
    _controller.forward();
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _controller.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _isOpen = false;
      });
    }
  }

  void dispose() {
    _controller.dispose();
    _removeOverlay();
  }
}
