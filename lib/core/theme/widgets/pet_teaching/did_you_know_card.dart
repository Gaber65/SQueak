// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../app_theme.dart';

/// "Did You Know?" cards for pet care education
class DidYouKnowCard extends StatefulWidget {
  const DidYouKnowCard({
    super.key,
    required this.title,
    required this.content,
    this.category,
    this.imageUrl,
    this.onDismiss,
    this.isDismissible = true,
  });

  final String title;
  final String content;
  final DidYouKnowCategory? category;
  final String? imageUrl;
  final VoidCallback? onDismiss;
  final bool isDismissible;

  /// Factory for health tips
  factory DidYouKnowCard.health({
    Key? key,
    required String title,
    required String content,
    String? imageUrl,
    VoidCallback? onDismiss,
  }) {
    return DidYouKnowCard(
      key: key,
      title: title,
      content: content,
      category: DidYouKnowCategory.health,
      imageUrl: imageUrl,
      onDismiss: onDismiss,
    );
  }

  /// Factory for nutrition tips
  factory DidYouKnowCard.nutrition({
    Key? key,
    required String title,
    required String content,
    String? imageUrl,
    VoidCallback? onDismiss,
  }) {
    return DidYouKnowCard(
      key: key,
      title: title,
      content: content,
      category: DidYouKnowCategory.nutrition,
      imageUrl: imageUrl,
      onDismiss: onDismiss,
    );
  }

  /// Factory for behavior tips
  factory DidYouKnowCard.behavior({
    Key? key,
    required String title,
    required String content,
    String? imageUrl,
    VoidCallback? onDismiss,
  }) {
    return DidYouKnowCard(
      key: key,
      title: title,
      content: content,
      category: DidYouKnowCategory.behavior,
      imageUrl: imageUrl,
      onDismiss: onDismiss,
    );
  }

  @override
  State<DidYouKnowCard> createState() => _DidYouKnowCardState();
}

class _DidYouKnowCardState extends State<DidYouKnowCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryInfo = _getCategoryInfo(widget.category, theme);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        border: Border.all(
          color: categoryInfo.color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radius16),
              topRight: Radius.circular(AppTheme.radius16),
            ),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: categoryInfo.color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radius16),
                  topRight: Radius.circular(AppTheme.radius16),
                ),
              ),
              child: Row(
                children: [
                  Icon(categoryInfo.icon, color: categoryInfo.color, size: 24),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Did You Know?',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: categoryInfo.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing4),
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.isDismissible)
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: widget.onDismiss,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _slideAnimation.value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.content, style: theme.textTheme.bodyMedium),
                  if (widget.imageUrl != null) ...[
                    const SizedBox(height: AppTheme.spacing16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radius8),
                      child: Image.network(
                        widget.imageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            color: theme.colorScheme.surfaceVariant,
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _CategoryInfo _getCategoryInfo(
    DidYouKnowCategory? category,
    ThemeData theme,
  ) {
    switch (category) {
      case DidYouKnowCategory.health:
        return _CategoryInfo(
          color: AppTheme.petHealthyColor,
          icon: Icons.favorite,
        );
      case DidYouKnowCategory.nutrition:
        return _CategoryInfo(
          color: const Color(0xFFFF9800),
          icon: Icons.restaurant,
        );
      case DidYouKnowCategory.behavior:
        return _CategoryInfo(
          color: const Color(0xFF9C27B0),
          icon: Icons.psychology,
        );
      case DidYouKnowCategory.safety:
        return _CategoryInfo(
          color: AppTheme.petEmergencyColor,
          icon: Icons.security,
        );
      case DidYouKnowCategory.grooming:
        return _CategoryInfo(color: const Color(0xFF00BCD4), icon: Icons.spa);
      case null:
        return _CategoryInfo(
          color: theme.colorScheme.primary,
          icon: Icons.lightbulb,
        );
    }
  }
}

/// Categories for Did You Know cards
enum DidYouKnowCategory { health, nutrition, behavior, safety, grooming }

/// Internal category information
class _CategoryInfo {
  const _CategoryInfo({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}
