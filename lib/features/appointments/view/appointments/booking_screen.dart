import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/models/get_client_clinic_model.dart';
import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/features/layout/layout.dart';
import 'package:squeak/features/pets/view/pet_screen.dart';


import '../../../../generated/l10n.dart';
import '../../../pets/models/pet_model.dart';
import '../../controller/clinic/appointment_cubit.dart';
import '../../controller/clinic/appointment_state.dart';
import '../../models/availabilities_model.dart';
import '../../models/doctor_model.dart';
import '../component/CustomCalendarDatePicker.dart';
import 'package:intl/intl.dart';

/// Booking Screen melkerm
class BookingScreen extends StatefulWidget {
  BookingScreen({
    super.key,
    required this.selectedDate,
    required this.timeSlotData,
    required this.clinicCode,
    required this.doctors,
    this.petId = '',
    this.isSpayed = null,
    // this.petNameFromAppoinmentIcon = null,
    required this.petNameFromAppoinmentIcon,
    required this.genderForPetFromAppoinmentScreen,
  });

  final DateTime selectedDate;
  final List<AvailabilityModel> timeSlotData;
  final String clinicCode;
  final List<DoctorModel> doctors;
  final String petId;
  final bool? isSpayed;
  String? petNameFromAppoinmentIcon;
  int? genderForPetFromAppoinmentScreen;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();
    print('Get pets' + '-----------------');
    LayoutCubit.get(context).getOwnerPet();
  }

  String? doctorId;
  String? time;
  String? dropDownId;
  String? petName;
  String? breedId;
  String? specieId;
  int? petGender;
  bool? isSpayed;

  bool initTheSelectedPetValue = false;

  @override
  Widget build(BuildContext context) {
    if (widget.petId.isNotEmpty || widget.petId != '') {
      dropDownId = widget.petId;
      isSpayed = widget.isSpayed;
    }

    print("Pet id");
    print(widget.petId);
    print("Pet id");
    return BlocProvider(
      create: (context) =>
          AppointmentCubit()..getClientINClinic(widget.clinicCode),
      child: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is CreateAppointmentsSuccess) {
            LayoutCubit.get(context).changeBottomNav(2);
            LayoutCubit.get(context).pets.forEach((element) {
              element.isSelected = false;
            });
            navigateAndFinish(context, LayoutScreen());
          }
          print("If CreateAppointmentsError");
          if (state is CreateAppointmentsError) {
            errorToast(
              context,
              state.errorMessageModel.errors.isNotEmpty
                  ? state.errorMessageModel.errors.values.first.first
                  : state.errorMessageModel.message,
            );
          }
        },
        builder: (context, state) {
          var cubit = AppointmentCubit.get(context);
          var pets = LayoutCubit.get(context).pets;

          if (pets.isEmpty) {
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(isArabic() ? 'خطأ' : "Error"),
                  content: Text(isArabic()
                      ? 'يجب أن يكون لديك  أليف واحد على الأقل للمتابعة'
                      : "You must have at least one pet to proceed."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog

                        // Navigate to PetScreen after closing the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PetScreen()),
                        );
                      },
                      child: Text(isArabic()
                          ? 'اذهب إلى الحيوانات الأليفة'
                          : "Go to Pets."),
                    ),
                  ],
                ),
              );
            });
            return SizedBox(); // Prevents further UI rendering
          }

          return WillPopScope(
            onWillPop: () async {
              LayoutCubit.get(context).pets.forEach((element) {
                element.isSelected = false;
              });
              Navigator.pop(context);
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(S.of(context).startAppointment),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                    LayoutCubit.get(context).pets.forEach((element) {
                      element.isSelected = false;
                    });
                  },
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 100,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              ColorManager.primaryColor.withOpacity(.2),
                        ),
                        onPressed: cubit.isLoading
                            ? null
                            : () {
                                if (time == null) {
                                  infoToast(
                                    context,
                                    isArabic()
                                        ? 'الوقت مطلوب'
                                        : 'Please select time',
                                  );
                                } else {
                                  showCustomConfirmationDialog(
                                    yesButtonColor: Colors.green,
                                    noButtonColor: Colors.red,
                                    titleOfAlertAR: 'تأكيد الحجز',
                                    titleOfAlertEN: 'Confirm Appointment',
                                    context: context,
                                    description: isArabic()
                                        ? Text.rich(
                                            TextSpan(
                                              text: 'هل تريد حجز موعد لـ ',
                                              children: [
                                                TextSpan(
                                                  text: widget.petNameFromAppoinmentIcon ==
                                                              null ||
                                                          widget.petNameFromAppoinmentIcon ==
                                                              ""
                                                      ? petName.toString()
                                                      : widget
                                                          .petNameFromAppoinmentIcon
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: " في تاريخ ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${DateFormat('yyyy-MM-dd', 'en_US').format(widget.selectedDate)}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                TextSpan(text: '?'),
                                              ],
                                            ),
                                          )
                                        : Text.rich(
                                            TextSpan(
                                              text:
                                                  'Do you want to book an appointment for ',
                                              children: [
                                                TextSpan(
                                                  text: widget.petNameFromAppoinmentIcon ==
                                                              null ||
                                                          widget.petNameFromAppoinmentIcon ==
                                                              ""
                                                      ? petName.toString()
                                                      : widget
                                                          .petNameFromAppoinmentIcon
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: " on ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${DateFormat('yyyy-MM-dd', 'en_US').format(widget.selectedDate)}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                TextSpan(text: '?'),
                                              ],
                                            ),
                                          ),
                                    imageUrl:
                                        'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?t=st=1729767092~exp=1729770692~hmac=fe206337cc285fa3e223ab4e0326cd478bbb1497ff9a0b37543f9a46f4f23325&w=826',
                                    onConfirm: () async {
                                      handleCreateAppointment(context);
                                    },
                                  );
                                }
                              },
                        child: cubit.isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                S.of(context).booking,
                                style: FontStyleThame.textStyle(
                                  context: context,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontColor: ColorManager.primaryColor,
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: cubit.commentController,
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: S.of(context).addComment,
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
                      fontColor: MainCubit.get(context).isDark
                          ? Colors.white54
                          : Colors.black54,
                    ),
                    suffixIcon: IconButton(
                      onPressed: cubit.isLoading
                          ? null
                          : () {
                              if (dropDownId == null || time == null) {
                                infoToast(
                                  context,
                                  dropDownId == null
                                      ? isArabic()
                                          ? 'الحيوان مطلوب'
                                          : 'Please select a pet'
                                      : isArabic()
                                          ? 'الوقت مطلوب'
                                          : 'Please select time',
                                );
                              } else {
                                showCustomConfirmationDialog(
                                  yesButtonColor: Colors.green,
                                  noButtonColor: Colors.red,
                                  titleOfAlertAR: 'حجز الموعد',
                                  titleOfAlertEN: 'Confirm Appointment',
                                  context: context,
                                  description: isArabic()
                                      ? Text.rich(
                                          TextSpan(
                                            text:
                                                'هل أنت متأكد أنك تريد اضافه موعد ',
                                            children: [
                                              TextSpan(
                                                text: petName.toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(text: '?'),
                                            ],
                                          ),
                                        )
                                      : Text.rich(
                                          TextSpan(
                                            text:
                                                'Are you sure you want to book  appointment',
                                            children: [
                                              TextSpan(text: '?'),
                                            ],
                                          ),
                                        ),
                                  imageUrl:
                                      'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?t=st=1729767092~exp=1729770692~hmac=fe206337cc285fa3e223ab4e0326cd478bbb1497ff9a0b37543f9a46f4f23325&w=826',
                                  onConfirm: () async {
                                    handleCreateAppointment(context);
                                  },
                                );
                              }
                            },
                      icon: cubit.isLoading
                          ? const CircularProgressIndicator()
                          : const Icon(IconlyLight.send),
                    ),
                    filled: true,
                    fillColor: MainCubit.get(context).isDark
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
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Pets
                      widget.petId == '' || widget.petId.isEmpty
                          ? (LayoutCubit.get(context).pets.isNotEmpty)
                              ? Text(isArabic() ? 'أحد أليف' : 'Your Pets',
                                  style: FontStyleThame.textStyle(
                                    context: context,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ))
                              : Center(
                                  child: Text(
                                      isArabic()
                                          ? 'يرجى إضافة أليف لبدء الحجز'
                                          : 'Please add pets to start reservation',
                                      style: FontStyleThame.textStyle(
                                        context: context,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                          : SizedBox(),
                      SizedBox(
                        height: 5,
                      ),
                      widget.petId == '' || widget.petId.isEmpty
                          ? BlocConsumer<LayoutCubit, LayoutState>(
                              listener: (context, state) {
                                // TODO: implement listener
                              },

                              /// TODO : Mohamed Elkerm -> bad practise logic code in UI
                              builder: (context, state) {
                                List<PetsData> petsData =
                                    LayoutCubit.get(context)
                                        .pets
                                        .where(
                                          (element) =>
                                              element.petId !=
                                              CacheHelper.getData('clintId'),
                                        )
                                        .toList();
                                if (!initTheSelectedPetValue) {
                                  dropDownId = petsData[0].petId;
                                  petName = petsData[0].petName;
                                  petGender = petsData[0].gender;
                                  breedId = petsData[0].breedId;
                                  isSpayed = petsData[0].isSpayed;
                                  petsData[0].isSelected = true;
                                }
                                return petsData.isNotEmpty
                                    ? CarouselSlider.builder(
                                        itemCount: petsData.length,
                                        itemBuilder:
                                            (context, index, realIndex) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                dropDownId =
                                                    petsData[index].petId;
                                                petName =
                                                    petsData[index].petName;
                                                petGender =
                                                    petsData[index].gender;
                                                breedId =
                                                    petsData[index].breedId;
                                                isSpayed =
                                                    petsData[index].isSpayed;

                                                print(dropDownId);
                                              });
                                              petsData.forEach((element) {
                                                element.isSelected = false;
                                              });
                                              petsData[index].isSelected = true;
                                              setState(() {});
                                            },
                                            child: buildPetItem(
                                              petsData[index],
                                              cubit,
                                              context,
                                            ),
                                          );
                                        },
                                        options: CarouselOptions(
                                          onPageChanged: (index, reason) {
                                            setState(
                                              () {
                                                initTheSelectedPetValue = true;
                                                petsData.forEach((element) {
                                                  element.isSelected = false;
                                                });
                                                petsData[0].isSelected = false;

                                                dropDownId =
                                                    petsData[index].petId;
                                                petName =
                                                    petsData[index].petName;
                                                petGender =
                                                    petsData[index].gender;
                                                breedId =
                                                    petsData[index].breedId;
                                                isSpayed =
                                                    petsData[index].isSpayed;

                                                petsData.forEach((element) {
                                                  element.isSelected = false;
                                                });
                                                petsData[index].isSelected =
                                                    true;
                                                print(dropDownId);
                                              },
                                            );
                                          },
                                          height: 80,
                                          aspectRatio: 1.5,
                                          viewportFraction: 1,
                                          initialPage: 0,
                                          enableInfiniteScroll: false,
                                          reverse: false,
                                          autoPlay: false,
                                          autoPlayInterval:
                                              const Duration(seconds: 3),
                                          autoPlayAnimationDuration:
                                              const Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      )
                                    : buildEmptyPetsContent(
                                        context,
                                      );
                              },
                            )
                          : SizedBox(),
                      // if (LayoutCubit.get(context).pets.isNotEmpty &&
                      //     LayoutCubit.get(context).pets.length > 1)
                      //   Text(
                      //     S.of(context).swapPet,
                      //     textAlign: TextAlign.center,
                      //     style: FontStyleThame.textStyle(
                      //       context: context,
                      //       fontSize: 14,
                      //       fontColor: Colors.grey,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),

                      ///Doctor
                      SizedBox(
                        height: 15,
                      ),
                      buildDropDownDoctor(),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            isArabic()
                                ? 'من فضلك اختار وقت الحجز'
                                : 'Please select time for reservation',
                            style: FontStyleThame.textStyle(
                              context: context,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                      ),

                      /// Calendar Date Picker
                      SizedBox(
                        height: 5,
                      ),
                      CalendarScreen(
                        isShowTime: true,
                        isShowDate: false,
                        timeSlotData: widget.timeSlotData,
                        selectedDate: widget.selectedDate,
                        onIntervalSelected: (p0) {
                          p0 = convertTo24Hour(p0);
                          if (DateTime.now().isBefore(widget.selectedDate)) {
                            time = p0;
                          } else {
                            if (int.parse(p0.split(':')[0]) <
                                    DateTime.now().hour ||
                                (int.parse(p0.split(':')[0]) ==
                                        DateTime.now().hour &&
                                    int.parse(p0.split(':')[1]) <
                                        DateTime.now().minute)) {
                              infoToast(
                                context,
                                isArabic()
                                    ? 'الساعة المحددة قبل الساعة الحالية'
                                    : 'Selected time is before current time',
                              );
                            } else {
                              time = p0;
                            }
                          }
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPetItem(PetsData doctor, AppointmentCubit cubit, context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: double.infinity,
            decoration: Decorations.kDecorationBoxShadow(
              context: context,
              color: doctor.isSelected
                  ? MainCubit.get(context).isDark
                      ? Colors.grey[800]
                      : Colors.grey[300]
                  : MainCubit.get(context).isDark
                      ? Colors.black38
                      : Colors.white,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      doctor.imageName.isEmpty
                          ? AssetImageModel.defaultPetImage
                          : '$imageUrl${doctor.imageName}',
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    doctor.petName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (LayoutCubit.get(context).pets.length > 1)
          Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  widthFactor: .4,
                  child: Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
                Align(
                  widthFactor: .4,
                  child: Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
                Align(
                  widthFactor: .4,
                  child: Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          )
      ],
    );
  }

  String? doctorImage;
  String? doctorName;

  Widget buildDropDownDoctor() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: Decorations.kDecorationBoxShadow(context: context),
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<DoctorModel>(
          onChanged: (newValue) {
            setState(() {
              doctorImage = newValue!.image;
              doctorId = newValue.id;
              doctorName = newValue.name;
            });
          },
          isExpanded: true,
          iconSize: 0.0,
          elevation: 0,
          menuMaxHeight: 200,
          icon: const SizedBox.shrink(),
          underline: const SizedBox(),
          hint: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                    doctorName ??
                        (isArabic() ? 'اختر الطبيب' : 'Select doctor'),
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
                Spacer(),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    doctorImage ??
                        'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.1.798062041.1678310296&semt=ais',
                  ),
                ),
              ],
            ),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          items: widget.doctors.map((DoctorModel value) {
            return DropdownMenuItem<DoctorModel>(
              value: value,
              child: Row(
                children: [
                  Text(value.name),
                  Spacer(),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      value.image,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  ClientClinicModel? findPet(List<ClientClinicModel> data, String petName) {
    for (var element in data) {
      if (element.petSqueakId == petName) {
        return element;
      }
    }
    return null;
  }

  void createAppointmentForPet({
    required String petId,
    required String clinicCode,
    required String appointmentTime,
    required String appointmentDate,
    required int petGender,
    required String petName,
    required String clientId,
    required bool isExisted,
    required bool notExistedOrPet,
    required bool isExistedNoPet,
    String? doctorId,
    required BuildContext context,
    required String petSqueakId,
  }) {
    AppointmentCubit.get(context).createAppointment(
      petId: petId,
      petSqueakId: petSqueakId,
      clinicCode: clinicCode,
      appointmentTime: appointmentTime,
      appointmentDate: appointmentDate,
      petGender: petGender,
      petName: petName,
      clientId: clientId,
      isExisted: isExisted,
      notExistedOrPet: notExistedOrPet,
      isExistedNoPet: isExistedNoPet,
      doctorId: doctorId,
      isSpayed: isSpayed!,
    );
  }

  /// TODO : Mohamed Elkerm -> bad practise logic code in UI
  void handleCreateAppointment(BuildContext context) {
    print("start handleCreateAppointment!!!!!!!!");
    String formatDate =
        DateFormat('yyyy-MM-dd', 'en_US').format(widget.selectedDate);
    final clinicCode = widget.clinicCode;
    final appointmentTime = time! + ':00';
    final appointmentDate = formatDate;
    final doctorId = this.doctorId;
    final appointmentCubit = AppointmentCubit.get(context);
    final isPetFromCache = CacheHelper.getData('isPet') != null &&
        CacheHelper.getData('isPet') == true;
    final petNameFromCache = CacheHelper.getData('activeId');
    final petGenderFromCache = CacheHelper.getData('gender');

    if (appointmentCubit.clientINClinic) {
      ClientClinicModel? matchedPet;

      if (isPetFromCache) {
        print("yes the pet from cached");
        matchedPet = findPet(appointmentCubit.petListInVet, petNameFromCache);
      } else {
        print("no the pet not from cached");
        matchedPet = findPet(appointmentCubit.petListInVet, dropDownId!);
      }

      if (matchedPet != null) {
        print("matchedPet != null  NORMAL CASE");
        createAppointmentForPet(
          petId: matchedPet.petId,
          clinicCode: clinicCode,
          petSqueakId: matchedPet.petSqueakId,
          appointmentTime: appointmentTime,
          appointmentDate: appointmentDate,
          petGender: matchedPet.petGender,
          petName: matchedPet.petName,
          clientId: matchedPet.clientId,
          isExisted: true,
          notExistedOrPet: false,
          isExistedNoPet: false,
          doctorId: doctorId,
          context: context,
        );
      } else {
        print("matchedPet == null");
        createAppointmentForPet(
          petId: '',
          clinicCode: clinicCode,
          petSqueakId: dropDownId!,
          appointmentTime: appointmentTime,
          appointmentDate: appointmentDate,
          petGender: isPetFromCache
              ? petGenderFromCache
              : widget.genderForPetFromAppoinmentScreen == null
                  ? 1
                  : widget.genderForPetFromAppoinmentScreen,
          petName: isPetFromCache
              ? petNameFromCache
              : widget.petNameFromAppoinmentIcon,
          clientId: appointmentCubit.petListInVet.firstOrNull?.clientId ?? '',
          isExisted: false,
          notExistedOrPet: false,
          isExistedNoPet: true,
          doctorId: doctorId,
          context: context,
        );
      }
    } else {
      print("this default case");
      createAppointmentForPet(
        petId: '',
        clinicCode: clinicCode,
        petSqueakId: dropDownId!,
        appointmentTime: appointmentTime,
        appointmentDate: appointmentDate,
        petGender: isPetFromCache ? petGenderFromCache : petGender!,
        petName: isPetFromCache ? petNameFromCache : petName!,
        clientId: '',
        isExisted: false,
        notExistedOrPet: true,
        isExistedNoPet: false,
        doctorId: doctorId,
        context: context,
      );
    }
  }
}

class ShimmerArrowAnimation extends StatefulWidget {
  @override
  _ShimmerArrowAnimationState createState() => _ShimmerArrowAnimationState();
}

class _ShimmerArrowAnimationState extends State<ShimmerArrowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -2, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                Colors.white10,
                Colors.white,
                Colors.white10,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1 + _animation.value, 0), // Moves gradient
              end: Alignment(1 + _animation.value, 0),
            ).createShader(bounds);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                widthFactor: .4,
                child: const Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              Align(
                widthFactor: .4,
                child: const Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              Align(
                widthFactor: .4,
                child: const Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
