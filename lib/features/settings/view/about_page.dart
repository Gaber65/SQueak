import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:squeak/features/settings/controller/about_cubit.dart';
import 'package:squeak/features/settings/controller/about_state.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'dart:io'; // Import Platform class



class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  void _launchURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic() ? 'عن' : "About"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),

              // Company Logo
              Image.network(
                "https://quadinsight.com/share/Qilogo.png", // Replace with actual logo
                height: 100,
              ),
              SizedBox(height: 20),

              // Company Name
              Text(
                "Quad insight",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              // App Version from Cubit
              BlocBuilder<AboutCubit, AboutState>(
                builder: (context, state) {
                  if (state is AboutLoading) {
                    return CircularProgressIndicator();
                  } else if (state is AboutLoaded) {
                    return Text(
                      "Version: ${state.version} (${Platform.isAndroid ? "Android" : "iOS"})",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    );
                  } else {
                    return Text("Failed to load version");
                  }
                },
              ),
              SizedBox(height: 30),

              // Trademark & Privacy Links
              ListTile(
                leading: Icon(Icons.verified),
                title: Text(isArabic() ? 'معلومات العلامة التجارية' :"Trademark Information"),
                onTap: () => _launchURL("https://quadinsight.com", context),
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text(isArabic() ? 'سياسة الخصوصية' :"Privacy Policy"),
                onTap: () => _launchURL("https://quadinsight.com/privacy", context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}