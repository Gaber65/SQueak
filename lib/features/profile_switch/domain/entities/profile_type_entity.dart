import 'package:squeak/features/pets/data/models/pet_model.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/settings/data/models/owner_model.dart';
import 'package:squeak/features/settings/domain/entities/owner_entite.dart';
import '../../../../core/utils/enums/profile_type.dart';

class ActiveProfile {
  final ProfileType type;
  final Owner? user;
  final PetEntities? pet;

  const ActiveProfile.user(this.user) : type = ProfileType.user, pet = null;

  const ActiveProfile.pet(this.pet) : type = ProfileType.pet, user = null;

  const ActiveProfile({required this.type, this.user, this.pet});

  factory ActiveProfile.fromJson(Map<String, dynamic> json) {
    return ActiveProfile(
      type: ProfileType.values.firstWhere((e) => e.toString() == json['type']),
      user: json['user'] != null ? OwnerModel.fromJson(json['user']) : null,
      pet: json['pet'] != null ? PetData.fromJson(json['pet']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user': user?.toMap(),
      'pet': pet?.toJson(),
    };
  }

}
