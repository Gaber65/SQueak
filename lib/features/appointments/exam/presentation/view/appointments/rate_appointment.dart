import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/controller/user/user_appointment_cubit.dart';

import 'package:squeak/generated/l10n.dart';

class RateAppointment extends StatefulWidget {
  final AppointmentEntity model;
  final bool isNav;

  const RateAppointment({required this.model, required this.isNav, super.key});

  @override
  State<RateAppointment> createState() => _RateAppointmentState();
}

class _RateAppointmentState extends State<RateAppointment> {
  @override
  void initState() {
    super.initState();
    if (!widget.model.isRating) {
      CacheHelper.saveData('RateModel', widget.model.toMap());
      CacheHelper.saveData('IsForceRate', true);
    } else {
      CacheHelper.saveData('IsForceRate', false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    CacheHelper.removeData('NotificationId');
    CacheHelper.removeData('NotificationType');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserAppointmentCubit>()..initRating(widget.model),
      child: BlocConsumer<UserAppointmentCubit, UserAppointmentState>(
        listener: (context, state) {
          if (state is RateAppointmentSuccess) {
            LayoutCubit.get(context).changeBottomNav(2);
            navigateAndFinish(context, LayoutScreen());
          }
        },
        builder: (context, state) {
          if (widget.model.isRating) {
            UserAppointmentCubit.get(context).ratingDoctor =
                widget.model.doctorServiceRate;
            UserAppointmentCubit.get(context).ratingCleanliness =
                widget.model.cleanlinessRate;
          }

          var cubit = UserAppointmentCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              if (widget.isNav || widget.model.isRating) {
                return true; // Allow back navigation
              } else {
                return false; // Prevent forced rating
              }
            },
            child: Scaffold(
              floatingActionButton:
                  (!widget.model.isRating)
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
                            contentPadding: EdgeInsetsDirectional.only(
                              start: 10,
                            ),
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
                                        cubit.rateUserAppointment(widget.model);
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: FastCachedImage(
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
                              text: widget.model.clinicName,
                              style: GoogleFonts.inter(
                                color:
                                    MainCubit.get(context).isDark
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight
                                        .bold, // Make the clinic name bold
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
                                  !widget.model.isRating
                                      ? () {
                                        cubit.ratingDoctor = index + 1;

                                        setState(() {});
                                      }
                                      : null,
                              child:
                                  widget.model.isRating
                                      ? FastCachedImage(
                                        url:
                                            index >= cubit.ratingDoctor
                                                ? 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(1).png?alt=media&token=b485402a-cc73-42d4-bd28-69a764608121'
                                                : 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview.png?alt=media&token=3bc36fe0-8522-4583-9707-7b2647acb481',
                                        width: 20,
                                      )
                                      : Image.network(
                                        index >= cubit.ratingDoctor
                                            ? 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(1).png?alt=media&token=b485402a-cc73-42d4-bd28-69a764608121'
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
                                  !widget.model.isRating
                                      ? () {
                                        cubit.ratingCleanliness = index + 1;

                                        setState(() {});
                                      }
                                      : null,
                              child:
                                  widget.model.isRating
                                      ? FastCachedImage(
                                        url:
                                            index >= cubit.ratingCleanliness
                                                ? 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(1).png?alt=media&token=b485402a-cc73-42d4-bd28-69a764608121'
                                                : 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview.png?alt=media&token=3bc36fe0-8522-4583-9707-7b2647acb481',
                                        width: 20,
                                      )
                                      : Image.network(
                                        index >= cubit.ratingCleanliness
                                            ? 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(1).png?alt=media&token=b485402a-cc73-42d4-bd28-69a764608121'
                                            : 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview.png?alt=media&token=3bc36fe0-8522-4583-9707-7b2647acb481',
                                        width: 20,
                                      ),
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (widget.model.isRating)
                      MyTextForm(
                        controller: cubit.rateController,
                        prefixIcon: SizedBox(),
                        maxLines: 5,
                        enable: false,
                        hintText:
                            widget.model.isRating
                                ? widget.model.feedbackComment ?? ''
                                : isArabic()
                                ? "الرجاء إدخال ملاحظاتك"
                                : 'Please enter your feedback',
                        validatorText: '',
                        enabled: !widget.model.isRating,
                        obscureText: false,
                      ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              appBar: AppBar(
                automaticallyImplyLeading:
                    true, // Ensure the back button appears
                leading: IconButton(
                  onPressed: () {
                    if (widget.isNav || widget.model.isRating) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    !isArabic()
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
