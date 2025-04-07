import 'config_model.dart';

/// todo API
const String vetCare = '/vetcare';
const String version = '/v1/api';
String imageUrl = '${ConfigModel.baseApiUrlSqueak}/files/';

String imageUrlWithVetICare = '${ConfigModel.serverFirstHalfOfImageUrl}';

/// todo signUp
const String registerEndPoint = '$version/signUp';
const String registerQrEndPoint = '$version/qr/signup';
const String followQrEndPoint = '$version/qr/follow';
const String loginEndPoint = '$version/signin';
const String refreshTokenGet = '$version/refresh';
const String verificationCodeEndPoint = '$version/VerifyUser';
const String forgetPasswordEndPoint = '$version/ForgetPassword';
const String resetPasswordEndPoint = '$version/ResetPassword';

///todo pet
const String allSpeciesEndPoint = '$version/species';
const String allBreedBySpeciesId = '$version/breed?SpecieId=';
const String allBreed = '$version/breed/';
const String addPetEndPint = '$version/pets';
const String updatePetEndPint = '$version/pets/';
const String deletePetEndPint = '$version/pets/';
const String getOwnerPetEndPoint = '$version/pets/owner';

/// todo Clinic
const String addClinicEndPoint = '$version/clinics';
const String getClintFormVet = '$version/vetcare/clientpet/';
const String acceptInvitation = '$version/vetcare/acceptinivitation/';
const String mergePetFormVet = '$version/vetcare/Pet/Add';
const String allClinicEndPoint = '$version/clinics/paggination';
const String updateClinicEndPoint = '$version/clinics/';
const String deleteClinicEndPoint = '$version/clinics/';
const String followClinicEndPoint = '$version/clinics/follow';
const String followClinicByCodeEndPoint = '$version/clinics/followbycode';
const String unfollowClinicEndPoint = '$version/clinics/unfollow';
String allClinicFollowerEndPoint(String clinicId) =>
    '$version/clinics/$clinicId/followers';
const String blockFollowerEndPoint = '$version/clinics/blockfollower';
const String getFollowerClinicEndPoint = '$version/owners/followings';
String? clintId;
String? uId = '';
String token = '';
String refreshToken = '';

///todo Vaccination
const String petVacEndPoint = '$version/petvacs';
const String deleteVacEndPoint = '$version/petvacs/';
const String allVacEndPoint = '$version/vaccinations/';
const String allVacPetEndPoint = '$version/petvacs/';

///todo Profile
const String getProfileEndPoint = '$version/owners';
const String updatemyprofileEndPoint = '$version/updatemyprofile';

///todo Speciality
const String allSpecialityPetEndPoint = '$version/specailiteis';

///todo helper
const String imageHelperEndPoint = '$version/images';
const String videoHelperEndPoint = '/videos';
const String audioHelperEndPoint = '/audio';

///todo posts
String createPostEndPoint(postId) => '$version/posts?Id=$postId';
const String getUserPostsEndPoint = '$version/posts/user';
String getPostEndPoint(
  int pageNumber,
) {
  return '$version/posts/user/paggination?pageSize=100&pageNumber=$pageNumber';
}

String getDoctorPostEndPoint(
  int pageNumber,
) {
  return '$version/posts/doctor/paggination?pageSize=15&pageNumber=$pageNumber';
}

const String deletePostEndPoint = '$version/posts';
const String updatePostEndPoint = '$version/posts/';

///todo Comment
const String createCommentEndPoint = '$version/comments';
const String getCommentEndPoint = '$version/comments/post/';
const String deleteCommentEndPoint = '$version/comments/';
const String updateCommentEndPoint = '$version/comments/';

///todo Contact_us
const String contactUsEndPoint = '$version/tickets';

///todo Availabilities
const String createAvailabilitiesEndPoint = '$version/availabilities';
String getAvailabilitiesEndPoint(String ClinicCode) =>
    '$version/vetcare/avalibilities?ClinicCode=$ClinicCode';
String deleteAvailabilitiesEndPoint(String availabilitiesId) =>
    '$version/availabilities/$availabilitiesId';
String updateAvailabilitiesEndPoint(String availabilitiesId) =>
    '$version/availabilities/$availabilitiesId';

///todo Appointments
String createAndGetAppointmentsEndPoint(String phone) =>
    '$version/vetcare/AllMyPetsRerservations/paginated?ClientPhone=$phone';
String getAppointmentsEndPoint = '$version/appointments/user';
String createAndGetReservationsEndPointGetFromNintyDays =
    '$version/vetcare/MyReservation/Today';
String getAppointmentsDoctorEndPoint = '$version/appointments/doctor';
String deleteAppointmentsEndPoint = '$version/vetcare/CancelReservation';
String getDoctorAppointmentsEndPoint(String ClinicCode) =>
    '$version/vetcare/doctor/$ClinicCode';
String getClientClinicEndPoint(String ClinicCode, String phone) =>
    '$version/vetcare/pet/$ClinicCode/';

/// app version
const String appVersion = '$version/ApplicationVersion/';

/// FCB token
const String sendtoken = '$version/fbusertokens';
const String updateapplangauge = '$version/updateapplangauge';

/// rate appointment
const String rateAppointment = '$version/vetcare/reviewreservation';

///todo Chat
String sendMassageEndPoint = '$version/messages';
String getMassageUserEndPoint(String clinicId, int pageNumber) =>
    '$version/messages/paggination?pageSize=50&pageNumber=$pageNumber&ClinicId=$clinicId';
String getMassageAdminEndPoint({
  required String clinicId,
  required String userId,
  required int pageNumber,
}) {
  return '$version/messages/paggination?pageSize=50&pageNumber=$pageNumber&UserId=$userId&ClinicId=$clinicId';
}

const String messageKey =
    'key=AAAApN7ozIk:APA91bH9LkCCvQxp57so-6g0QAIGxO2Sd6bTpc2JV1MoysX0NZp0BjggELSJVYOzEVTWsbiQYLQxMC9ON-0tcDsCKeMIOjLAqAx61tRuOMxMvGSE7lFI9qdRM6ZemLVP1sPY8hNzDK9l';
const String baseUrlMessageKey = 'https://fcm.googleapis.com/fcm/send';

String? language;

///todo vetcare
const String printReceiptEndPoint = '$version/vetcare/print/reciept';
const String rateAppointmentEndPoint = '$version/vetcare/reviewreservation';
const String vetIcareReigster = '$version/signup/vetcare';
const String getVetClient = '$version/vetcare/client/';
const String invoiveEndPoint = '$version/vetcare/print/reciept/';

/// todo Version
const String getVersionEndPoint = '$version/ApplicationVersion/1';
const String getVersionEndPointIOS = '$version/ApplicationVersion/2';

/// todo files_and_prescription_for_pet
const String getFilesAndPrescriptionForPet =
    '$version/vetcare/PrescriptionAndMedicalTests/6fc7968e-b080-423e-af4a-1e7c8ff60be5';

String getFilesAndPrescriptionForPetEndPoint({
  required String reservationid,
}) {
  return '$version/vetcare/PrescriptionAndMedicalTests/$reservationid';
}
