enum UploadPlace {
  postImages(1),
  petsImages(2),
  uploads(3),
  usersImages(4),
  postVideos(5),
  commentImages(6),
  clinicImage(7),
  messageImage(8),
  messageVideo(9),
  messageRecord(11),
  storyImages(12),
  passportImages(10);

  final int value;

  const UploadPlace(this.value);
}
