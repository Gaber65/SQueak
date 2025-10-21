import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

class FinishMatingUseCase extends BaseUseCase<void, FinishMatingParameters> {
  final BaseChatRepository repository;

  FinishMatingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(FinishMatingParameters matingId) async {
    return await repository.finishMating(matingId);
  }
}

class FinishMatingParameters {
  final String matingId;
  final MatingCompleteStatues matingCompleteStatues;
  final bool sharePost;

  FinishMatingParameters({
    required this.matingId,
    required this.matingCompleteStatues,
    required this.sharePost,
  });

  Map<String, dynamic> toJson() {
    return {
      'matingId': matingId,
      'matingCompleteStatues': matingCompleteStatues.index,
      'sharePost': sharePost,
    };
  }
}

enum MatingCompleteStatues { notComplete, complete }
