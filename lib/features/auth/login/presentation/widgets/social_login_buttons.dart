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
    Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _SocialLoginButton(
            onPressed: onFacebookLogin,
            isLoading: isLoadingFacebook,
            backgroundColor:Colors.white,
            icon: Image.network(
              'https://1.bp.blogspot.com/-S8HTBQqmfcs/XN0ACIRD9PI/AAAAAAAAAlo/FLhccuLdMfIFLhocRjWqsr9cVGdTN_8sgCPcBGAYYCw/s1600/f_logo_RGB-Blue_1024.png',
              width: 24,
              height: 24,
            ),
            textColor: Colors.white,
            errorText: facebookError,
          ),
        ),

        const SizedBox(width: 16),

        // Google Button
        Expanded(
          child: _SocialLoginButton(
            onPressed: onGoogleLogin,
            isLoading: isLoadingGoogle,
            backgroundColor: Colors.white,
            icon: Image.network(
              'https://imagepng.org/wp-content/uploads/2019/08/google-icon.png',
              width: 24,
              height: 24,
            ),
            textColor: Colors.black87,
            borderColor: Colors.grey[300],
            errorText: googleError,
          ),
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
  final Color textColor;
  final Color? borderColor;
  final String? errorText;

  const _SocialLoginButton({
    required this.onPressed,
    required this.isLoading,
    required this.backgroundColor,
    required this.icon,
    required this.textColor,
    this.borderColor,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 40,
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
          child: icon,
        ),
      ),
    );
  }
}
