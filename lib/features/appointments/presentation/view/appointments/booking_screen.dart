import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/data/models/get_client_clinic_model.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';
import 'package:squeak/features/pets/presentation/view/widgets/get_pet/empty_state.dart';

import '../../../../pets/presentation/view/widgets/get_pet/pet_screen_content.dart';
import '../../../data/models/availabilities_model.dart';
import '../../../data/models/doctor_model.dart' as appointment_models;
import '../../../data/models/doctor_model.dart';
import '../../controller/clinic/appointment_cubit.dart';
import '../../controller/clinic/appointment_state.dart';
import '../component/CustomCalendarDatePicker.dart';
import 'package:intl/intl.dart';

// Extension to add isSelected property to ClientClinicModel
extension ClientClinicModelExtension on ClientClinicModel {
  bool get isSelected => _selectedPetIds.contains(petSqueakId);
  set isSelected(bool value) {
    if (value) {
      _selectedPetIds.add(petSqueakId);
    } else {
      _selectedPetIds.remove(petSqueakId);
    }
  }
  
  // Add missing properties
  bool get isSpayed => false; // Default value since API doesn't provide it
  String get imageName => ''; // Default value since API doesn't provide it
}

// Global set to track selected pet IDs
final Set<String> _selectedPetIds = {};

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
  final List<appointment_models.DoctorModel> doctors;
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
    // Initialize pet name from the parameter if provided
    if (widget.petNameFromAppoinmentIcon != null && widget.petNameFromAppoinmentIcon!.isNotEmpty) {
      petName = widget.petNameFromAppoinmentIcon;
    }
    
    // Initialize pet gender from the parameter if provided
    if (widget.genderForPetFromAppoinmentScreen != null) {
      petGender = widget.genderForPetFromAppoinmentScreen;
    }
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
      create: (context) => AppointmentCubit()..getClientINClinic(widget.clinicCode),
      child: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is CreateAppointmentsSuccess) {
            // LayoutCubit.get(context).changeBottomNav(2);
            // LayoutCubit.get(context).pets.forEach((element) {
            //   element.isSelected = false;
            // });
            successToast(
              context,
              isArabic() ? 'تم حجز الموعد بنجاح' : 'Appointment booked successfully',
            );
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
          var pets = [];

          /* Comment out the entire error dialog for empty pets
          if (pets.isEmpty) {
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(isArabic() ? 'خطأ' : "Error"),
                      content: Text(
                        isArabic()
                            ? 'يجب أن يكون لديك  أليف واحد على الأقل للمتابعة'
                            : "You must have at least one pet to proceed.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog

                            // Navigate to PetScreen after closing the dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetScreen(),
                              ),
                            );
                          },
                          child: Text(
                            isArabic()
                                ? 'اذهب إلى الحيوانات الأليفة'
                                : "Go to Pets.",
                          ),
                        ),
                      ],
                    ),
              );
            });
            return SizedBox(); // Prevents further UI rendering
          }
          */

          return WillPopScope(
            onWillPop: () async {
              // LayoutCubit.get(context).pets.forEach((element) {
              //   element.isSelected = false;
              // });
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
                    // LayoutCubit.get(context).pets.forEach((element) {
                    //   element.isSelected = false;
                    // });
                  },
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 100,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: ColorManager.primaryColor
                              .withOpacity(.2),
                        ),
                        onPressed:
                            cubit.isLoading
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
                                      description:
                                          isArabic()
                                              ? Text.rich(
                                                TextSpan(
                                                  text: 'هل تريد حجز موعد لـ ',
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          petName ??
                                                          widget.petNameFromAppoinmentIcon ??
                                                          "My Pet",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: " في تاريخ ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${DateFormat('yyyy-MM-dd', 'en_US').format(widget.selectedDate)}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
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
                                                      text:
                                                          petName ??
                                                          widget.petNameFromAppoinmentIcon ??
                                                          "My Pet",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: " on ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${DateFormat('yyyy-MM-dd', 'en_US').format(widget.selectedDate)}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
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
                        child:
                            cubit.isLoading
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
                  ),
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
                          cubit.isLoading
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
                                    description:
                                        isArabic()
                                            ? Text.rich(
                                              TextSpan(
                                                text:
                                                    'هل أنت متأكد أنك تريد اضافه موعد ',
                                                children: [
                                                  TextSpan(
                                                    text: petName ?? "My Pet",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(text: '?'),
                                                ],
                                              ),
                                            )
                                            : Text.rich(
                                              TextSpan(
                                                text:
                                                    'Are you sure you want to book appointment for ',
                                                children: [
                                                  TextSpan(
                                                    text: petName ?? "My Pet",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(text: '?')
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
                      icon:
                          cubit.isLoading
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
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isArabic() ? 'اختر حيوانك الأليف' : 'Select Your Pet',
                                  style: FontStyleThame.textStyle(
                                    context: context,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Builder(
                                  builder: (context) {
                                    // Get pet list from the appointments cubit
                                    List<ClientClinicModel> petsData = AppointmentCubit.get(context).petListInVet;
                                    
                                    print("DEBUG: Loaded ${petsData.length} pets from AppointmentCubit");
                                    petsData.forEach((pet) {
                                      print("DEBUG: Pet - Name: ${pet.petName}, ID: ${pet.petSqueakId}, Gender: ${pet.petGender}");
                                    });
                                    
                                    if (petsData.isEmpty) {
                                      return Center(
                                        child: Text(
                                          isArabic()
                                              ? 'لا توجد حيوانات أليفة متاحة. ستتم إضافة حيوان أليف جديد.'
                                              : 'No pets available. A new pet will be added.',
                                          style: FontStyleThame.textStyle(
                                            context: context,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }
                                    
                                    if (!initTheSelectedPetValue && petsData.isNotEmpty) {
                                      dropDownId = petsData[0].petSqueakId;
                                      petName = petsData[0].petName;
                                      petGender = petsData[0].petGender;
                                      // Default isSpayed to false since API doesn't provide it
                                      isSpayed = false;
                                      
                                      // Mark first pet as selected
                                      petsData[0].isSelected = true;
                                      initTheSelectedPetValue = true;
                                    }
                                    
                                    return CarouselSlider.builder(
                                      itemCount: petsData.length,
                                      itemBuilder: (context, index, realIndex) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              dropDownId = petsData[index].petSqueakId;
                                              petName = petsData[index].petName;
                                              petGender = petsData[index].petGender;
                                              // Default isSpayed to false since API doesn't provide it
                                              isSpayed = false;
                                              print("Selected pet: ${petsData[index].petName}, ID: ${petsData[index].petSqueakId}");
                                            });
                                            petsData.forEach((element) {
                                              element.isSelected = false;
                                            });
                                            petsData[index].isSelected = true;
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                            decoration: Decorations.kDecorationBoxShadow(
                                              context: context,
                                              color: petsData[index].isSelected
                                                  ? MainCubit.get(context).isDark
                                                      ? Colors.grey[800]!
                                                      : Colors.grey[300]!
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
                                                      AssetImageModel.defaultPetImage // Always use default image since API doesn't provide it
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.5,
                                                  child: Text(
                                                    petsData[index].petName,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      options: CarouselOptions(
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            initTheSelectedPetValue = true;
                                            petsData.forEach((element) {
                                              element.isSelected = false;
                                            });
                                            
                                            dropDownId = petsData[index].petSqueakId;
                                            petName = petsData[index].petName;
                                            petGender = petsData[index].petGender;
                                            // Default isSpayed to false since API doesn't provide it
                                            isSpayed = false;
                                            
                                            petsData[index].isSelected = true;
                                            print("Selected pet (carousel): ${petsData[index].petName}, ID: ${petsData[index].petSqueakId}");
                                          });
                                        },
                                        height: 80,
                                        aspectRatio: 1.5,
                                        viewportFraction: 1,
                                        initialPage: 0,
                                        enableInfiniteScroll: false,
                                        reverse: false,
                                        autoPlay: false,
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    );
                                  },
                                ),
                                if (AppointmentCubit.get(context).petListInVet.length > 1)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      S.of(context).swapPet,
                                      textAlign: TextAlign.center,
                                      style: FontStyleThame.textStyle(
                                        context: context,
                                        fontSize: 14,
                                        fontColor: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(height: 15),

                      ///Doctor
                      SizedBox(height: 15),
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
                          ),
                        ),
                      ),

                      /// Calendar Date Picker
                      SizedBox(height: 5),
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
                      SizedBox(height: 80),
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

  /*
  Widget buildPetItem(PetData pet, AppointmentCubit cubit, context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: double.infinity,
            decoration: Decorations.kDecorationBoxShadow(
              context: context,
              color:
                  pet.isSelected
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
                      pet.imageName.isEmpty
                          ? AssetImageModel.defaultPetImage
                          : '$imageUrl${pet.imageName}',
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    pet.petName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        // if (PetCubit.get(context).pets.length > 1)
        //   Shimmer.fromColors(
        //     baseColor: Colors.grey.shade400,
        //     highlightColor: Colors.grey.shade200,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       children: [
        //         Align(
        //           widthFactor: .4,
        //           child: Icon(Icons.keyboard_arrow_right_outlined),
        //         ),
        //         Align(
        //           widthFactor: .4,
        //           child: Icon(Icons.keyboard_arrow_right_outlined),
        //         ),
        //         Align(
        //           widthFactor: .4,
        //           child: Icon(Icons.keyboard_arrow_right_outlined),
        //         ),
        //         SizedBox(width: 10),
        //       ],
        //     ),
        //   ),
      ],
    );
  }
  */

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
                  doctorName ?? (isArabic() ? 'اختر الطبيب' : 'Select doctor'),
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
          items:
              widget.doctors.map((appointment_models.DoctorModel value) {
                return DropdownMenuItem<appointment_models.DoctorModel>(
                  value: value,
                  child: Row(
                    children: [
                      Text(value.name),
                      Spacer(),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(value.image),
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
    // Generate a valid GUID if petSqueakId is empty
    // The server expects a valid GUID format - but also requires valid pet-owner relationship
    if (petSqueakId.isEmpty || petId.isEmpty) {
      print("ERROR: Empty petId or petSqueakId is not allowed. Please select a valid pet.");
      errorToast(
        context,
        isArabic()
            ? "معرف الحيوان الأليف فارغ. يرجى اختيار حيوان أليف صالح."
            : "Pet ID is empty. Please select a valid pet.",
      );
      return;
    }
    
    // Make sure we have the current user ID
    String squeakClientId = CacheHelper.getData('clintId') ?? '';
    if (squeakClientId.isEmpty) {
      print("ERROR: Client ID is empty. User might not be logged in properly.");
      errorToast(
        context,
        isArabic()
            ? "معرف المستخدم غير متوفر. يرجى إعادة تسجيل الدخول."
            : "User ID not available. Please log in again.",
      );
      return;
    }
    
    // Detailed logging of all parameters with swapped IDs indicated
    print("DEBUG: Creating appointment with the following parameters (IDs SWAPPED TO MATCH API):");
    print("  - petId (SqueakID in our model): $petId");
    print("  - clinicCode: $clinicCode");
    print("  - petSqueakId (PetID in our model): $petSqueakId");
    print("  - appointmentTime: $appointmentTime");
    print("  - appointmentDate: $appointmentDate");
    print("  - petGender: $petGender");
    print("  - petName: $petName");
    print("  - clientId: $clientId");
    print("  - isExisted: $isExisted");
    print("  - notExistedOrPet: $notExistedOrPet");
    print("  - isExistedNoPet: $isExistedNoPet");
    print("  - doctorId: $doctorId");
    print("  - squeakClientId: $squeakClientId");
    
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
      isSpayed: isSpayed ?? false,
    );
  }

  /// TODO : Mohamed Elkerm -> bad practise logic code in UI
  void handleCreateAppointment(BuildContext context) {
    print("start handleCreateAppointment!!!!!!!!");
    String formatDate = DateFormat(
      'yyyy-MM-dd',
      'en_US',
    ).format(widget.selectedDate);
    final clinicCode = widget.clinicCode;
    final appointmentTime = time! + ':00';
    final appointmentDate = formatDate;
    final doctorId = this.doctorId;
    
    // Check if doctorId is selected
    if (doctorId == null || doctorId.isEmpty) {
      errorToast(
        context,
        isArabic()
            ? "يرجى اختيار طبيب من القائمة."
            : "Please select a doctor from the list.",
      );
      return;
    }
    
    // Check if time is selected
    if (time == null) {
      errorToast(
        context,
        isArabic()
            ? "يرجى اختيار وقت للموعد."
            : "Please select an appointment time.",
      );
      return;
    }
    
    // Check if user ID is available
    String squeakClientId = CacheHelper.getData('clintId') ?? '';
    if (squeakClientId.isEmpty) {
      errorToast(
        context,
        isArabic()
            ? "معرف المستخدم غير متوفر. يرجى إعادة تسجيل الدخول."
            : "User ID not available. Please log in again.",
      );
      return;
    }
    
    final appointmentCubit = AppointmentCubit.get(context);
    
    print("DEBUG: Selected Time: $appointmentTime");
    print("DEBUG: Selected Date: $appointmentDate");
    print("DEBUG: Selected Doctor ID: $doctorId");
    print("DEBUG: Clinic Code: $clinicCode");
    print("DEBUG: Selected PetID: $dropDownId");
    print("DEBUG: Selected Pet Name: $petName");
    print("DEBUG: Client in clinic: ${appointmentCubit.clientINClinic}");
    print("DEBUG: Available pets in clinic: ${appointmentCubit.petListInVet.length}");
    
    // Find the selected pet in the petListInVet
    ClientClinicModel? selectedPet;
    if (dropDownId != null) {
      print("DEBUG: Looking for pet with ID: $dropDownId");
      
      for (var pet in appointmentCubit.petListInVet) {
        // Important: in the API logs, the pet ID and squeakPetId seem to be swapped compared to our ClientClinicModel
        // So we're searching by both fields to ensure we find the right pet
        if (pet.petSqueakId == dropDownId || pet.petId == dropDownId) {
          selectedPet = pet;
          break;
        }
      }
      
      if (selectedPet != null) {
        print("DEBUG: Found selected pet: ${selectedPet.petName}, ID: ${selectedPet.petId}, SqueakID: ${selectedPet.petSqueakId}");
      } else {
        print("DEBUG: Selected pet not found in petListInVet");
      }
    }
    
    if (appointmentCubit.clientINClinic) {
      if (selectedPet != null) {
        print("matchedPet != null  NORMAL CASE");
        print("Creating appointment for existing pet: ${selectedPet.petName}, ID: ${selectedPet.petId}, SqueakID: ${selectedPet.petSqueakId}");
        
        // IMPORTANT: Based on the API error, it looks like the API expects petId to be the SqueakID
        // and petSqueakId to be the vetcare system ID
        createAppointmentForPet(
          petId: selectedPet.petSqueakId, // Use the petSqueakId as petId
          clinicCode: clinicCode,
          petSqueakId: selectedPet.petId, // Use the petId as petSqueakId
          appointmentTime: appointmentTime,
          appointmentDate: appointmentDate,
          petGender: selectedPet.petGender,
          petName: selectedPet.petName,
          clientId: selectedPet.clientId,
          isExisted: true,
          notExistedOrPet: false,
          isExistedNoPet: false,
          doctorId: doctorId,
          context: context,
        );
      } else {
        errorToast(
          context,
          isArabic()
              ? "يرجى اختيار حيوان أليف صالح من القائمة."
              : "Please select a valid pet from the list.",
        );
      }
    } else {
      errorToast(
        context,
        isArabic()
            ? "لم يتم العثور على حيوانات أليفة في هذه العيادة. يرجى الاتصال بالعيادة."
            : "No pets found in this clinic. Please contact the clinic.",
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
              colors: [Colors.white10, Colors.white, Colors.white10],
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
