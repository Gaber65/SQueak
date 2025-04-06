import 'package:equatable/equatable.dart';

abstract class AboutState extends Equatable {
  const AboutState();

  @override
  List<Object> get props => [];
}

// Initial state
class AboutInitial extends AboutState {}

// Loading state
class AboutLoading extends AboutState {}

// Loaded state with version number
class AboutLoaded extends AboutState {
  final String version;

  const AboutLoaded(this.version);

  @override
  List<Object> get props => [version];
}

// Error state
class AboutError extends AboutState {
  final String message;

  const AboutError(this.message);

  @override
  List<Object> get props => [message];
}
