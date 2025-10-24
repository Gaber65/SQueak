import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

class ShareImageEntriesUseCase implements BaseUseCase<void, ShareImageBoardingEntriesParams> {
  final BoardingRepository repository;

  ShareImageEntriesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ShareImageBoardingEntriesParams params) async {
    return await repository.shareImage(params);
  }
}

class ShareImageBoardingEntriesParams extends Equatable {
  final String platform;
  final String imageUrl;

  const ShareImageBoardingEntriesParams({
    required this.imageUrl,
    required this.platform,
  });

  @override
  List<Object?> get props => [imageUrl, platform];
}
