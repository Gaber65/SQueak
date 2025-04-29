import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/service/models/reminder_model.dart';
import 'package:squeak/features/service/models/vaccination_entities.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../controller/vac_cubit/vaccination_cubit.dart';
import '../pet_vaccination.dart';
import 'edit_vac.dart';
import 'dart:ui' as ui; // Alias 'dart:ui' as 'ui'

// Widget buildTaskItem({
//   required VaccinationModel reminderModel,
//   required context,
//   required index,
//   required BuildContext contextBloc,
//   required PetsData petModel,
//   required VaccinationCubit cubit,
//   // required ReminderModel reminderModel,
// }) {
//   TextEditingController commentController = TextEditingController();
//   cubit.value = reminderModel.status;
//   final vaccinationIcon = getVaccinationIcon(reminderModel.vaccination.vacName);
//
//   return Padding(
//     padding: const EdgeInsets.all(8),
//     child: Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           decoration: const BoxDecoration(),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width / 5,
//                     child: Text(
//                       model.vaccination.vacName,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(fontFamily: 'bold', fontSize: 15),
//                     ),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width / 2.25,
//                     child: Text(
//                       '⏱ ${formatDateString(model.vacDate)}',
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 14, fontFamily: 'bold'),
//                     ),
//                   ),
//                   Spacer(),
//                   Icon(
//                     vaccinationIcon.key, // IconData
//                     color: model.status ? Colors.green : Colors.red, // Color
//                     size: 22,
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width / 1.5,
//                     child: Text(
//                       model.comment,
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 2,
//                       style: const TextStyle(fontFamily: 'bold', fontSize: 15),
//                     ),
//                   ),
//                   const Spacer(),
//                   PopupMenuButton<int>(
//                     padding: EdgeInsets.zero,
//                     onCanceled: () {
//                       Navigator.of(context);
//                     },
//                     itemBuilder: (context) {
//                       return [
//                         PopupMenuItem(
//                           value: 1,
//                           onTap: () {
//                             ;
//                           },
//                           child: Row(
//                             children: [
//                               Text(isArabic() ? 'حذف' : 'Delete'),
//                               Spacer(),
//                               Icon(
//                                 Icons.delete,
//                                 color: Colors.red,
//                               )
//                             ],
//                           ),
//                         ),
//                         PopupMenuItem(
//                           value: 2,
//                           onTap: () {
//                             showDialog(
//                               builder: (BuildContext context) {
//                                 return editMethod4(
//                                   cubit: cubit,
//                                   index: index,
//                                   model: model,
//                                   commentController: commentController,
//                                   petModel: petModel,
//                                 );
//                               },
//                               context: context,
//                             );
//                             cubit.value = false;
//                             cubit.emit(ChangeStateVacState());
//                           },
//                           child: Row(
//                             children: [
//                               Text(isArabic() ? 'تعديل' : 'Edit'),
//                               Spacer(),
//                               CircleAvatar(
//                                 backgroundColor:
//                                     model.status ? Colors.green : Colors.red,
//                                 radius: 13,
//                                 child: Icon(
//                                   Icons.edit,
//                                   color: Colors.white,
//                                   size: 15,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ];
//                     },
//                     icon: const Icon(
//                       Icons.more_vert_outlined,
//                     ),
//                     offset: const Offset(0, 20),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

Widget buildSingleRecord({
  required ReminderModel reminderModel,
  required BuildContext context,
  required petId,
  required vacEntitiesData,
  required cub,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Dismissible(
      key: Key(reminderModel.id.toString()),
      direction: DismissDirection.horizontal,
      // Swipe both ways
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.green,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Edit",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.red,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Delete",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // If swiped left (Edit), print message and do not dismiss
          print("Edit action triggered");
          showEditReminderDialog(
              context: context,
              reminder: reminderModel,
              petId: petId,
              cub: cub);
          return false; // Prevent dismissal
        } else if (direction == DismissDirection.endToStart) {
          // If swiped right (Delete), check for error
          print("Delete action triggered");

          bool hasError = checkForError(); // Replace with actual logic
          if (hasError) {
            showCustomConfirmationDialog(
              context: context,
              description: isArabic()
                  ? 'هل أنت متأكد أنك تريد حذف هذا الخدمة؟'
                  : 'Are you sure you want to delete this service?',
              imageUrl:
                  'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?t=st=1729767092~exp=1729770692~hmac=fe206337cc285fa3e223ab4e0326cd478bbb1497ff9a0b37543f9a46f4f23325&w=826',
              onConfirm: () {
                VaccinationCubit.get(context)
                    .deleteTheService(reminder: reminderModel, petId: petId);
                Navigator.of(context)
                    .pop(true); // You can pop with true to signal confirmation.
              },
            );
            print("Error detected! Card will not be removed.");
            return false;
          } else {
            print("No error. Card will be deleted.");
            return true;
          }
        }
        return false;
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  getVaccinationIcon(reminderModel.reminderType).key,
                  color: Colors.green,
                  size: 22,
                ),
                SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminderModel.reminderType == "other" ||
                              reminderModel.reminderType == "أخرى"
                          ? reminderModel.otherTitle.toString()
                          : reminderModel.reminderType,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      '⏱ ${formatDateString(reminderModel.date)}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// Mock function to check for an error before deleting
bool checkForError() {
  // Replace with your actual condition
  return true; // Change to true to prevent deletion
}

// buildSingleRecord({
//   required ReminderModel reminderModel,
//   required BuildContext context,
//   required petId,
//   required vacEntitiesData,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Container(
//       height: MediaQuery.of(context).size.height * 0.11,
//       width: MediaQuery.of(context).size.width * 0.15,
//       // decoration: BoxDecoration(
//       //   color: MainCubit.get(context).isDark
//       //       ? Colors.black26
//       //       : Colors.grey.shade200,
//       //   borderRadius: BorderRadius.circular(
//       //     8.0,
//       //   ),
//       // ),
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Column(
//                 children: [
//                   Expanded( // Ensures the column takes the available space
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end, // Aligns text to the left
//                       mainAxisSize: MainAxisSize.min, // Prevents unnecessary stretching
//                       children: [
//                         Text(
//                           reminderModel.reminderType,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                         SizedBox(height: 4), // Adds a small gap between texts
//                         Text(
//                           '⏱ ${formatDateString(reminderModel.date)}',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: 15,
//               ),
//               Icon(
//                 getVaccinationIcon(reminderModel.reminderType).key, // IconData
//                 color: Colors.green, // Color
//                 size: 22,
//               ),
//
//               // Expanded(
//               //   child: Row(
//               //     children: [
//               //       Expanded(
//               //         child: Text(
//               //           reminderModel.reminderType,
//               //         ),
//               //       ),
//               //       Expanded(
//               //         child: Text(
//               //           '⏱ ${formatDateString(reminderModel.date)}',
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               // SizedBox(
//               //   height: 10,
//               // ),
//               // Expanded(
//               //   child: Row(
//               //     children: [
//               //       Expanded(
//               //         child: Text(
//               //           reminderModel.notes.toString(),
//               //         ),
//               //       ),
//               //       Expanded(
//               //         child: Text(
//               //           reminderModel.reminderFreq.toString(),
//               //         ),
//               //       ),
//               //       // Expanded(
//               //       //   child: Text(
//               //       //     reminderModel.time.toString(),
//               //       //     // textAlign: TextAlign.center,
//               //       //     textDirection:  isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
//               //       //   ),
//               //       // ),
//               //     ],
//               //   ),
//               // ),
//               // Expanded(
//               //   child: Row(
//               //     children: [
//               //       Expanded(
//               //         child: Text(
//               //           reminderModel.time.toString(),
//               //         ),
//               //       ),
//               //       Expanded(
//               //         child: Text(
//               //           reminderModel.petId.toString(),
//               //         ),
//               //       ),
//               //       // Expanded(
//               //       //   child: Text(
//               //       //     reminderModel.time.toString(),
//               //       //     // textAlign: TextAlign.center,
//               //       //     textDirection:  isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
//               //       //   ),
//               //       // ),
//               //     ],
//               //   ),
//               // ),
//               // Expanded(
//               //   child: Row(
//               //     children: [
//               //       Expanded(
//               //         child: Text(
//               //           isArabic()
//               //               ? reminderModel.timeAR.toString()
//               //               : reminderModel.time.toString(),
//               //         ),
//               //       ),
//               //       Expanded(
//               //         child: Text(
//               //           reminderModel.petId.toString(),
//               //         ),
//               //       ),
//               //       // Expanded(
//               //       //   child: Text(
//               //       //     reminderModel.time.toString(),
//               //       //     // textAlign: TextAlign.center,
//               //       //     textDirection:  isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
//               //       //   ),
//               //       // ),
//               //     ],
//               //   ),
//               // ),
//               // Expanded(
//               //   child: Row(
//               //     children: [
//               //       Expanded(
//               //         child: Text(
//               //           reminderModel.notificationID.toString(),
//               //         ),
//               //       ),
//               //       Expanded(
//               //         child: Text(
//               //           reminderModel.subTypeFeed.toString(),
//               //         ),
//               //       ),
//               //       // Expanded(
//               //       //   child: Text(
//               //       //     reminderModel.time.toString(),
//               //       //     // textAlign: TextAlign.center,
//               //       //     textDirection:  isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
//               //       //   ),
//               //       // ),
//               //     ],
//               //   ),
//               // ),
//
//               // SizedBox(
//               //   height: 10,
//               // ),
//
//               // Expanded(
//               //   child: Row(
//               //     children: [
//               //       Expanded(
//               //         child: ElevatedButton(
//               //           style: ButtonStyle(
//               //             backgroundColor: WidgetStatePropertyAll(
//               //               Colors.red,
//               //             ),
//               //           ),
//               //           onPressed: () {
//               //             showCustomConfirmationDialog(
//               //               context: context,
//               //               description: isArabic()
//               //                   ? 'هل أنت متأكد أنك تريد حذف هذا الخدمة؟'
//               //                   : 'Are you sure you want to delete this service?',
//               //               imageUrl:
//               //                   'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?t=st=1729767092~exp=1729770692~hmac=fe206337cc285fa3e223ab4e0326cd478bbb1497ff9a0b37543f9a46f4f23325&w=826',
//               //               onConfirm: () {
//               //                 VaccinationCubit.get(context).deleteTheService(
//               //                     reminder: reminderModel, petId: petId);
//               //                 Navigator.of(context).pop(
//               //                     true); // You can pop with true to signal confirmation.
//               //               },
//               //             );
//               //           },
//               //           child: Text(
//               //             isArabic() ? 'حذف ' : 'Delete',
//               //           ),
//               //         ),
//               //       ),
//               //       SizedBox(
//               //         width: 20,
//               //       ),
//               //       Expanded(
//               //         child: ElevatedButton(
//               //           style: ButtonStyle(
//               //             backgroundColor: WidgetStatePropertyAll(Colors.green),
//               //           ),
//               //           onPressed: () {
//               //             showEditReminderDialog(
//               //               context: context,
//               //               reminder: reminderModel,
//               //               petId: petId,
//               //             );
//               //           },
//               //           child: Text(
//               //             isArabic() ? 'تعديل' : 'Edit',
//               //           ),
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

Widget buildConditional({
  required List<VaccinationModel> model,
  required context,
  required BuildContext contextBloc,
  required VaccinationCubit cubit,
  required PetEntity petModel,
  required listOfServices,
  required vacEntitiesData,
}) {
  return listOfServices.isNotEmpty
      ? ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return buildSingleRecord(
              cub: cubit,
              reminderModel: listOfServices[index],
              context: context,
              petId: petModel.petId,
              vacEntitiesData: vacEntitiesData,
            );
            // return buildTaskItem(
            //   model: listOfServices[index],
            //   cubit: cubit,
            //   index: index,
            //   contextBloc: contextBloc,
            //   petModel: petModel,
            //   context: context,
            // );
          },
          itemCount: listOfServices.length,
        )
      : listOfServices.isEmpty || listOfServices == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.network(
                    'https://lottie.host/b488a05f-1d87-4a5d-aa24-b4a95504f1f9/L0j5OguUTt.json',
                    repeat: false,
                    animate: true,
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  isArabic()
                      ? "لم يتم العثور على خدمات ل${petModel.petName}"
                      : 'there are no services for ${petModel.petName}',
                  textAlign: TextAlign.center,
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: VacShimmer(),
                  ),
                );
              },
              itemCount: 4,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            );
}

MapEntry<IconData, Color> getVaccinationIcon(String vacName) {
  switch (vacName) {
    case 'Flea & Tick treatment':
    case 'علاج البراغيث والقراد':
      return MapEntry(Icons.bug_report, Colors.green);

    case 'Rabies':
    case 'داء الكلب':
      return MapEntry(Icons.pets, Colors.orange);

    case 'examination':
    case 'فحص':
      return MapEntry(Icons.medical_services, Colors.blue);

    case 'Vaccination':
    case 'التطعيم':
      return MapEntry(Icons.vaccines, Colors.purple);

    case 'other':
    case 'اخرى':
      return MapEntry(Icons.info, Colors.grey);

    case 'Buy Food':
    case 'شراء الطعام':
      return MapEntry(Icons.shopping_cart, Colors.grey);

    case 'Feed':
    case 'إطعام':
      return MapEntry(Icons.restaurant, Colors.grey);

    case 'Clean Potty':
    case 'تنظيف الرمل':
      return MapEntry(Icons.cleaning_services_rounded, Colors.grey);

    case 'Grooming':
    case 'تهذيب أو عناية':
      return MapEntry(Icons.cut, Colors.grey);

    case 'Outdoor Walk':
    case 'المشي في الخارج':
      return MapEntry(Icons.directions_walk, Colors.grey);

    case 'Deworming':
    case 'التخلص من الديدان':
      return MapEntry(Icons.local_hospital, Colors.red);

    default:
      return MapEntry(Icons.info, Colors.grey);
  }
}

class EditReminderDialog extends StatefulWidget {
  final ReminderModel reminder;
  final cub;

  EditReminderDialog({
    required this.reminder,
    required this.cub,
  });

  @override
  State<EditReminderDialog> createState() => _EditReminderDialogState();
}

class _EditReminderDialogState extends State<EditReminderDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.cub.pickedFromEdit = null;
    widget.cub.newValueForDateInEdit = null;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController reminderTypeController =
        TextEditingController(text: widget.reminder.reminderType);
    TextEditingController dateController =
        TextEditingController(text: widget.reminder.date);
    TextEditingController timeController =
        TextEditingController(text: widget.reminder.time);
    TextEditingController timeControllerAR =
        TextEditingController(text: widget.reminder.timeAR);
    TextEditingController notesController =
        TextEditingController(text: widget.reminder.notes ?? '');
    widget.cub.currentFreqInEdit = widget.reminder.reminderFreq;

    String timeValue = timeController.text;
    TimeOfDay initTime = TimeOfDay(
      hour: int.parse(timeValue.split(":")[0]),
      minute: int.parse(timeValue.split(":")[1]),
    );

    return AlertDialog(
      title: Text(isArabic() ? "تعديل التذكير" : "Edit Reminder"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Center(child: Text(widget.reminder.reminderType)),
            height: MediaQuery.of(context).size.height * 0.05,
            width: double.infinity,
            decoration: BoxDecoration(
                color: MainCubit.get(context).isDark
                    ? Colors.black26
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0)),
          ),
          SizedBox(
            height: 10,
          ),
          widget.reminder.reminderType == "other" ||
                  widget.reminder.reminderType == "أخرى"
              ? Container(
                  child: Center(
                      child: Text(widget.reminder.otherTitle.toString())),
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: MainCubit.get(context).isDark
                          ? Colors.black26
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8.0)),
                )
              : SizedBox(),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () async {
              await widget.cub.selectTimeFromEdit(context, initTime);
              setState(() {}); // Forces UI updatea
            },
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: widget.cub.pickedFromEdit != null
                      ? Text(
                          "${widget.cub.pickedFromEdit!.hour}:${widget.cub.pickedFromEdit!.minute}")
                      : isArabic()
                          ? Text(widget.reminder.timeAR.toString())
                          : Text(
                              widget.reminder.time.toString(),
                            )),
              height: MediaQuery.of(context).size.height * 0.05,
              width: double.infinity,
              decoration: BoxDecoration(
                color: MainCubit.get(context).isDark
                    ? Colors.black26
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SelectDateVacForEdit(
            cubit: widget.cub,
            initDate: widget.cub.takeStringReturnDateTime(
              widget.reminder.date,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          buildDropDownFreq(
            widget.cub.reminderFreq,
            context,
            widget.cub.currentFreqInEdit,
            widget.cub,
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: notesController,
            decoration:
                InputDecoration(labelText: isArabic() ? "ملاحظات" : "Notes"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(isArabic() ? "إلغاء" : "Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            ReminderModel updatedReminder = ReminderModel(
              id: widget.reminder.id,
              petId: widget.reminder.petId,
              reminderType: reminderTypeController.text,
              reminderFreq: widget.cub.currentFreqInEdit,
              date: widget.cub.newValueForDateInEdit == null ||
                  widget.cub.newValueForDateInEdit == ""
                  ? dateController.text
                  : widget.cub.newValueForDateInEdit
                      .toString()
                      .substring(0, 10),
              time: widget.cub.pickedFromEdit == null
                  ? isArabic()
                      ? timeControllerAR.text
                      : timeController.text
                  : isArabic()
                      ? "${widget.cub.pickedFromEdit!.minute} : ${widget.cub.pickedFromEdit!.hour}"
                      : "${widget.cub.pickedFromEdit!.hour} : ${widget.cub.pickedFromEdit!.minute}",
              notes: notesController.text == null || notesController.text == ''
                  ? widget.reminder.notes
                  : notesController.text,
              notificationID: widget.reminder.notificationID,
              subTypeFeed: widget.reminder.subTypeFeed.toString().isEmpty
                  ? ""
                  : widget.reminder.subTypeFeed.toString(),
              petName: widget.reminder.petName,
              timeAR: widget.cub.pickedFromEdit == null
                  ? timeController.text
                  : "${widget.cub.pickedFromEdit!.minute} : ${widget.cub.pickedFromEdit!.hour}",
            );
            await widget.cub
                .updateTheService(
              reminder: updatedReminder,
            )
                .then((e) {
              widget.cub.getVacPet(petId: widget.reminder.petId);
            });
            // onSave(updatedReminder);
            Navigator.of(context).pop();
          },
          child: Text(isArabic() ? "حفظ" : "Save"),
        ),
      ],
    );
  }
}

void showEditReminderDialog({
  required BuildContext context,
  required ReminderModel reminder,
  required String petId,
  required cub,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditReminderDialog(
        reminder: reminder,
        cub: cub,
      );
    },
  );
}

class SelectDateVacForEdit extends StatefulWidget {
  final VaccinationCubit cubit;
  final DateTime initDate;

  const SelectDateVacForEdit({
    Key? key,
    required this.cubit,
    required this.initDate,
  }) : super(key: key);

  @override
  _SelectDateVacForEditState createState() => _SelectDateVacForEditState();
}

class _SelectDateVacForEditState extends State<SelectDateVacForEdit> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.cubit.newValueForDateInEdit == null ||
              widget.cubit.newValueForDateInEdit == ''
          ? widget.initDate.toString().substring(0, 10)
          : widget.cubit.newValueForDateInEdit.toString().substring(0, 10),
    );
  }

  void _updateDate() {
    setState(() {
      _controller.text = widget.cubit.newValueForDateInEdit == null ||
              widget.cubit.newValueForDateInEdit == ''
          ? widget.initDate.toString().substring(0, 10)
          : widget.cubit.newValueForDateInEdit.toString().substring(0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await widget.cubit.selectDateOnEdit(context, widget.initDate);
        _updateDate(); // Ensure UI updates after date selection
      },
      child: IgnorePointer(
        child: MyTextForm(
          controller: _controller,
          enabled: false,
          prefixIcon: const Icon(
            Icons.calendar_month,
            size: 14,
          ),
          enable: false,
          hintText: isArabic()
              ? 'من فضلك ادخل تاريخ الميلاد'
              : 'Please enter date of birth',
          validatorText: isArabic()
              ? 'من فضلك ادخل تاريخ الميلاد'
              : 'Please enter date of birth',
          obscureText: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

Widget buildDropDownFreq(
  List<String> freq,
  context,
  String initFreValue,
  cub,
) {
  return DropdownButtonFormField<String>(
    decoration: buildInputDecoration(context),
    isExpanded: true,
    iconSize: 18,
    menuMaxHeight: 200,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return isArabic()
            ? 'الرجاء اختيار عدد مرات التكرار'
            : 'Please select frequency';
      }
      return null;
    },
    iconEnabledColor: Colors.black,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    hint: Text(initFreValue.toString()),
    onChanged: (newValue) {
      cub.currentFreqInEdit = newValue.toString();
      cub.updateTheFrequency(newValue.toString());
      // print(VaccinationCubit.get(context).currentFreq);
      // print(VaccinationCubit.get(context).currentFreq);
    },
    items: freq.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}

InputDecoration buildInputDecoration(context) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(
      right: 10,
      left: 10,
    ),
    fillColor:
        MainCubit.get(context).isDark ? Colors.black26 : Colors.grey.shade200,
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
    labelStyle: FontStyleThame.textStyle(
      context: context,
      fontColor: MainCubit.get(context).isDark
          ? ColorManager.sWhite
          : ColorManager.black_87,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    filled: true,
  );
}
