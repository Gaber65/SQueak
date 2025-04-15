import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:squeak/features/settings/controller/about_cubit.dart';
import 'package:squeak/features/settings/controller/about_state.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'dart:io';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  Future<void> _launchURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic() ? 'تعذر فتح الرابط' : "Could not open link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return BlocProvider(
      create: (context) => AboutCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic() ? 'عن التطبيق' : "About"),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo with Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.network(
                    "https://quadinsight.com/share/Qilogo.png",
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Company Name
              Text(
                "Quad Insight",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),

              // App Version
              BlocBuilder<AboutCubit, AboutState>(
                builder: (context, state) {
                  if (state is AboutLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is AboutLoaded) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[800]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${isArabic() ? 'الإصدار' : 'Version'} ${state.version} (${Platform.isAndroid ? "Android" : "iOS"})",
                        style: textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? Colors.white
                              : Colors.grey[700],
                        ),
                      ),
                    );
                  } else {
                    return Text(
                      isArabic() ? 'فشل تحميل الإصدار' : "Failed to load version",
                      style: TextStyle(color: Colors.red),
                    );
                  }
                },
              ),
              const SizedBox(height: 32),

              // Links Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // Trademark Information
                    _buildLinkTile(
                      context,
                      icon: Icons.branding_watermark,
                      title: isArabic() ? 'معلومات العلامة التجارية' : "Trademark Information",
                      url: "https://quadinsight.com",
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),

                    // Privacy Policy
                    _buildLinkTile(
                      context,
                      icon: Icons.privacy_tip,
                      title: isArabic() ? 'سياسة الخصوصية' : "Privacy Policy",
                      url: "https://quadinsight.com/privacy",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Footer Text
              Text(
                isArabic() ? '© 2023 Quad Insight. جميع الحقوق محفوظة' : "© 2023 Quad Insight. All rights reserved",
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkTile(BuildContext context, {
    required IconData icon,
    required String title,
    required String url,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () => _launchURL(url, context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}