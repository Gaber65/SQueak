part of 'layout_cubit.dart';

@immutable
sealed class LayoutState {}

final class LayoutInitial extends LayoutState {}
class ChangeBottomNavState extends LayoutState {}

class SqueakUpdateProfileSuccessfulyUpdated extends LayoutState {}
class SqueakUpdateProfilelaodingUpdated extends LayoutState {}

class SqueakGetOwnerPetlaoding extends LayoutState {}
class SqueakGetOwnerPetError extends LayoutState {}
class SqueakGetOwnerPetSuccess extends LayoutState {}

class SqueakGetOwnerDataLoading extends LayoutState {}
class SqueakGetOwnerDataError extends LayoutState {}
class SqueakGetOwnerDataSuccess extends LayoutState {}


class SqueakGetVersionLoading extends LayoutState {}
class SqueakGetVersionError extends LayoutState {}
class SqueakGetVersionSuccess extends LayoutState {}

class GetCurrentVersionLoading extends LayoutState {}
class GetCurrentVersionError extends LayoutState {}
class GetCurrentVersionSuccess extends LayoutState {}

