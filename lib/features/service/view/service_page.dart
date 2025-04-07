import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/service/view/component/reminder_card.dart';

import '../../../core/constant/global_function/global_function.dart';
import '../../pets/models/pet_model.dart';
import '../models/reminder.dart';
import 'component/filter_bar.dart';
import 'component/reminder_wizard.dart';

class AllServiceScreen extends StatefulWidget {
  const AllServiceScreen({
    Key? key,
    required this.petModel,
  }) : super(key: key);
  final PetsData petModel;

  @override
  _AllServiceScreenState createState() => _AllServiceScreenState();
}

class _AllServiceScreenState extends State<AllServiceScreen> {
  String typeFilter = 'all';
  String statusFilter = 'not done';
  DateTime? dateFilter;

  @override
  @override
  void initState() {
    String? keyReminder =
        CacheHelper.getData('remindersForPet${widget.petModel.petId}');

    if (keyReminder != null) {
      var jsonToMap = json.decode(keyReminder);
      reminders =
          List<Reminder>.from(jsonToMap.map((x) => Reminder.fromJson(x)));
      reminders.forEach(
        (element) => print(element.toJson()),
      );
      setState(() {});
    }

    super.initState();
  }

  List<Reminder> reminders = [];
  void _addReminder(Reminder newReminder) {
    setState(
      () {
        reminders.add(newReminder);
        CacheHelper.saveData(
            'remindersForPet${widget.petModel.petId}', json.encode(reminders));
        String? keyReminder = CacheHelper.getData('remindersForPet');
        if (keyReminder != null) {
          var jsonToMap = json.decode(keyReminder);
          var remindersForAllPets =
              List<Reminder>.from(jsonToMap.map((x) => Reminder.fromJson(x)));
          remindersForAllPets.add(newReminder);
          setState(() {});
          CacheHelper.saveData(
              'remindersForPet', json.encode(remindersForAllPets));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Reminder> filteredReminders = reminders.where((reminder) {
      bool typeMatch = typeFilter == 'all' ||
          reminder.type.toString().split('.').last == typeFilter;
      bool dateMatch =
          dateFilter == null || reminder.date.isAtSameMomentAs(dateFilter!);
      bool statusMatch =
          reminder.status.toString().split('.').last == statusFilter;
      return typeMatch && dateMatch && statusMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FilterBar(
            onTypeFilterChanged: (value) => setState(() => typeFilter = value),
            onDateFilterChanged: (value) => setState(() => dateFilter = value),
          ),
          (reminders.isEmpty)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
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
                          ? "لم يتم العثور على خدمات ل${widget.petModel.petName}"
                          : 'No Services Found for ${widget.petModel.petName}',
                      textAlign: TextAlign.center,
                      style: FontStyleThame.textStyle(
                        context: context,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                )
              : Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(5),
                    itemCount: filteredReminders.length,
                    itemBuilder: (context, index) => ReminderCard(
                      reminder: filteredReminders[index],
                      petModel: widget.petModel,
                      remove: () {
                        setState(() {
                          reminders.remove(filteredReminders[index]);
                          CacheHelper.saveData(
                              'remindersForPet${widget.petModel.petId}',
                              json.encode(reminders));
                          String? keyReminder =
                              CacheHelper.getData('remindersForPet');
                          if (keyReminder != null) {
                            var jsonToMap = json.decode(keyReminder);
                            var remindersForAllPets = List<Reminder>.from(
                                jsonToMap.map((x) => Reminder.fromJson(x)));
                            remindersForAllPets.removeWhere(
                              (element) =>
                                  element.hashCode ==
                                  filteredReminders[index].hashCode,
                            );
                            setState(() {});
                            CacheHelper.saveData('remindersForPet',
                                json.encode(remindersForAllPets));
                          }
                        });
                      },
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorTheme.primaryColor,
        onPressed: () => _showReminderWizard(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showReminderWizard(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ReminderWizard(
        onReminderAdded: _addReminder,
        onReminderEdited: (p0) {},
        petModel: widget.petModel,
      ),
    );
  }
}
