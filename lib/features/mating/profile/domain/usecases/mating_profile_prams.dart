import 'package:squeak/features/mating/profile/domain/entities/history_entities.dart';

class MatingProfileParams {
  final String petId;
  final String historyId;
  final HistoryStatus status;

  MatingProfileParams({
    required this.petId,
    required this.status,
    required this.historyId,
  });
}
