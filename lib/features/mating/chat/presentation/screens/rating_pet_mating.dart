import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../domain/usecases/parameters.dart';
import '../controllers/chat_messages_cubit.dart';

class PetMatingRatingScreen extends StatefulWidget {
  final String matingId;
  final ChatMessagesCubit cubit;

  const PetMatingRatingScreen({
    super.key,
    required this.matingId,
    required this.cubit,
  });

  @override
  State<PetMatingRatingScreen> createState() => _PetMatingRatingScreenState();
}

class _PetMatingRatingScreenState extends State<PetMatingRatingScreen>
    with SingleTickerProviderStateMixin {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 160),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _onStarTap(int index) {
    setState(() => _rating = index);
    _animationController.forward().then((_) => _animationController.reverse());
  }

  Future<void> _submitRating() async {
    final s = S.of(context);

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.pleaseSelectRating),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    widget.cubit.rateMating(
      RateMatingParameters(
        matingId: widget.matingId,
        rate: _rating,
        rateComment: _commentController.text.trim(),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: _surfaceGradientBackground(theme),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(theme, s),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _headerCard(theme, s, cs),
                    const SizedBox(height: 20),
                    _ratingCard(theme, s, cs),
                    const SizedBox(height: 20),
                    _commentCard(theme, s, cs),
                    const SizedBox(height: 24),
                    _submitButton(theme, s),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Top bar
  Widget _buildTopBar(ThemeData theme, S s) {
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: Icon(Icons.arrow_back, color: cs.primary),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          _glassChip(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.pets, color: cs.primary, size: 16),
                const SizedBox(width: 6),
                Text(
                  s.matingSession,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header
  Widget _headerCard(ThemeData theme, S s, ColorScheme cs) {
    return _glassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  cs.primaryContainer.withOpacity(0.4),
                  cs.tertiaryContainer.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(Icons.favorite, size: 40, color: cs.secondary),
          ),
          const SizedBox(height: 16),
          Text(
            s.rateYourExperience,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            s.howWasMatingSession,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // Rating
  Widget _ratingCard(ThemeData theme, S s, ColorScheme cs) {
    return _glassCard(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        children: [
          Text(
            s.tapToRate,
            style: theme.textTheme.titleMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isSelected = starIndex <= _rating;
              return Semantics(
                label: '${s.tapToRate} $starIndex',
                selected: isSelected,
                button: true,
                child: GestureDetector(
                  onTap: () => _onStarTap(starIndex),
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      final scale =
                          isSelected && _rating == starIndex
                              ? _scaleAnimation.value
                              : 1.0;
                      return Transform.scale(
                        scale: scale,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            isSelected
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 42,
                            color:
                                isSelected ? cs.secondary : cs.outlineVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          AnimatedOpacity(
            opacity: _rating > 0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              _getRatingTextLocalized(_rating, s),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _getRatingColor(_rating, cs),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Comment
  Widget _commentCard(ThemeData theme, S s, ColorScheme cs) {
    return _glassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.comment_rounded, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                s.shareYourThoughts,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: 5,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: s.tellUsAboutExperience,
              filled: true,
              fillColor: cs.surface.withOpacity(0.4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: cs.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: cs.primary, width: 1.8),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  // Submit button
  Widget _submitButton(ThemeData theme, S s) {
    final cs = theme.colorScheme;
    return FilledButton.tonal(
      onPressed: _isSubmitting ? null : _submitRating,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child:
            _isSubmitting
                ? SizedBox(
                  key: const ValueKey('loading'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: cs.onPrimaryContainer,
                  ),
                )
                : Text(
                  s.submitRating,
                  key: const ValueKey('text'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }

  // Glassmorphism helpers
  Widget _glassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withOpacity(0.3),
            ),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface.withOpacity(0.50),
                Theme.of(context).colorScheme.surface.withOpacity(0.30),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  Widget _glassChip({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withOpacity(0.25),
            ),
            color: Theme.of(context).colorScheme.surface.withOpacity(0.35),
          ),
          child: child,
        ),
      ),
    );
  }

  // Colors and texts
  Color _getRatingColor(int rating, ColorScheme cs) {
    if (rating <= 2) return cs.error;
    if (rating == 3) return cs.tertiary;
    return cs.secondary;
  }

  String _getRatingTextLocalized(int rating, S s) {
    switch (rating) {
      case 1:
        return s.poorExperience;
      case 2:
        return s.belowAverage;
      case 3:
        return s.goodExperience;
      case 4:
        return s.greatExperience;
      case 5:
        return s.excellentExperience;
      default:
        return '';
    }
  }

  // Background surface gradient (dark/light aware)
  Color _surfaceGradientBackground(ThemeData theme) {
    final cs = theme.colorScheme;
    // Use a subtle tinted background to blend with glass cards
    return Color.alphaBlend(cs.primaryContainer.withOpacity(0.05), cs.surface);
  }
}
