import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import 'package:squeak/features/layout/stories/domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../../domain/usecases/create_story.dart';
import '../../domain/usecases/get_active_stories.dart';
import '../widgets/common/validators.dart';
import 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final GetActiveStoriesUseCase getActiveStories;
  final CreateStoryUseCase createStory;

  StoryCubit(this.getActiveStories, this.createStory)
    : super(const StoryState());

  static StoryCubit get(context) => BlocProvider.of<StoryCubit>(context);

  Future<void> loadStories() async {
    emit(state.copyWith(status: StoryStatus.loading));

    emit(state.copyWith(status: StoryStatus.ready, stories: dummyStories));
  }

  Future<void> postStory({
    required File imageFile,
    required String ownerId,
    required String ownerName,
    required String ownerAvatarUrl,
  }) async {
    emit(state.copyWith(status: StoryStatus.posting));

    final validation = ImageValidator.validate(imageFile);
    if (!validation.isValid) {
      emit(
        state.copyWith(
          status: StoryStatus.failure,
          errorMessage: validation.message,
        ),
      );
      return;
    }

    final story = await createStory.call(
      CreateStoryParams(
        ownerId: ownerId,
        ownerName: ownerName,
        ownerAvatarUrl: ownerAvatarUrl,
        imageUrl: imageFile.path,
      ),
    );

    story.fold(
      (l) => emit(
        state.copyWith(
          status: StoryStatus.failure,
          errorMessage: l.error.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: StoryStatus.success,
          stories: [r, ...state.stories],
        ),
      ),
    );
  }

  void clearError() => emit(state.copyWith(errorMessage: null));
}
