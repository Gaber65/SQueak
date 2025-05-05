import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/version_entity.dart';

Future<dynamic> showUpdateDialog(
  BuildContext context,
  VersionEntity version,
) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Lottie.network(
              'https://lottie.host/5ebf2bcb-cdc1-40f0-a424-1f4bcf39ea89/IcNnV7PZPk.json',
              height: 200,
              width: 400,
              repeat: true,
            ),
            SizedBox(height: 10),
            Text(
              S.of(context).updateVersionModuleContent,
              maxLines: 2,
              style: FontStyleThame.textStyle(
                context: context,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 10),
            Text(
              S.of(context).updateVersionModuleContent2,
              maxLines: 2,
              style: FontStyleThame.textStyle(
                context: context,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            if (version.forceUpdate)
              SizedBox(
                height: 44,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => launchUrl(Uri.parse(version.link)),
                  child: Text(
                    S.of(context).updateVersionModuleButtonUpdateNow,
                  ),
                ),
              ),
            if (!version.forceUpdate)
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          S.of(context).updateVersionModuleButtonIgnore,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          final String iosLink =
                              "https://apps.apple.com/us/app/squeak-pets/id6739161083";
                          final String androidLink =
                              "https://play.google.com/store/apps/details?id=com.softicare.squeak&hl=en&pli=1";
                          final Uri url = Uri.parse(
                            Platform.isIOS ? iosLink : androidLink,
                          );

                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            debugPrint("Could not launch $url");
                          }
                        },
                        child: Text(
                          S.of(context).updateVersionModuleButtonUpdateNow,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    },
  ).whenComplete(() {
    if (version.forceUpdate) {
      launchUrl(Uri.parse(version.link));
    }
  });
}
