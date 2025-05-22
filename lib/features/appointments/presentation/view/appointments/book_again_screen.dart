import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:squeak/features/appointments/data/models/availability_model.dart';
import 'package:squeak/features/appointments/data/models/client_clinic_model.dart';
import '../../../data/models/doctor_model.dart';
import '../../controller/clinic/appointment_cubit.dart';
import '../component/CustomCalendarDatePicker.dart';
import '../debug_appointment_api.dart';

/// Booking again Screen melkerm
class BooKAgainScreen extends StatefulWidget {
  final String clinicCode;
  final String petId;

  const BooKAgainScreen({
    super.key,
    required this.clinicCode,
    required this.petId,
  });

  @override
  _BooKAgainScreenState createState() => _BooKAgainScreenState();
}

class _BooKAgainScreenState extends State<BooKAgainScreen> {
  var dateController = TextEditingController();
  String? time;
  bool isCreatingAppointment = false;
  String? doctorImage;
  String? doctorName;
  String? doctorId;
  bool areDataLoaded = false; // Combined loading state

  // Local data stores
  List<PetClinicModel> _localPetList = [];
  List<AvailabilityModel> _localAvailabilities = [];
  List<DoctorModel> _localDoctors = [];
  TextEditingController _commentController =
      TextEditingController(); // Local comment controller

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      // Fetch pets
      print("DEBUG: Fetching pets directly for clinic: ${widget.clinicCode}");
      Response petResponse = await DioFinalHelper.getData(
        method: getClientClinicEndPoint(
          widget.clinicCode,
          CacheHelper.getData('phone'),
        ),
        language: false,
      );
      if (petResponse.data['success'] == true) {
        _localPetList =
            (petResponse.data['data'] as List)
                .map((e) => PetClinicModel.fromJson(e))
                .toList();
        print("DEBUG: Loaded ${_localPetList.length} pets directly.");
      } else {
        print(
          "DEBUG: Failed to load pets directly: ${petResponse.data['message']}",
        );
      }

      // Fetch availability
      print(
        "DEBUG: Fetching availability directly for clinic: ${widget.clinicCode}",
      );
      Response availabilityResponse = await DioFinalHelper.getData(
        method: getAvailabilitiesEndPoint(widget.clinicCode),
        language: false,
      );
      _localAvailabilities =
          (availabilityResponse.data['data'] as List)
              .map((e) => AvailabilityModel.fromJson(e))
              .toList();
      _localAvailabilities =
          _localAvailabilities
              .where((element) => element.isActive == true)
              .toList(); // Assuming removeDuplicatesByDayOfWeek was important, it would need to be reimplemented here or moved to a utility.
      print(
        "DEBUG: Loaded ${_localAvailabilities.length} availabilities directly.",
      );

      // Fetch doctors
      print(
        "DEBUG: Fetching doctors directly for clinic: ${widget.clinicCode}",
      );
      Response doctorResponse = await DioFinalHelper.getData(
        method: getDoctorAppointmentsEndPoint(widget.clinicCode),
        language: false,
      );
      if (doctorResponse.data['success'] == true &&
          doctorResponse.data['data'] != null) {
        _localDoctors =
            (doctorResponse.data['data'] as List)
                .map((e) => DoctorModel.fromJson(e))
                .toList();
        print("DEBUG: Loaded ${_localDoctors.length} doctors directly.");
      } else {
        print(
          "DEBUG: Failed to load doctors directly or no data: ${doctorResponse.data['message']}",
        );
      }
    } catch (e) {
      print("DEBUG: Error during _initData: $e");
      // Optionally show an error toast here if data loading fails critically
      errorToast(
        context,
        isArabic() ? 'فشل تحميل البيانات' : 'Failed to load data',
      );
    } finally {
      if (mounted) {
        setState(() {
          areDataLoaded = true;
        });
      }
    }
  }

  PetClinicModel? findPet(List<PetClinicModel> data, String petIdToFind) {
    print("DEBUG: Looking for petId: $petIdToFind in ${data.length} pets");
    for (var element in data) {
      print(
        "DEBUG: Checking pet - ID: ${element.petId}, Name: ${element.petName}, SqueakID: ${element.petSqueakId}",
      );
      if (element.petId == petIdToFind || element.petSqueakId == petIdToFind) {
        print("DEBUG: Found exact match for pet: ${element.petName}");
        return element;
      }
    }
    if (data.isNotEmpty) {
      print(
        "DEBUG: No exact match found, using first pet: ${data.first.petName}",
      );
      return data.first;
    }
    print("DEBUG: No pets found in list");
    return null;
  }

  Future<void> _handleBooking() async {
    print("DEBUG: handleBooking called");
    if (dateController.text.isEmpty || time == null) {
      print(
        "DEBUG: Missing date or time - Date: ${dateController.text}, Time: $time",
      );
      infoToast(
        context,
        dateController.text.isEmpty
            ? (isArabic() ? 'الرجاء تحديد التاريخ ' : 'Please select date')
            : (isArabic() ? "الرجاء تحديد الوقت" : 'Please select time'),
      );
      return;
    }
    print("DEBUG: Date: ${dateController.text}, Time: $time");
    if (_localPetList.isEmpty) {
      print("DEBUG: _localPetList is empty");
      errorToast(
        context,
        isArabic()
            ? 'لم يتم العثور على حيوانات أليفة في هذه العيادة'
            : 'No pets found in this clinic',
      );
      return;
    }
    if (mounted) {
      setState(() {
        isCreatingAppointment = true;
      });
    }
    try {
      print("DEBUG: _localPetList has ${_localPetList.length} pets");
      PetClinicModel? matchedPet = findPet(_localPetList, widget.petId);
      if (matchedPet == null) {
        print("DEBUG: No matching pet found for ID: ${widget.petId}");
        errorToast(
          context,
          isArabic() ? 'لم يتم العثور على الحيوانات الأليفة' : 'No pets found',
        );
        if (mounted) setState(() => isCreatingAppointment = false);
        return;
      }
      String fixedTimeFormat = "10:00:00";
      try {
        String formattedTime = time!;
        if (formattedTime.toUpperCase().contains('AM') ||
            formattedTime.toUpperCase().contains('PM')) {
          formattedTime = convertTo24Hour(formattedTime);
        }
        if (formattedTime.split(':').length == 2) {
          formattedTime = "$formattedTime:00";
        }
        fixedTimeFormat = formattedTime;
      } catch (e) {
        print("DEBUG: Error formatting time: $e, using default time");
      }
      print(
        "DEBUG: Selected pet: ${matchedPet.petName} with ID: ${matchedPet.petId}, doctorId: $doctorId",
      );
      print("DEBUG: Using appointment time: $fixedTimeFormat");
      Map<String, dynamic> requestData = {
        "date": dateController.text,
        "time": fixedTimeFormat,
        "petId": matchedPet.petId,
        "clinicCode": widget.clinicCode,
        "clientId": matchedPet.clientId,
        "petSqueakId": matchedPet.petSqueakId,
        "notes": _commentController.text,
      };
      if (doctorId != null && doctorId!.isNotEmpty) {
        requestData["doctorUserId"] = doctorId;
      }
      print("DEBUG: Direct API call with payload: $requestData");
      Response response = await DioFinalHelper.postData(
        method: '$version/vetcare/reservation/existedClient',
        data: requestData,
      );
      print("DEBUG: API response: ${response.data}");
      if (mounted) {
        LayoutCubit.get(context).selectedIndex = 2;
        navigateAndFinish(context, const LayoutScreen());
      }
      ;
      successToast(
        context,
        isArabic() ? 'تم حجز الموعد بنجاح' : 'Appointment booked successfully',
      );
    } on DioException catch (e) {
      print("DEBUG: Dio error: ${e.response!.data}");
      String extractFirstErrorTO(dynamic error) {
        try {
          final entries = error.errors?.entries;
          if (entries != null && entries.isNotEmpty) {
            final firstValues = entries.first.value;
            if (firstValues != null && firstValues.isNotEmpty) {
              return firstValues.first;
            }
          }
          return error.error.message ?? "Unknown error";
        } catch (_) {
          return "Unknown error";
        }
      }

      errorToast(
        context,
        extractFirstErrorTO(ErrorMessageModel.fromJson(e.response!.data)),
      );
    } catch (e) {
      print("DEBUG: General error: $e");
      errorToast(
        context,
        isArabic() ? 'حدث خطأ غير متوقع' : 'An unexpected error occurred',
      );
    } finally {
      if (mounted) {
        setState(() {
          isCreatingAppointment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUG: Book Again Screen building. Data loaded: $areDataLoaded");
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appointmentButtonBooking),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.bug_report),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => DebugAppointmentAPI(clinicCode: widget.clinicCode),
          //       ),
          //     );
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor.withOpacity(.2),
                ),
                onPressed:
                    (isCreatingAppointment || !areDataLoaded)
                        ? null
                        : _handleBooking,
                child:
                    isCreatingAppointment
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _commentController, // Use local controller
          style: FontStyleThame.textStyle(context: context, fontSize: 15),
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
                  (isCreatingAppointment || !areDataLoaded)
                      ? null
                      : _handleBooking,
              icon:
                  isCreatingAppointment
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body:
          !areDataLoaded
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      isArabic()
                          ? 'جاري تحميل البيانات...'
                          : 'Loading your data...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      buildDropDownDoctor(context),
                      (_localAvailabilities.isNotEmpty)
                          ? CalendarScreen(
                            isShowTime: true,
                            isShowDate: true,
                            timeSlotData: _localAvailabilities,
                            onDaySelected: (selectedDay, focusedDay) {
                              String formatDate = DateFormat(
                                'yyyy-MM-dd',
                                'en_US',
                              ).format(selectedDay);
                              if (mounted)
                                setState(
                                  () => dateController.text = formatDate,
                                );
                            },
                            onIntervalSelected: (p0) {
                              print("DEBUG: Original time selection: $p0");
                              p0 = convertTo24Hour(p0);
                              print(
                                "DEBUG: After conversion to 24-hour format: $p0",
                              );
                              if (dateController.text.isEmpty) {
                                // Ensure date is selected first
                                infoToast(
                                  context,
                                  isArabic()
                                      ? 'الرجاء تحديد التاريخ أولاً'
                                      : 'Please select a date first',
                                );
                                return;
                              }
                              DateTime selectedDateForCheck = DateTime.parse(
                                dateController.text,
                              );
                              if (DateTime.now().isBefore(
                                    selectedDateForCheck,
                                  ) ||
                                  (DateTime.now().year ==
                                          selectedDateForCheck.year &&
                                      DateTime.now().month ==
                                          selectedDateForCheck.month &&
                                      DateTime.now().day ==
                                          selectedDateForCheck.day)) {
                                try {
                                  final parts = p0.split(':');
                                  int hours = int.parse(parts[0]);
                                  int minutes =
                                      parts.length > 1
                                          ? int.parse(parts[1])
                                          : 0;
                                  DateTime selectedDateTime = DateTime(
                                    selectedDateForCheck.year,
                                    selectedDateForCheck.month,
                                    selectedDateForCheck.day,
                                    hours,
                                    minutes,
                                  );
                                  DateTime nowForCompare = DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    DateTime.now().hour,
                                    DateTime.now().minute,
                                  );

                                  if (selectedDateForCheck.isAfter(
                                        DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                        ),
                                      ) ||
                                      selectedDateTime.isAfter(nowForCompare)) {
                                    if (mounted) setState(() => time = p0);
                                    print("DEBUG: Time set to: $time");
                                  } else {
                                    print(
                                      "DEBUG: Selected time is before current time",
                                    );
                                    infoToast(
                                      context,
                                      isArabic()
                                          ? 'الساعة المحددة قبل الساعة الحالية'
                                          : 'Selected time is before current time',
                                    );
                                  }
                                } catch (e) {
                                  print("DEBUG: Error parsing time: $e");
                                  infoToast(
                                    context,
                                    isArabic()
                                        ? 'خطأ في تنسيق الوقت'
                                        : 'Error in time format',
                                  );
                                }
                              } else {
                                print("DEBUG: Selected date is in the past.");
                                infoToast(
                                  context,
                                  isArabic()
                                      ? 'لا يمكن تحديد تاريخ في الماضي'
                                      : 'Cannot select a past date',
                                );
                              }
                            },
                          )
                          : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CalendarShimmer(),
                          ),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget buildDropDownDoctor(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: Decorations.kDecorationBoxShadow(context: context),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: DropdownButton<DoctorModel>(
            onChanged: (newValue) {
              if (mounted) {
                setState(() {
                  doctorImage = newValue!.image;
                  doctorId = newValue.id;
                  doctorName = newValue.name;
                });
              }
            },
            isExpanded: true,
            iconSize: 0.0,
            elevation: 0,
            menuMaxHeight: 200,
            icon: const SizedBox.shrink(),
            underline: const SizedBox(),
            hint: Row(
              children: [
                Text(
                  doctorName ?? (isArabic() ? 'اختر الطبيب' : 'Select doctor'),
                  style: FontStyleThame.textStyle(context: context),
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
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            items:
                _localDoctors.map((DoctorModel value) {
                  return DropdownMenuItem<DoctorModel>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            value.name,
                            style: FontStyleThame.textStyle(context: context),
                          ),
                          Spacer(),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(value.image),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}

class CalendarShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 7 days a week
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: 1.0,
        ),
        itemCount: 42, // 6 weeks * 7 days per week = 42
        itemBuilder: (context, index) {
          return Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        },
      ),
    );
  }
}
