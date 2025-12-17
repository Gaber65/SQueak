import 'package:dartz/dartz.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../core/service/service_locator/locatore_export_path.dart';

class SearchFriendsUseCase
    extends BaseUseCase<List<PetEntities>, SearchFriendsParams> {
  final PetFriendRepository repository;
  SearchFriendsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PetEntities>>> call(
    SearchFriendsParams params,
  ) async {
    return await repository.searchFriends(
      params.speciesId,
      name: params.name,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class SearchFriendsParams {
  final String speciesId;
  final String? name;
  final int? page;
  final int? pageSize;

  SearchFriendsParams({
    required this.speciesId,
    this.name,
    this.page,
    this.pageSize,
  });
}
