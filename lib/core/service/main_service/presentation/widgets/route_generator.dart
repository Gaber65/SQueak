import '../../../../utils/export_path/export_files.dart';

Future<AppStartState> determineStartState() async {
  final String? token = CacheHelper.getData('token');
  final String? codeForce = CacheHelper.getData('CodeForce');
  final bool? forceRate = CacheHelper.getData('IsForceRate');

  if (token == null) {
    return AppStartState.login;
  } else if (codeForce != null) {
    return AppStartState.forceMerge;
  } else if (forceRate != null && forceRate) {
    return AppStartState.forceRate;
  } else {
    return AppStartState.home;
  }
}
