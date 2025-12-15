part of 'contact_us_cubit.dart';

abstract class ContactUsState extends Equatable {
  const ContactUsState();

  @override
  List<Object> get props => [];
}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoadingState extends ContactUsState {}

class ContactUsSuccessState extends ContactUsState {}

class ContactUsErrorState extends ContactUsState {
  final ErrorMessageModel error;
  const ContactUsErrorState(this.error);

  @override
  List<Object> get props => [error];
}
