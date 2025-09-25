import 'config_model.dart';

/// Base API paths
const String vetCare = '/vetcare';
const String version = '/v1/api';

/// Media URLs
String imageUrl = '${ConfigModel.baseApiUrlSqueak}/files/';
String videoUrl = '${ConfigModel.baseApiUrlSqueak}/files/';
String imageUrlWithVetICare = ConfigModel.serverFirstHalfOfImageUrl; 
// String videoUrlWithVetICare = ConfigModel.serverSecondHalfOfVideoUrl;

/// Auth & User Management
const String registerEndPoint = '$version/signUp';
const String registerQrEndPoint = '$version/qr/signup';
const String followQrEndPoint = '$version/qr/follow';
const String loginEndPoint = '$version/signin';
const String refreshTokenGet = '$version/refresh';
const String verificationCodeEndPoint = '$version/VerifyUser';
const String forgetPasswordEndPoint = '$version/ForgetPassword';
const String resetPasswordEndPoint = '$version/ResetPassword';

/// Pet Management
const String allSpeciesEndPoint = '$version/species';
const String allBreedBySpeciesId = '$version/breed?SpecieId=';
const String allBreed = '$version/breed/';
const String addPetEndPint = '$version/pets';
const String updatePetEndPint = '$version/pets/';
const String deletePetEndPint = '$version/pets/';
const String getOwnerPetEndPoint = '$version/pets/owner';

/// Clinic Management
const String addClinicEndPoint = '$version/clinics';
const String allClinicEndPoint = '$version/clinics/paggination';
const String updateClinicEndPoint = '$version/clinics/';
const String deleteClinicEndPoint = '$version/clinics/';
const String followClinicEndPoint = '$version/clinics/follow';
const String followClinicByCodeEndPoint = '$version/clinics/followbycode';
const String unfollowClinicEndPoint = '$version/clinics/unfollow';
const String blockFollowerEndPoint = '$version/clinics/blockfollower';
const String getFollowerClinicEndPoint = '$version/owners/followings';
String allClinicFollowerEndPoint(String clinicId) =>
    '$version/clinics/$clinicId/followers';

/// Vet Care (Clinic Tools)
const String getClintFormVet = '$version/vetcare/clientpet/';
const String acceptInvitationEndPoint = '$version/vetcare/acceptinivitation/';
const String mergePetFormVet = '$version/vetcare/Pet/Add';

/// Vaccination
const String petVacEndPoint = '$version/petvacs';
const String deleteVacEndPoint = '$version/petvacs/';
const String allVacEndPoint = '$version/vaccinations/';
const String allVacPetEndPoint = '$version/petvacs/';

/// Profile
const String getProfileEndPoint = '$version/owners';
const String updatemyprofileEndPoint = '$version/updatemyprofile';

/// Specialties
const String allSpecialityPetEndPoint = '$version/specailiteis';

/// Media Upload Helpers
const String imageHelperEndPoint = '$version/images';
const String videoHelperEndPoint = '/videos';
const String audioHelperEndPoint = '/audio';

/// Posts
String createPostEndPoint(String postId) => '$version/posts?Id=$postId';
const String getUserPostsEndPoint = '$version/posts/user';
String getPostEndPoint(int pageNumber) =>
    '$version/posts/user/paggination?pageSize=30&pageNumber=$pageNumber';
String getDoctorPostEndPoint(int pageNumber) =>
    '$version/posts/doctor/paggination?pageSize=15&pageNumber=$pageNumber';
const String deletePostEndPoint = '$version/posts';
const String updatePostEndPoint = '$version/posts/';

/// Comments
const String createCommentEndPoint = '$version/comments';
const String getCommentEndPoint = '$version/comments/post/';
const String deleteCommentEndPoint = '$version/comments/';
const String updateCommentEndPoint = '$version/comments/';

/// Contact Us
const String contactUsEndPoint = '$version/tickets';

/// Availabilities
const String createAvailabilitiesEndPoint = '$version/availabilities';
String getAvailabilitiesEndPoint(String clinicCode) =>
    '$version/vetcare/avalibilities?ClinicCode=$clinicCode';
String deleteAvailabilitiesEndPoint(String id) =>
    '$version/availabilities/$id';
String updateAvailabilitiesEndPoint(String id) =>
    '$version/availabilities/$id';

/// Appointments
String createAndGetAppointmentsEndPoint(String phone,bool isApplyFilter) =>
    '$version/vetcare/AllMyPetsRerservations/paginated?ClientPhone=$phone&IsApplyFilter=$isApplyFilter';
const String getAppointmentsEndPoint = '$version/appointments/user';
const String createAndGetReservationsEndPointGetFromNintyDays =
    '$version/vetcare/MyReservation/Today';
const String getAppointmentsDoctorEndPoint = '$version/appointments/doctor';
const String deleteAppointmentsEndPoint = '$version/vetcare/CancelReservation';
String getDoctorAppointmentsEndPoint(String clinicCode) =>
    '$version/vetcare/doctor/$clinicCode';
String getClientClinicEndPoint(String clinicCode, String phone) =>
    '$version/vetcare/pet/$clinicCode/';

/// Version
const String appVersion = '$version/ApplicationVersion/';
const String getVersionEndPoint = '$version/ApplicationVersion/1';
const String getVersionEndPointIOS = '$version/ApplicationVersion/2';

/// FCM
const String sendtoken = '$version/fbusertokens';
const String updateapplangauge = '$version/updateapplangauge';
const String messageKey =
    'key=AAAApN7ozIk:APA91bH9LkCCvQxp57so-6g0QAIGxO2Sd6bTpc2JV1MoysX0NZp0BjggELSJVYOzEVTWsbiQYLQxMC9ON-0tcDsCKeMIOjLAqAx61tRuOMxMvGSE7lFI9qdRM6ZemLVP1sPY8hNzDK9l';
const String baseUrlMessageKey = 'https://fcm.googleapis.com/fcm/send';

/// Chat
String sendMassageEndPoint = '$version/messages';
String getMassageUserEndPoint(String clinicId, int pageNumber) =>
    '$version/messages/paggination?pageSize=50&pageNumber=$pageNumber&ClinicId=$clinicId';
String getMassageAdminEndPoint({
  required String clinicId,
  required String userId,
  required int pageNumber,
}) =>
    '$version/messages/paggination?pageSize=50&pageNumber=$pageNumber&UserId=$userId&ClinicId=$clinicId';

/// VetCare Features
const String printReceiptEndPoint = '$version/vetcare/print/reciept';
const String rateAppointmentEndPoint = '$version/vetcare/reviewreservation';
const String vetIcareReigster = '$version/signup/vetcare';
const String getVetClient = '$version/vetcare/client/';
const String invoiveEndPoint = '$version/vetcare/print/reciept/';

/// Files & Prescriptions
const String getFilesAndPrescriptionForPet =
    '$version/vetcare/PrescriptionAndMedicalTests/6fc7968e-b080-423e-af4a-1e7c8ff60be5';
String getFilesAndPrescriptionForPetEndPoint({
  required String reservationid,
}) =>
    '$version/vetcare/PrescriptionAndMedicalTests/$reservationid';
///todo boarding
String boardingTypeEndPoint(String ClinicCode) => '$version/vetcare/BoardingType?ClinicCode=$ClinicCode';
String createBoardingEndPoint  = '$version/vetcare/boarding';
String editBoardingEndPoint  = '$version/vetcare/updateboarding';
String getAllBoardingEndPoint(String phone) =>
    '$version/vetcare/boarding?ClientPhone=$phone';
String rateBoardingEndPoint  = '$version/vetcare/reviewboarding';

///Qr
String qrScanEndPoint  = '$version/qr/Scan';

/// App State
String? clintId;
String? uId = '';
String token = '';
String refreshToken = '';
String? language;

