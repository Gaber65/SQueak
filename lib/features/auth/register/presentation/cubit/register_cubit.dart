import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
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
  void _initializeControllers() {
    final cachedPhone = CacheHelper.getData('phone');
    if (cachedPhone != null) {
      phoneController.text = cachedPhone;
    }
  }

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
      // Step 1: Get device location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(CountryCodeDetectionErrorState("Location services are disabled."));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        emit(
          CountryCodeDetectionErrorState(
            "Location permissions are permanently denied.",
          ),
        );
        return;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          emit(
            CountryCodeDetectionErrorState("Location permission not granted."),
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final countryCodeFromLocation = placemarks.first.country;

      final country = countries.firstWhere(
        (c) => c.name == countryCodeFromLocation,
      );

      countryCode = country.name; // e.g., "US"
      countryPhoneCode = country.phoneCode; // e.g., "+1"
      countryIdToServer = country.id;
      print(countryCodeFromLocation); // Server ID, whatever you use
      print(countryIdToServer);
      print(countryPhoneCode);
      print(countryIdToServer);
      emit(CountryCodeDetectionSuccessState());
    } catch (e) {
      emit(CountryCodeDetectionErrorState(e.toString()));
    }
  }

  // Normal registration
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isRegister = true;
    emit(RegistrationLoadingState());
    phoneController.text = normalizePhoneNumber(phoneController.text);

    final entity = RegisterEntity(
      fullName: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      countryId: countryIdToServer,
      followCode: followCodeController.text.trim(),
      shareData: isAccept,
    );
    await registerUseCase
        .execute(entity)
        .then((value) {
          isRegister = false;
          CacheHelper.saveData("followCode", followCodeController.text.trim());
          emit(RegistrationSuccessState());
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

    final entity = RegisterEntity(
      fullName: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      countryId: countryIdToServer,
      shareData: isAccept,
    );

    print(entity.toMap());

    await registerQrUseCase
        .execute(entity, clinicCode)
        .then((value) async {
          emit(RegistrationSuccessState());
          await LoginCubit.get(context).login(
            context,
            email: emailController.text,
            password: passwordController.text,
          );
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
