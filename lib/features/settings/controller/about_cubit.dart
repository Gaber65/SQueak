import 'package:bloc/bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  AboutCubit() : super(AboutInitial()) {
    fetchVersion();
  }

  Future<void> fetchVersion() async {
    try {
      emit(AboutLoading());
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      emit(AboutLoaded(packageInfo.version));
    } catch (e) {
      emit(AboutError("Failed to fetch version"));
    }
  }
}
