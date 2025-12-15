class SendMatingRequestParameters {
  final String targetPetId;
  final String message;
  final String senderPetId;

  const SendMatingRequestParameters({
    required this.targetPetId,
    required this.message,
    required this.senderPetId,
  });
}
