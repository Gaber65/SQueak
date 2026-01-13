// ignore_for_file: non_constant_identifier_names

import '../../features/layout/post/domain/repository/base_post_repository.dart';
import 'config_model.dart';

/// Base API paths
const String vetCare = '/vetcare';
const String version = '/v1/api';

/// Media URLs
String imageUrl = '${ConfigModel.baseApiUrlSqueak}/files/';
String videoUrl = '${ConfigModel.baseApiUrlSqueak}/files/';
String audioUrl = '${ConfigModel.baseApiUrlSqueak}/files/';
String documentUrl = '${ConfigModel.baseApiUrlSqueak}/files/';
String imageUrlWithVetICare = ConfigModel.serverFirstHalfOfImageUrl;

// chatHubs
String generalHubEndPoint = '${ConfigModel.baseApiUrlSqueak}/generalhub';
String conversationHubEndPoint =
    '${ConfigModel.baseApiUrlSqueak}/conversationhub';

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
const String mergePetsEndPoint = '$version/pets/merge';

/// Clinic Management
const String addClinicEndPoint = '$version/clinics';
const String allClinicEndPoint = '$version/clinics/paggination';
const String updateClinicEndPoint = '$version/clinics/';
const String deleteClinicEndPoint = '$version/clinics/';
const String followClinicEndPoint = '$version/clinics/follow';
const String myClinicsSearchEndPoint = '$version/clinics/withfollowstatus';
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
const String videoHelperEndPoint = '$version/videos';
const String audioHelperEndPoint = '$version/audio';
const String documentHelperEndPoint = '$version/file';

/// Posts
String createPostEndPoint(String postId) => '$version/posts?Id=$postId';
const String getUserPostsEndPoint = '$version/posts/user';
String getPostEndPoint(GetPostParams params) =>
    '$version/posts/user/paggination?pageSize=30&pageNumber=${params.allPostUserPageNumber}&LoginAsPet=${params.isPet}&LoginAsPet=${params.isPet}&MyPetId=${params.petId}';
String getDoctorPostEndPoint(int pageNumber) =>
    '$version/posts/doctor/paggination?pageSize=15&pageNumber=$pageNumber';
const String deletePostEndPoint = '$version/posts';
const String updatePostEndPoint = '$version/posts/';
const String createPostEndPointText = '$version/posts/';

/// React
const String getReactEndPoint = '$version/react/';
const String reactEndPoint = '$version/react';

/// Comments
const String createCommentEndPoint = '$version/comments';
const String getCommentEndPoint = '$version/comments/pagination?PostId=';
const String deleteCommentEndPoint = '$version/comments/';
const String updateCommentEndPoint = '$version/comments/';

/// Contact Us
const String contactUsEndPoint = '$version/tickets';

/// Availabilities
const String createAvailabilitiesEndPoint = '$version/availabilities';
String getAvailabilitiesEndPoint(String clinicCode) =>
    '$version/vetcare/avalibilities?ClinicCode=$clinicCode';
String deleteAvailabilitiesEndPoint(String id) => '$version/availabilities/$id';
String updateAvailabilitiesEndPoint(String id) => '$version/availabilities/$id';

/// Appointments
String createAndGetAppointmentsEndPoint(String phone, bool isApplyFilter) =>
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
    '$version/messages/paggination?pageSize=30&pageNumber=$pageNumber&ClinicId=$clinicId';
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
String getFilesAndPrescriptionForPetEndPoint({required String reservationid}) =>
    '$version/vetcare/PrescriptionAndMedicalTests/$reservationid';

///todo boarding
String boardingTypeEndPoint(String ClinicCode) =>
    '$version/vetcare/BoardingType?ClinicCode=$ClinicCode';
String createBoardingEndPoint = '$version/vetcare/boarding';
String editBoardingEndPoint = '$version/vetcare/updateboarding';
String getAllBoardingEndPoint(String phone) =>
    '$version/vetcare/boarding?ClientPhone=$phone';
String rateBoardingEndPoint = '$version/vetcare/reviewboarding';

///Qr
String qrScanEndPoint = '$version/qr/Scan';

/// PetFriend
const String sendRequestEndPoint = '$version/petrequest/send';
const String updateRequestEndPoint = '$version/petrequest/update';
const String getMyRequestsEndPoint = '$version/petrequest?MyPetId=';
const String getMyFriendsEndPoint = '$version/petfriends?MyPetId=';
const String getBlockedFriendsEndPoint = '$version/petfriends/block?MyPetId=';
const String blockFriendEndPoint = '$version/petfriends/block';
const String unblockFriendEndPoint = '$version/petfriends/unblock';
const String cancelFriendshipEndPoint = '$version/petfriends/cancel';
const String deleteFriendShipEndPoint = '$version/petfriends/delete';
const String searchFriendsEndPoint = '$version/search/petfriends';
const String getSentRequestsEndPoint = '$version/pet/sendrequest?MyPetId=';
const String friendShipCountesEndPoint =
    '$version/general/friendship/counts?PetId=';
String clearChatEndPoint(
  String conversationId, {
  bool deleteForMeOnly = true,
}) => '$version/conversations/$conversationId?DeleteForMeOnly=$deleteForMeOnly';

String deleteMessage(
  String conversationId,
  String messageId,
  bool deleteForMeOnly,
) =>
    '$version/conversations/$conversationId/messages/$messageId?DeleteForMeOnly=$deleteForMeOnly';

/// Mating pet
const String updatePetStatusEndPoint = '$version/pets/';
String getPetProfile(String petId) => '$version/pets/$petId/profile';
String getPetHistoryProfile(String petId) =>
    '$version/pets/id/history?id=$petId';

String getPetHistoryProfileSeperate(String historyId) =>
    '$version/pets/history/$historyId/seperate';
String getPetHistoryProfileSetBaby(String historyId) =>
    '$version/pets/history/$historyId/seperate';
String getPetHistoryProfilePregnant(String historyId) =>
    '$version/pets/history/$historyId/SetBaby';

const String cancelRequestEndPoint = '$version/matingrequest/cancel';
const String getAvailablePetsEndPoint = '$version/pets/available';
const String sendMatingRequestEndPoint = '$version/matingrequest';
const String getPetProfileEndPoint = '$version/pets/profile';
const String getPetsByStatusEndPoint = '$version/pets/profile';
String getMatingRequestsEndPoint(petId) =>
    '$version/matingrequest?PetId=$petId';
String finishMatingRequestsEndPoint = '$version/matingrequest/finish';
String getMatingSentEndPoint(petId) => '$version/mymatingrequest?PetId=$petId';

/// Mating chat
String getChatsEndPoint(petId) =>
    '$version/conversations?ConversationType=1&PetId=$petId';
String getMSGChatsEndPoint(conversationId) =>
    '$version/messages?ConversationId=$conversationId';
String getMessagePagination(conversationId, pageNumber) =>
    '$version/messages/paggination?ConversationId=$conversationId&PageNumber=$pageNumber&PageSize=30';

String sendMSGEndPoint = '$version/messages';
String renameChatEndPoint = '$version/conversations/rename';
String blockChatEndPoint = '$version/conversations/update/blocking';
String rateMatingEndPoint = '$version/matingrequest/rate';

const String createStoryEndPoint = '$version/pet/stories/';
const String deleteStoryEndPoint = '$version/pet/stories/'; // + /{id}
const String myActiveStoriesEndPoint = '$version/mypet/stories/';
const String friendsStoriesEndPoint = '$version/pet/friend/stories/';
String allFriendStoriesEndPoint(id) => '$version/pet/$id/stories';
const String sendReplyMsgToStoryPetEndPoint = '$version/pet/reply/stories';
// Reactions

const String getStoryReactionsEndPoint = '$version/mypet/react/stories/';
const String reactToStoryEndPoint = '$version/pet/stories/react/';

/// login with socail medai
const String loginFacebookEndPoint = '$version/signin-facebook';
const String loginGoogleEndPoint = '$version/signin-google';

/// App State
String? clintId;
String? uId = '';
String token = '';
String refreshToken = '';
String? language;
