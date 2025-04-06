import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../layout/layout.dart';
import '../contact_us.dart';

class AuthItem extends StatelessWidget {
  const AuthItem({
    super.key,
    required this.widget,
    this.logo,
  });

  final Widget widget;
  final String? logo;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          showExitConfirmationDialog(context),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        FastCachedImage(
                          url:
                              'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/cat.png?alt=media&token=9579c991-6e61-46c3-ac91-6ba9341ebf22',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 270,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: InkWell(
                            onTap: () {
                              navigateToScreen(context, ContactScreen());
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: Card(
                              shape: CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.help,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      child: Card(
                        shape: CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                  logo ??
                                      'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/Subtract.png?alt=media&token=2498cad2-41e0-4887-8dd8-6a024d171354',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      left: logo == null
                          ? MediaQuery.of(context).size.width * .42
                          : (MediaQuery.of(context).size.width * .42) - 10,
                      top: 130,
                      right: logo == null
                          ? MediaQuery.of(context).size.width * .42
                          : (MediaQuery.of(context).size.width * .42) - 10,
                      bottom: -100,
                    ),
                  ],
                ),
                width: double.infinity,
                height: 310,
              ),
              SizedBox(
                height: 15,
              ),
              widget
            ],
          ),
        ),
      ),
    );
  }
}
