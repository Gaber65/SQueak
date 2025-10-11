// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/auth/login/data/datasources/login_remote_data_source.dart';
import 'package:squeak/features/auth/login/data/repositories/login_repository.dart';
import 'package:squeak/features/auth/login/domin/usecses/login_use_case.dart';
import 'package:squeak/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:squeak/features/auth/register/domin/entities/country_entity.dart';
import 'package:squeak/features/auth/register/domin/entities/register_entity.dart';
import 'package:squeak/features/auth/register/domin/usecses/get_countries_use_case.dart';
import 'package:squeak/features/auth/register/domin/usecses/register_qr_use_case.dart';
import 'package:squeak/features/auth/register/domin/usecses/register_use_case.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final GetCountriesUseCase getCountriesUseCase;
  final RegisterUseCase registerUseCase;
  final RegisterQrUseCase registerQrUseCase;

  RegisterCubit({
    required this.getCountriesUseCase,
    required this.registerUseCase,
    required this.registerQrUseCase,
  }) : super(RegisterInitial());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final followCodeController = TextEditingController();

  // State variables
  bool isAccept = false;
  bool isRegister = false;
  String countryCode = "";
  String countryPhoneCode = "";
  int countryIdToServer = 1;
  List<CountryEntity> countries = [];

  // Initialize controllers with cached data if available

  // Initialize user data if already logged in

  // Clear all form fields
  void clearRegisterForm() {
    passwordController.clear();
    phoneController.clear();
    nameController.clear();
    emailController.clear();
    followCodeController.clear();
    isAccept = false;
  }

  // Toggle data sharing agreement
  void toggleDataSharing(value) {
    isAccept = value;
    emit(RegisterFormUpdatedState());
  }

  // Load countries list
  Future<void> loadCountries({String searchQuery = ''}) async {
    emit(CountriesLoadingState());
    try {
      countries = await getCountriesUseCase.execute(searchQuery);
      emit(CountriesLoadedState(countries));
    } catch (e) {
      emit(CountriesErrorState(e.toString()));
    }
  }

  // Detect country code
  Future<void> detectCountryCode() async {
    emit(CountryCodeDetectionLoadingState());
    try {
      // Ensure we have countries loaded
      if (countries.isEmpty) {
        try {
          await loadCountries();
        } catch (_) {}
      }

      // Step 1: Get device location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Fallback to cache/default instead of erroring
        _fallbackToCachedOrDefaultCountry();
        emit(CountryCodeDetectionSuccessState());
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        // Respect denial but keep UX smooth with fallback
        _fallbackToCachedOrDefaultCountry();
        emit(CountryCodeDetectionSuccessState());
        return;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          _fallbackToCachedOrDefaultCountry();
          emit(CountryCodeDetectionSuccessState());
          return;
        }
      }

      // Try current position with a short timeout; if it fails use last known
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 5),
        );
      } catch (_) {
        // iOS can throw kCLErrorDomain=2 (location unknown); use last known
        position = await Geolocator.getLastKnownPosition();
      }

      if (position != null) {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        final countryNameFromLocation = placemarks.isNotEmpty
            ? (placemarks.first.country ?? '').trim()
            : '';

        if (countryNameFromLocation.isNotEmpty) {
          final country = countries.firstWhere(
            (c) => _normalize(c.name) == _normalize(countryNameFromLocation),
            orElse: () => countries.isNotEmpty ? countries.first : CountryEntity(id: 1, name: "", phoneCode: ""),
          );

          _applyCountrySelection(country);
          emit(CountryCodeDetectionSuccessState());
          return;
        }
      }

      // If we reach here, we couldn't determine by location; fallback
      _fallbackToCachedOrDefaultCountry();
      emit(CountryCodeDetectionSuccessState());
    } catch (e) {
      // As a safety net, never block the UI; fall back and continue
      _fallbackToCachedOrDefaultCountry();
      emit(CountryCodeDetectionSuccessState());
    }
  }

  void _applyCountrySelection(CountryEntity country) {
    countryCode = country.name;
    countryPhoneCode = country.phoneCode;
    countryIdToServer = country.id;
    // Cache for next launch
    try {
      CacheHelper.saveData('countryId', country.id);
      CacheHelper.saveData('countryCodeE', country.name);
    } catch (_) {}
  }

  void _fallbackToCachedOrDefaultCountry() {
    try {
      final cachedId = CacheHelper.getData('countryId');
      if (cachedId != null && countries.isNotEmpty) {
        final byId = countries.firstWhere(
          (c) => c.id == cachedId,
          orElse: () => countries.first,
        );
        _applyCountrySelection(byId);
        return;
      }
    } catch (_) {}

    if (countries.isNotEmpty) {
      _applyCountrySelection(countries.first);
    }
  }

  String _normalize(String s) => s.toLowerCase().trim();

  // Normal registration
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isRegister = true;
    emit(RegistrationLoadingState());
    phoneController.text = normalizePhoneNumber(phoneController.text);

    // Trim the email and write it back to the controller so the UI shows the trimmed value.
    final trimmedEmail = emailController.text.trim();
    if (emailController.text != trimmedEmail) {
      emailController.text = trimmedEmail;
      emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: trimmedEmail.length),
      );
    }
    final entity = RegisterEntity(
      fullName: nameController.text,
      email: trimmedEmail,
      password: passwordController.text,
      phone: phoneController.text,
      countryId: countryIdToServer,
      followCode: followCodeController.text.trim(),
      shareData: isAccept,
    );
    await registerUseCase
        .execute(entity)
        .then((value) async {
          isRegister = false;
          debugPrint('[Register] Registration successful - saving followCode');
          await CacheHelper.saveData("followCode", followCodeController.text.trim());

          // Automatically log in the user after successful registration
          try {
            debugPrint('[Register] Starting auto-login after registration');
            final loginUseCase = LoginUseCase(
              LoginRepositoryImpl(
                remoteDataSource: LoginRemoteDataSource(),
              ),
            );

            final loginResult = await loginUseCase(
              emailOrPhoneNumber: trimmedEmail,
              password: passwordController.text,
            );

            debugPrint('[Register] Auto-login succeeded - persisting login data');
            // Save token and user data (await to avoid race conditions)
            await Future.wait([
              CacheHelper.saveData('token', loginResult.token),
              CacheHelper.saveData('role', loginResult.role),
              CacheHelper.saveData('clintId', loginResult.id),
              CacheHelper.saveData('phone', loginResult.phone),
              CacheHelper.saveData('name', loginResult.fullName),
              CacheHelper.saveData('clientName', loginResult.fullName),
              CacheHelper.saveData('username', loginResult.fullName),
              CacheHelper.saveData('email', loginResult.email),
            ]);

            await TokenManager.saveToken(
              loginResult.token,
              loginResult.expiresIn,
              loginResult.refreshToken,
            );

            debugPrint('[Register] Auto-login persistence complete');
            emit(RegistrationSuccessState());
          } catch (loginError) {
            debugPrint('[Register] Auto-login failed: $loginError');
            // If automatic login fails, still emit success but show error
            emit(RegistrationSuccessState());
            // The user will be redirected to login screen where they can manually log in
          }
        })
        .catchError((error) {
          isRegister = false;
          ServerException failure = error;
          emit(
            RegistrationErrorState(
              extractFirstErrorAuth(failure.errorMessageModel),
            ),
          );
        });
  }

  // QR-based registration
  Future<void> registerWithQr(String clinicCode, BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isRegister = true;
    LoginCubit.get(context).isLoggedIn = true;
    emit(RegistrationLoadingState());
    phoneController.text = normalizePhoneNumber(phoneController.text);

    // Trim email for QR registration too and update controller so UI reflects it.
    final qrEmailTrimmed = emailController.text.trim();
    if (emailController.text != qrEmailTrimmed) {
      emailController.text = qrEmailTrimmed;
      emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: qrEmailTrimmed.length),
      );
    }

    final entity = RegisterEntity(
      fullName: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      countryId: countryIdToServer,
      shareData: isAccept,
    );

    print(entity.toMap());

    final qrEmail = emailController.text.trim();
    await registerQrUseCase
        .execute(entity, clinicCode)
        .then((value) async {
          emit(RegistrationSuccessState());
          emit(RegistrationSuccessState());
          debugPrint('[Register][QR] Registration success - invoking LoginCubit.login');
          await LoginCubit.get(context).login(
            context,
            email: qrEmail,
            password: passwordController.text,
          );
          debugPrint('[Register][QR] LoginCubit.login returned');
        })
        .catchError((error) {
          isRegister = false;
          LoginCubit.get(context).isLoggedIn = false;
          ServerException failure = error;
          emit(
            RegistrationErrorState(
              extractFirstErrorAuth(failure.errorMessageModel),
            ),
          );
        });
  }

  @override
  Future<void> close() {
    // Dispose all controllers when cubit is closed
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    followCodeController.dispose();
    return super.close();
  }
}
