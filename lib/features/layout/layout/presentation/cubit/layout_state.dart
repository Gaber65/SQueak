part of 'layout_cubit.dart';

abstract class LayoutState extends Equatable {
  const LayoutState();
  
  @override
  List<Object> get props => [];
}

class LayoutInitial extends LayoutState {}

class ChangeBottomNavState extends LayoutState {}

class GetVersionLoadingState extends LayoutState {}

class GetVersionSuccessState extends LayoutState {
  final VersionEntity version;

  const GetVersionSuccessState(this.version);

  @override
  List<Object> get props => [version];
}

class GetVersionErrorState extends LayoutState {
  final String message;

  const GetVersionErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class GetCurrentVersionLoadingState extends LayoutState {}

class GetCurrentVersionSuccessState extends LayoutState {
  final String version;

  const GetCurrentVersionSuccessState(this.version);

  @override
  List<Object> get props => [version];
}

class GetCurrentVersionErrorState extends LayoutState {
  final String message;

  const GetCurrentVersionErrorState(this.message);

  @override
  List<Object> get props => [message];
}
