import '../../../../utils/export_path/export_files.dart';

Future<AppStartState> determineStartState() async {
  final String? token = CacheHelper.getData('token');

  if (token == null) {
    return AppStartState.login;
  } else {
    return AppStartState.home;
  }
}
