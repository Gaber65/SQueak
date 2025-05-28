import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import '../../../../../features/vetcare/presenation/view/follow_confirmation_screen.dart';
import '../../../../../features/vetcare/presenation/view/qr_register_screen.dart';
import '../../../../../features/vetcare/presenation/view/vetCareRegister.dart';
import '../../../../utils/export_path/export_files.dart';

enum LinkType {
  qrRegister('qrClinicCode', '/QrRegister/'),
  vetRegister('vetRegister', '/vetRegister/');

  const LinkType(this.key, this.path);
  final String key;
  final String path;
}

enum ParamKey { qrClinicCode, clinicName, clinicLogo }

Map<String, String?> extractQueryParams(String url) {
  // Handle both /QrRegister? and /vetRegister/qrClinicCode=... cases
  final queryStart = url.contains('?') ? url.indexOf('?') : url.indexOf('/vetRegister/');
  if (queryStart == -1) return {};

  final queryString = url.substring(queryStart + (url[queryStart] == '?' ? 1 : '/vetRegister/'.length));
  final params = <String, String>{};

  for (final pair in queryString.split('&')) {
    final keyValue = pair.split('=');
    if (keyValue.length == 2) {
      params[Uri.decodeComponent(keyValue[0])] = Uri.decodeComponent(
        keyValue[1],
      );
    }
  }

  return {
    for (final key in ParamKey.values)
      key.name: params[key.name],
  };
}

void initDeepLinkHandler(
  GlobalKey<NavigatorState> navigatorKey,
  StreamSubscription? sub,
) {
  final appLinks = AppLinks();

  void handleUri(Uri uri) => handleDeepLink(uri, navigatorKey);

  if (!kIsWeb) {
    sub = appLinks.uriLinkStream.listen(
      handleUri,
      onError: (e) => print('Error: $e'),
    );
  }

  appLinks.getInitialLink().then((uri) {
    if (uri != null) handleUri(uri);
  });
}

void handleDeepLink(Uri uri, GlobalKey<NavigatorState> navigatorKey)async {
  final url = uri.toString();
  final params = extractQueryParams(url);
  print(params);
  print(url);
  print("/******************************/");
  // Handle QR clinic registration
  if (params.values.every((v) => v != null && v.isNotEmpty)) {

    final route =
        CacheHelper.getData('token') == null
            ? RegisterQrScreen(
              clinicCode: params[ParamKey.qrClinicCode.name]!,
              clinicName: params[ParamKey.clinicName.name]!,
              clinicLogo: params[ParamKey.clinicLogo.name]!,
            )
            : ConfirmationScreen(
              clinicCode: params[ParamKey.qrClinicCode.name]!,
              clinicName: params[ParamKey.clinicName.name]!,
              clinicLogo: params[ParamKey.clinicLogo.name]!,
            );

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => route),
      (_) => false,
    );
    return;
  }

  // Handle vet registration
  final segments = uri.pathSegments;
  if (segments.isNotEmpty && segments[0] == LinkType.vetRegister.key) {
    final id = segments.length > 1 ? segments[1] : '';
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => VetCareRegister(invitationCode: id)),
      (_) => false,
    );
  }
}
