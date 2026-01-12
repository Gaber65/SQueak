import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/controller/user/user_appointment_cubit.dart';

class RateAppointment extends StatelessWidget {
  const RateAppointment({super.key, required this.model});
  final AppointmentEntity model;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserAppointmentCubit>()..initRating(model),
      child: BlocConsumer<UserAppointmentCubit, UserAppointmentState>(
        listener: (context, state) {
          if (state is RateAppointmentSuccess) {
            LayoutCubit.get(context).changeBottomNav(2);
            navigateAndFinish(context, LayoutScreen());
          }
        },
        builder: (context, state) {
          if (model.isRating) {
            UserAppointmentCubit.get(context).ratingDoctor =
                model.doctorServiceRate;
            UserAppointmentCubit.get(context).ratingCleanliness =
                model.cleanlinessRate;
          }

          var cubit = UserAppointmentCubit.get(context);
          // ignore: deprecated_member_use
          return Scaffold(
            floatingActionButton:
                (!model.isRating)
                    ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: cubit.rateController,
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText:
                              isArabic()
                                  ? "الرجاء إدخال ملاحظاتك"
                                  : 'Please enter your feedback',
                          contentPadding: EdgeInsetsDirectional.only(start: 10),
                          counterStyle: FontStyleThame.textStyle(
                            context: context,
                            fontSize: 13,
                          ),
                          hintStyle: FontStyleThame.textStyle(
                            context: context,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontColor:
                                MainCubit.get(context).isDark
                                    ? Colors.white54
                                    : Colors.black54,
                          ),
                          suffixIcon: IconButton(
                            onPressed:
                                (cubit.ratingCleanliness == 0 ||
                                        cubit.ratingDoctor == 0)
                                    ? null
                                    : cubit.isLoadingRate
                                    ? null
                                    : () {
                                      cubit.rateUserAppointment(model);
                                    },
                            icon:
                                cubit.isLoadingRate
                                    ? const CircularProgressIndicator()
                                    : const Icon(IconlyLight.send),
                          ),
                          filled: true,
                          fillColor:
                              MainCubit.get(context).isDark
                                  ? ColorManager.myPetsBaseBlackColor
                                  : Colors.grey.shade200,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusColor: Colors.grey.shade200,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                    : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: SafeFastCachedImageExtension.safe(
                      url:
                          'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/dog-breeding-buying-puppy-pet-store-domestic-animal-couple-adopting-puppy-breed-club-top-breed-standard-buy-your-purebred-pet-here-concept-bright-vibrant-violet-isolated-illustration.png?alt=media&token=249eb91a-008a-4c52-b87b-433b1c4eb256',
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 20),

                  ///title
                  Center(
                    child: Text(
                      isArabic() ? 'ردود فعل الجلسة' : 'Session feedback',
                      style: GoogleFonts.inter(
                        color:
                            MainCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  /// description
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                isArabic()
                                    ? 'يرجى تقييم تجربتك مع '
                                    : 'Please rate your experience with ',
                            style: GoogleFonts.inter(
                              color:
                                  MainCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.grey.shade600,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: model.clinicName,
                            style: GoogleFonts.inter(
                              color:
                                  MainCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.grey.shade600,
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.bold, // Make the clinic name bold
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center, // Center-align the text
                    ),
                  ),

                  SizedBox(height: 50),

                  /// rating service
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${S.of(context).DoctorService}:',
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return InkWell(
                            onTap:
                                !model.isRating
                                    ? () {
                                      cubit.ratingDoctor = index + 1;
                                      cubit.rateEmit();
                                    }
                                    : null,
                            child:
                                model.isRating
                                    ? SafeFastCachedImageExtension.safe(
                                      url:
                                          index >= cubit.ratingDoctor
                                              ? 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(1).png?alt=media&token=b485402a-cc73-42d4-bd28-69a764608121'
                                              : 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview.png?alt=media&token=3bc36fe0-8522-4583-9707-7b2647acb481',
                                      width: 20,
                                    )
                                    : SafeFastCachedImageExtension.safe(
  url: index >= cubit.ratingDoctor
                                          ? 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(1,).png?alt=media&token=b485402a-cc73-42d4-bd28-69a764608121'
                                          : 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview.png?alt=media&token=3bc36fe0-8522-4583-9707-7b2647acb481',
                                      width: 20,
                                    ),
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Divider(),

                  SizedBox(height: 20),

                  /// rating cleanliness
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${S.of(context).CleanlinessOfClinic}:',
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return InkWell(
                            onTap:
                                !model.isRating
                                    ? () {
                                      cubit.ratingCleanliness = index + 1;

                                      cubit.rateEmit();
                                    }
                                    : null,
                            child:
                                model.isRating
                                    ? SafeFastCachedImageExtension.safe(
                                      url:
                                          index >= cubit.ratingCleanliness
                                              ? 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(1).png?alt=media&token=b485402a-cc73-42d4-bd28-69a764608121'
                                              : 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview.png?alt=media&token=3bc36fe0-8522-4583-9707-7b2647acb481',
                                      width: 20,
                                    )
                                    : SafeFastCachedImageExtension.safe(
  url: index >= cubit.ratingCleanliness
                                          ? 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(1,).png?alt=media&token=b485402a-cc73-42d4-bd28-69a764608121'
                                          : 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview.png?alt=media&token=3bc36fe0-8522-4583-9707-7b2647acb481',
                                      width: 20,
                                    ),
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (model.isRating)
                    MyTextForm(
                      controller: cubit.rateController,
                      prefixIcon: SizedBox(),
                      maxLines: 5,
                      enable: false,
                      hintText:
                          model.isRating
                              ? model.feedbackComment ?? ''
                              : isArabic()
                              ? "الرجاء إدخال ملاحظاتك"
                              : 'Please enter your feedback',
                      validatorText: '',
                      enabled: !model.isRating,
                      obscureText: false,
                    ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: true, // Ensure the back button appears
            ),
          );
        },
      ),
    );
  }
}
