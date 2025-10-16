import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/global_widget/vc_loading_widget.dart';

import 'package:squeak/features/auth/contactus/data/datasources/contact_us_remote_data_source.dart';
import 'package:squeak/features/auth/contactus/data/repositories/contact_us_repository_impl.dart';
import 'package:squeak/features/auth/contactus/domin/usecses/contact_us_use_case.dart';
import 'package:squeak/features/auth/contactus/presentation/cubit/contact_us_cubit.dart';
import 'package:squeak/features/auth/register/domin/usecses/register_qr_use_case.dart';
import 'package:squeak/features/auth/register/domin/usecses/register_use_case.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../../register/data/datasources/register_remote_data_source.dart';
import '../../../register/data/repositories/register_repository_impl.dart';
import '../../../register/domin/usecses/get_countries_use_case.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
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

            // Initialize necessary data
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
          return Scaffold(
            appBar: AppBar(title: Text(S.of(context).help)),
            body: _buildBody(context, cubit, registerCubit),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    context,
    ContactUsCubit cubit,
    RegisterCubit registerCubit,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [_buildProfile(context), const SizedBox(height: 80)],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: _buildLoginDetail(context, cubit, registerCubit),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final String image =
      'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/cute-little-dog-isolated-yellow.png?alt=media&token=f0b2c1e2-9947-4d3b-b5b9-ed8bbc7baff8';

  Widget _buildProfile(context) {
    return Container(
      width: double.infinity,
      height:
          ResponsiveScreen.isMobile(context)
              ? MediaQuery.of(context).size.height * 0.2
              : MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(image)),
      ),
    );
  }

  Widget _buildLoginDetail(
    context,
    ContactUsCubit cubit,
    RegisterCubit registerCubit,
  ) {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: cubit.formKey,
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
            decoration: BoxDecoration(
              color:
                  MainCubit.get(context).isDark
                      ? Colors.grey.shade900
                      : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8.0),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                MyTextForm(
                  controller: cubit.nameController,
                  prefixIcon: const Icon(Icons.person, size: 14),
                  enable: false,
                  hintText: S.of(context).name_hint,
                  validatorText: S.of(context).name_validation,
                  obscureText: false,
                ),

                /// email
                SizedBox(height: 20),
                MyTextForm(
                  controller: cubit.emailController,
                  prefixIcon: const Icon(Icons.alternate_email_sharp, size: 14),
                  enable: false,
                  hintText: S.of(context).email_hint,
                  validatorText: S.of(context).email_validation,
                  obscureText: false,
                ),

                /// phone
                SizedBox(height: 20),
                BlocConsumer<RegisterCubit, RegisterState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return PhoneTextField(
                      controller: cubit.phoneController,
                      countries: RegisterCubit.get(context).countries,
                      registerCubit: registerCubit,
                    );
                  },
                ),

                /// title
                SizedBox(height: 20),
                MyTextForm(
                  controller: cubit.titleController,
                  prefixIcon: const Icon(Icons.title, size: 14),
                  enable: false,
                  hintText:
                      isArabic()
                          ? 'ادخال عنوان المشكلة'
                          : 'enter your problem title',
                  validatorText:
                      isArabic()
                          ? 'الرجاء ادخال عنوان المشكلة'
                          : 'Please enter your problem title',
                  obscureText: false,
                ),

                /// comment
                SizedBox(height: 20),
                MyTextForm(
                  controller: cubit.commentController,
                  prefixIcon: SizedBox(),
                  maxLines: 5,
                  enable: false,
                  hintText:
                      isArabic()
                          ? 'ادخال تعليقك علي المشكلة'
                          : 'Enter your problem comment',
                  validatorText:
                      isArabic()
                          ? 'الرجاء ادخال عنوان المشكلة'
                          : 'Please enter your problem comment',
                  obscureText: false,
                ),
                SizedBox(height: 20),
                VcLoadingButton(
                  onPressed: () {
                    if (cubit.formKey.currentState!.validate()) {
                      cubit.contactUs();
                    }
                  },
                  isLoading: cubit.isContactUs,
                  child: Text(
                    S.of(context).send,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
