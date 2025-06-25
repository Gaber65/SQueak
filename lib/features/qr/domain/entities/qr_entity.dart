class QrEntity {
  final String id;
  final String? petId;
  final DateTime? linkedAt;
  final DateTime? unlinkedAt;

  const QrEntity({
    required this.id,
    this.petId,
    this.linkedAt,
    this.unlinkedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'linkedAt': linkedAt?.toIso8601String(),
      'unlinkedAt': unlinkedAt?.toIso8601String(),
    };
  }

  factory QrEntity.fromJson(Map<String, dynamic> json) {
    return QrEntity(
      id: json['id'],
      petId: json['petId'],
      linkedAt: json['linkedAt'] != null ? DateTime.parse(json['linkedAt']) : null,
      unlinkedAt: json['unlinkedAt'] != null ? DateTime.parse(json['unlinkedAt']) : null,
    );
  }
}
