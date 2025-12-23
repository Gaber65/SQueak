import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onFacebookLogin;
  final VoidCallback onGoogleLogin;
  final bool isLoadingFacebook;
  final bool isLoadingGoogle;
  final String? facebookError;
  final String? googleError;

  const SocialLoginButtons({
    super.key,
    required this.onFacebookLogin,
    required this.onGoogleLogin,
    this.isLoadingFacebook = false,
    this.isLoadingGoogle = false,
    this.facebookError,
    this.googleError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _SocialLoginButton(
          onPressed: onFacebookLogin,
          isLoading: isLoadingFacebook,
          backgroundColor: const Color(0xFF1877F2),
          icon: Image.asset(
            'assets/icons/facebook_logo.png',
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          text: 'Continue with Facebook',
          textColor: Colors.white,
          errorText: facebookError,
        ),

        const SizedBox(width: 16),

        // Google Button
        _SocialLoginButton(
          onPressed: onGoogleLogin,
          isLoading: isLoadingGoogle,
          backgroundColor: Colors.white,
          icon: Image.asset(
            'assets/icons/google_logo.png',
            width: 24,
            height: 24,
          ),
          text: 'Continue with Google',
          textColor: Colors.black87,
          borderColor: Colors.grey[300],
          errorText: googleError,
        ),
      ],
    );
  }
}

// Custom social login button widget
class _SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Widget icon;
  final String text;
  final Color textColor;
  final Color? borderColor;
  final String? errorText;

  const _SocialLoginButton({
    required this.onPressed,
    required this.isLoading,
    required this.backgroundColor,
    required this.icon,
    required this.text,
    required this.textColor,
    this.borderColor,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border:
            borderColor != null
                ? Border.all(color: borderColor!, width: 1.5)
                : null,
        boxShadow: [
          if (backgroundColor == Colors.white)
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.black.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
