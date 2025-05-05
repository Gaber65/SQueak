import 'package:equatable/equatable.dart';

class VersionEntity extends Equatable {
  final String version;
  final String link;
  final bool forceUpdate;
  
  const VersionEntity({
    required this.version,
    required this.link,
    required this.forceUpdate,
  });
  
  @override
  List<Object> get props => [version, link, forceUpdate];
}
