import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

import 'package:squeak/features/QR/view/follow-confirmation_screen.dart';
import 'package:squeak/features/QR/view/qr_register_screen.dart';
import 'package:squeak/features/vetcare/view/vetCareRegister.dart';

import '../../../../utils/export_path/export_files.dart';

void initDeepLinkHandler(
    GlobalKey<NavigatorState> navigatorKey,
    StreamSubscription? sub,
    void Function(Uri) onUri,
    ) {
  final appLinks = AppLinks();

  if (!kIsWeb) {
    sub = appLinks.uriLinkStream.listen(
          (Uri? uri) {
        if (uri != null) onUri(uri);
      },
      onError: (err) => print('Deep link error: $err'),
    );
  }

  appLinks.getInitialLink().then((uri) {
    if (uri != null) onUri(uri);
  }).catchError((err) {
    print('Initial link error: $err');
  });
}

void handleDeepLink(Uri uri, GlobalKey<NavigatorState> navigatorKey) {
  final extractedParams = extractQueryParams(uri.toString());
  String? clinicCode = extractedParams['qrClinicCode'];
  String? clinicName = extractedParams['clinicName'];
  String? clinicLogo = extractedParams['clinicLogo'];

  if (clinicCode != null && clinicName != null && clinicLogo != null) {
    final route = CacheHelper.getData('token') == null
        ? RegisterQrScreen(
      clinicCode: clinicCode,
      clinicName: clinicName,
      clinicLogo: clinicLogo,
    )
        : ConfirmationScreen(
      clinicCode: clinicCode,
      clinicName: clinicName,
      clinicLogo: clinicLogo,
    );

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => route),
          (route) => false,
    );
  } else {
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty && pathSegments[0] == 'vetRegister') {
      final id = pathSegments.length > 1 ? pathSegments[1] : '';
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => VetCareRegister(invitationCode: id),
        ),
            (route) => false,
      );
    }
  }
}
