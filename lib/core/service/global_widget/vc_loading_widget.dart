import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

/// Universal loading widget for API calls
class VcLoadingIndicator extends StatelessWidget {
  const VcLoadingIndicator({
    super.key,
    this.message,
    this.size = 24.0,
    this.color,
    this.backgroundColor,
    this.overlay = false,
  });

  final String? message;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final bool overlay;

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? Theme.of(context).primaryColor;
    final bgColor = backgroundColor ?? Colors.white.withOpacity(0.9);

    Widget loadingContent = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: FontStyleThame.textStyle(
              context: context,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontColor: ColorManager.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (overlay) {
      return Container(
        color: bgColor,
        child: Center(child: loadingContent),
      );
    }

    return Center(child: loadingContent);
  }
}

/// Loading overlay for full screen coverage
class VcLoadingOverlay extends StatelessWidget {
  const VcLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
  });

  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: VcLoadingIndicator(
              message: message,
              overlay: true,
              backgroundColor: backgroundColor,
            ),
          ),
      ],
    );
  }
}

/// Shimmer loading for lists and cards
class VcShimmerLoading extends StatelessWidget {
  const VcShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      child: child,
    );
  }
}

/// Loading state helper for buttons
class VcLoadingButton extends StatelessWidget {
  const VcLoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.isLoading,
    this.width,
    this.height = 50,
    this.backgroundColor,
    this.loadingColor,
    this.borderRadius = 8,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? loadingColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: backgroundColor ?? ColorManager.primaryColor,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    loadingColor ?? Colors.white,
                  ),
                ),
              )
            : child,
      ),
    );
  }
}

/// Grid/List item shimmer placeholder
class VcShimmerListItem extends StatelessWidget {
  const VcShimmerListItem({
    super.key,
    this.height = 120,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  final double height;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return VcShimmerLoading(
      child: Container(
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
