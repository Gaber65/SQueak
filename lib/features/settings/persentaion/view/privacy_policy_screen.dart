import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io'; // Import Platform class

import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MainCubit.get(context).isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).privacyPolicy),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient:
              isDarkMode
                  ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.grey.shade900, Colors.grey.shade800],
                  )
                  : null,
          color: isDarkMode ? null : Colors.grey.shade50,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header Section
                Container(
                  decoration: Decorations.kDecorationBoxShadow(
                    context: context,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        FastCachedImage(
                          url: "https://veticareapp.com/share/logo.png",
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).privacyPolicy,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF007ACC),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${S.of(context).lastUpdated}: ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Content Sections
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          context,
                          S.of(context).infoWeCollect,
                          S.of(context).infoWeCollectDesc,
                        ),
                        _buildInfoBox(context, S.of(context).personalInfo),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).howWeUse,
                          S.of(context).howWeUseDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).infoProtection,
                          S.of(context).infoProtectionDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).sharingInfo,
                          S.of(context).sharingInfoDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).dataSecurity,
                          S.of(context).dataSecurityDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).userControl,
                          S.of(context).userControlDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).dataEncryption,
                          S.of(context).dataEncryptionDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).compliance,
                          S.of(context).complianceDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).dataRetention,
                          S.of(context).dataRetentionDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).securityAudits,
                          S.of(context).securityAuditsDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).contactPrivacy,
                          S.of(context).contactPrivacyDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).updateNotification,
                          S.of(context).updateNotificationDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).yourConsent,
                          S.of(context).yourConsentDesc,
                        ),

                        _buildDivider(),

                        _buildSection(
                          context,
                          S.of(context).contactUs,
                          S.of(context).contactUsDesc,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Footer
                Text(
                  S.of(context).copyright2,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
    );
  }

  Widget _buildInfoBox(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            MainCubit.get(context).isDark
                ? Colors.blue.shade900.withOpacity(0.3)
                : Color(0x1A007ACC),
        borderRadius: BorderRadius.circular(8),
        border: BorderDirectional(
          start: BorderSide(color: Color(0xFF007ACC), width: 3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: MainCubit.get(context).isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description) {
    const email = "support@veticare.com";
    final isDarkMode = MainCubit.get(context).isDark;

    final emailTextStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF007ACC),
      decoration: TextDecoration.underline,
    );

    final normalTextStyle = TextStyle(
      fontSize: 16,
      height: 1.5,
      color: isDarkMode ? Colors.white : Colors.black87,
    );

    final parts = description.split(email);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF007ACC),
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: parts[0], style: normalTextStyle),
              if (parts.length > 1)
                TextSpan(
                  text: email,
                  style: emailTextStyle,
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: email,
                          );
                          try {
                            final canLaunchResult = await canLaunch(
                              emailUri.toString(),
                            );
                            if (canLaunchResult) {
                              await launch(emailUri.toString());
                            } else {
                              await Clipboard.setData(
                                ClipboardData(text: email),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).emailCopied),
                                ),
                              );
                            }
                          } catch (e) {
                            print('Error launching email client: $e');
                          }
                        },
                ),
              if (parts.length > 1)
                TextSpan(text: parts[1], style: normalTextStyle),
            ],
          ),
        ),
      ],
    );
  }
}
