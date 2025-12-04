// import 'package:bloc/bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
// import 'package:squeak/features/layout/react/data/models/react_model.dart';
// import 'package:squeak/features/layout/react/domain/usecase/get_all_react_usecase.dart';
// import 'package:squeak/features/layout/react/domain/usecase/react_on_post_usecase.dart';
//
// part 'react_state.dart';
//
// class ReactCubit extends Cubit<ReactState> {
//   ReactCubit(this.reactOnPostUseCase, this.getAllReactOnPostUseCase)
//     : super(ReactInitial());
//
//   static ReactCubit get(context) => BlocProvider.of(context);
//
//   final ReactOnPostUseCase reactOnPostUseCase;
//   final GetAllReactOnPostUseCase getAllReactOnPostUseCase;
//
//   // --- GET reactions ---
//   Future<void> getAllReactions(String postId) async {
//     emit(GetReactionsLoading());
//
//     final result = await getAllReactOnPostUseCase.call(postId);
//     result.fold(
//       (failure) =>
//           emit(GetReactionsFailure(extractFirstErrorAuth(failure.error))),
//       (reactList) => emit(GetReactionsSuccess(reactions: reactList)),
//     );
//   }
//
//
//
//
//   Future<void> reactOnPost(ReactParams reactParams, int? reactionIndex) async {
//     reactParams.reactType = getReactionType(reactionIndex);
//
//     emit(CreateReactionLoading());
//
//     final result = await reactOnPostUseCase.call(reactParams);
//     result.fold(
//       (failure) =>
//           emit(CreateReactionFailure(extractFirstErrorAuth(failure.error))),
//       (actionResult) {
//         emit(CreateReactionSuccess(actionResult: actionResult));
//       },
//     );
//   }
//
//
//
//
//
// }
