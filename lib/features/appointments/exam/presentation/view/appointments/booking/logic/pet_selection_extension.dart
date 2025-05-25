import 'package:squeak/features/appointments/exam/data/models/client_clinic_model.dart';

// Global set to track selected pet IDs
final Set<String> _selectedPetIds = {};

// Extension to add isSelected property to PetClinicModel
extension PetSelectionExtension on PetClinicModel {
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