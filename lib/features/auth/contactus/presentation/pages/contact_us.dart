// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/global_widget/vc_loading_widget.dart';
import 'dart:math' as math;

import 'package:squeak/features/auth/contactus/data/datasources/contact_us_remote_data_source.dart';
import 'package:squeak/features/auth/contactus/data/repositories/contact_us_repository_impl.dart';
import 'package:squeak/features/auth/contactus/domin/usecses/contact_us_use_case.dart';
import 'package:squeak/features/auth/contactus/presentation/cubit/contact_us_cubit.dart';
import 'package:squeak/features/auth/register/domin/usecses/register_qr_use_case.dart';
import 'package:squeak/features/auth/register/domin/usecses/register_use_case.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:squeak/core/service/global_widget/country_code_selector.dart';
import 'package:squeak/core/service/global_widget/phone_number_field.dart';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../../register/data/datasources/register_remote_data_source.dart';
import '../../../register/data/repositories/register_repository_impl.dart';
import '../../../register/domin/usecses/get_countries_use_case.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin {
  final List<String> petEmojis = ['🐶', '🐱', '🐰', '🐭', '🐦', '🦁'];
  late AnimationController _petController;

  @override
  void initState() {
    super.initState();
    _petController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _petController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final scaleFactor = isTablet ? 1.2 : 1.0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => ContactUsCubit(
                ContactUsUseCase(
                  ContactUsRepositoryImpl(ContactUsRemoteDataSource()),
                ),
              )..init(context),
        ),
        BlocProvider(
          create: (context) {
            final remoteDataSource = RegisterRemoteDataSource();
            final repository = RegisterRepositoryImpl(remoteDataSource);
            final cubit = RegisterCubit(
              getCountriesUseCase: GetCountriesUseCase(repository),
              registerUseCase: RegisterUseCase(repository),
              registerQrUseCase: RegisterQrUseCase(repository),
            );
            cubit.loadCountries().then((value) => cubit.detectCountryCode());
            return cubit;
          },
        ),
      ],
      child: BlocConsumer<ContactUsCubit, ContactUsState>(
        listener: (context, state) {
          if (state is ContactUsErrorState) {
            errorToast(
              context,
              state.error.errors.isNotEmpty
                  ? state.error.errors.values.first.first
                  : state.error.message,
            );
          }
          if (state is ContactUsSuccessState) {
            successToast(
              context,
              isArabic()
                  ? 'تم الارسال بنجاح'
                  : 'Your message has been sent successfully',
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = ContactUsCubit.get(context);
          var registerCubit = RegisterCubit.get(context);
          return Directionality(
            textDirection: isArabic() ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Stack(
                children: [
                  // Gradient Background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF7F8DFA),
                          Color(0xFF9192F5),
                          Color(0xFF27272B),
                        ],
                        stops: [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  // Floating pet emojis
                  ...List.generate(5, (index) {
                    final random = math.Random(index);
                    final baseTop = random.nextDouble() * screenHeight * 0.3;
                    final baseLeft = random.nextDouble() * screenWidth;
                    return AnimatedBuilder(
                      animation: _petController,
                      builder: (context, child) {
                        final offset =
                            math.sin(_petController.value * 2 * math.pi) * 10;
                        return Positioned(
                          top: baseTop + offset,
                          left: baseLeft,
                          child: Opacity(
                            opacity: 0.08,
                            child: Text(
                              petEmojis[index % petEmojis.length],
                              style: TextStyle(
                                fontSize: isTablet ? 34 : 26,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 6 * scaleFactor),
                        // Header Icon
                        Container(
                          width: 64 * scaleFactor,
                          height: 64 * scaleFactor,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFCDC2F4), Color(0xFF5B3FB5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '💬',
                              style: TextStyle(fontSize: 28 * scaleFactor),
                            ),
                          ),
                        ),
                        SizedBox(height: 6 * scaleFactor),
                        Text(
                          S.of(context).help,
                          style: TextStyle(
                            fontSize: 18 * scaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4 * scaleFactor),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            isArabic()
                                ? "نحن هنا للمساعدة! أخبرنا كيف يمكننا مساعدتك 🐾"
                                : "We're here to help! Tell us how\nwe can assist you 🐾",
                            style: TextStyle(
                              fontSize: 11 * scaleFactor,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10 * scaleFactor),
                        Expanded(
                          child: _buildContactCard(
                            context,
                            cubit,
                            registerCubit,
                            scaleFactor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    ContactUsCubit cubit,
    RegisterCubit registerCubit,
    double scaleFactor,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24 * scaleFactor),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: cubit.formKey,
          child: Builder(
            builder: (ctx) {
              final screenW = MediaQuery.of(ctx).size.width;
              final contentWidth = math.min(screenW * 0.92, 520.0);
              return Center(
                child: SizedBox(
                  width: contentWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isArabic() ? 'تواصل معنا' : 'Contact Us',
                        style: TextStyle(
                          fontSize: 22 * scaleFactor,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2A2A3E),
                        ),
                      ),
                      SizedBox(height: 8 * scaleFactor),
                      Text(
                        isArabic()
                            ? 'يرجى ملء النموذج وسنتواصل معك قريباً'
                            : 'Please fill out the form and we\'ll get back to you',
                        style: TextStyle(
                          fontSize: 13 * scaleFactor,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24 * scaleFactor),

                      // Name Field
                      _buildLabel(S.of(context).name_hint, scaleFactor),
                      SizedBox(height: 8 * scaleFactor),
                      _buildTextField(
                        controller: cubit.nameController,
                        icon: Icons.person,
                        hintText: S.of(context).name_hint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).name_validation;
                          }
                          return null;
                        },
                        scaleFactor: scaleFactor,
                      ),
                      SizedBox(height: 16 * scaleFactor),

                      // Email Field
                      _buildLabel(S.of(context).email_hint, scaleFactor),
                      SizedBox(height: 8 * scaleFactor),
                      _buildTextField(
                        controller: cubit.emailController,
                        icon: Icons.alternate_email_sharp,
                        hintText: S.of(context).email_hint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).email_validation;
                          }
                          return null;
                        },
                        scaleFactor: scaleFactor,
                      ),
                      SizedBox(height: 16 * scaleFactor),

                      // Phone Field - Split into two fields
                      _buildLabel(
                        isArabic() ? 'رقم الهاتف' : 'Phone Number',
                        scaleFactor,
                      ),
                      SizedBox(height: 8 * scaleFactor),
                      BlocConsumer<RegisterCubit, RegisterState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return _buildPhoneFields(
                            context,
                            cubit,
                            registerCubit,
                            scaleFactor,
                          );
                        },
                      ),
                      SizedBox(height: 16 * scaleFactor),

                      // Title Field
                      _buildLabel(
                        isArabic() ? 'عنوان المشكلة' : 'Problem Title',
                        scaleFactor,
                      ),
                      SizedBox(height: 8 * scaleFactor),
                      _buildTextField(
                        controller: cubit.titleController,
                        icon: Icons.title,
                        hintText:
                            isArabic()
                                ? 'ادخال عنوان المشكلة'
                                : 'Enter your problem title',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabic()
                                ? 'الرجاء ادخال عنوان المشكلة'
                                : 'Please enter your problem title';
                          }
                          return null;
                        },
                        scaleFactor: scaleFactor,
                      ),
                      SizedBox(height: 16 * scaleFactor),

                      // Comment Field
                      _buildLabel(
                        isArabic() ? 'التعليق' : 'Comment',
                        scaleFactor,
                      ),
                      SizedBox(height: 8 * scaleFactor),
                      _buildTextField(
                        controller: cubit.commentController,
                        icon: Icons.comment,
                        hintText:
                            isArabic()
                                ? 'ادخال تعليقك علي المشكلة'
                                : 'Enter your problem comment',
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabic()
                                ? 'الرجاء ادخال التعليق'
                                : 'Please enter your problem comment';
                          }
                          return null;
                        },
                        scaleFactor: scaleFactor,
                      ),
                      SizedBox(height: 22 * scaleFactor),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: VcLoadingButton(
                          onPressed: () {
                            if (cubit.formKey.currentState?.validate() ??
                                false) {
                              FocusScope.of(context).unfocus();
                              cubit.contactUs();
                            }
                          },
                          isLoading: cubit.isContactUs,
                          backgroundColor: const Color(0xFF7B5CE6),
                          borderRadius: 12,
                          height: 52 * scaleFactor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).send,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16 * scaleFactor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16 * scaleFactor),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneFields(
    BuildContext context,
    ContactUsCubit cubit,
    RegisterCubit registerCubit,
    double scaleFactor,
  ) {
    // Use the shared CountryCodeSelector and PhoneNumberField
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CountryCodeSelector(
            countries: registerCubit.countries,
            registerCubit: registerCubit,
            isValid: registerCubit.countryCode.isNotEmpty,
            onCountryChanged: () {},
            onAnimationStop: () {},
          ),
        ),
        SizedBox(width: 12 * scaleFactor),
        Expanded(
          flex: 3,
          child: PhoneNumberField(
            controller: cubit.phoneController,
            hintText: isArabic() ? 'رقم الهاتف' : 'Phone Number',
            isValid: registerCubit.countryCode.isNotEmpty,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return isArabic() ? 'ادخل رقم الهاتف' : 'Enter phone number';
              }
              if (value.length < 7) {
                return isArabic()
                    ? 'رقم هاتف غير صالح'
                    : 'Invalid phone number';
              }
              return null;
            },
            onChanged: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, double scaleFactor) {
    return Align(
      alignment: isArabic() ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14 * scaleFactor,
          color: Colors.grey[800],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required String? Function(String?) validator,
    required double scaleFactor,
    int maxLines = 1,
  }) {
    return TextFormField(
      textAlign: isArabic() ? TextAlign.right : TextAlign.left,
      controller: controller,
      style: const TextStyle(color: Colors.black87),
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
          vertical: 16 * scaleFactor,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7B5CE6), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      validator: validator,
    );
  }
}
