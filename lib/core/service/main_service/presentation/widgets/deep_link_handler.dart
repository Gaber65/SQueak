import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../cache/shared_preferences/cache_helper.dart';
import '../../../global_function/format_utils.dart';


class DeepLinkHandler {
  final AppLinks appLinks;
  final GlobalKey<NavigatorState> navigatorKey;
  StreamSubscription? _sub;

  DeepLinkHandler({required this.appLinks, required this.navigatorKey});

  void init() {
    if (!kIsWeb) {
      _sub = appLinks.uriLinkStream.listen(_handleDeepLink, onError: _onDeepLinkError);
    }
    appLinks.getInitialLink().then(_handleDeepLink).catchError(_onDeepLinkError);
  }

  void _onDeepLinkError(err) {
    print('Failed to get latest link: $err.');
  }

  void _handleDeepLink(Uri? uri) {
    if (uri != null) {
      final extractedParams = extractQueryParams(uri.toString());

      String? clinicCode = extractedParams['qrClinicCode'];
      String? clinicName = extractedParams['clinicName'];
      String? clinicLogo = extractedParams['clinicLogo'];

      if (clinicCode != null && clinicName != null && clinicLogo != null) {
        _navigateToQrOrConfirmationScreen(clinicCode, clinicName, clinicLogo);
      } else {
        _navigateToVetRegister(uri);
      }
    }
  }

  void _navigateToQrOrConfirmationScreen(String clinicCode, String clinicName, String clinicLogo) {
    if (CacheHelper.getData('token') == null) {
      // navigatorKey.currentState?.pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => RegisterQrScreen(clinicCode: clinicCode, clinicName: clinicName, clinicLogo: clinicLogo),
      //   ),
      //       (route) => false,
      // );
    } else {
      // navigatorKey.currentState?.pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => ConfirmationScreen(clinicCode: clinicCode, clinicName: clinicName, clinicLogo: clinicLogo),
      //   ),
      //       (route) => false,
      // );
    }
  }

  void _navigateToVetRegister(Uri uri) {
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty && pathSegments[0] == 'vetRegister') {
      // final id = pathSegments.length > 1 ? pathSegments[1] : '';
      // navigatorKey.currentState?.pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => VetCareRegister(invitationCode: id),
      //   ),
      //       (route) => false,
      // );
    }
  }
}
