class QrCodeEntity {
  final String id;
  final String? petId;
  final DateTime? linkedAt;
  final DateTime? unlinkedAt;
  final bool isActive;

  const QrCodeEntity({
    required this.id,
    this.petId,
    this.linkedAt,
    this.unlinkedAt,
    this.isActive = true,
  });

  bool get isLinked => petId != null && petId!.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'linkedAt': linkedAt?.toIso8601String(),
      'unlinkedAt': unlinkedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory QrCodeEntity.fromJson(Map<String, dynamic> json) {
    return QrCodeEntity(
      id: json['id'] ?? '',
      petId: json['petId'],
      linkedAt: json['linkedAt'] != null ? DateTime.parse(json['linkedAt']) : null,
      unlinkedAt: json['unlinkedAt'] != null ? DateTime.parse(json['unlinkedAt']) : null,
      isActive: json['isActive'] ?? true,
    );
  }

  QrCodeEntity copyWith({
    String? id,
    String? petId,
    DateTime? linkedAt,
    DateTime? unlinkedAt,
    bool? isActive,
  }) {
    return QrCodeEntity(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      linkedAt: linkedAt ?? this.linkedAt,
      unlinkedAt: unlinkedAt ?? this.unlinkedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
