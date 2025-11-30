import 'package:equatable/equatable.dart';
import '../../domain/entities/story.dart';

enum StoryStatus { initial, loading, ready, posting, success, failure }

class StoryState extends Equatable {
  final StoryStatus status;
  final List<Story> stories;
  final String? errorMessage;

  const StoryState({
    this.status = StoryStatus.initial,
    this.stories = const [],
    this.errorMessage,
  });

  StoryState copyWith({
    StoryStatus? status,
    List<Story>? stories,
    String? errorMessage,
  }) {
    return StoryState(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stories, errorMessage];
}
