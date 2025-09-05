import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../../../appointments/exam/data/models/clinic_model.dart';
import '../../../../appointments/exam/domain/entities/clinic_entity.dart';
import '../../../domain/use_case/follow_request_usecase.dart';

part 'follow_request_state.dart';

class FollowRequestCubit extends Cubit<FollowRequestState> {
  final AcceptInvitationUseCase acceptInvitationUseCase;
  final GetNotificationsUseCase getNotificationsUseCase;
  final UpdateNotificationToVetStateUseCase updateNotificationStateUseCase;

  FollowRequestCubit({
    required this.acceptInvitationUseCase,
    required this.getNotificationsUseCase,
    required this.updateNotificationStateUseCase,
  }) : super(FollowRequestInitial());

  static FollowRequestCubit get(context) => BlocProvider.of(context);

  // State variables
  bool isAccept = false;
  bool isFollowBefore = false;
  final List<dynamic> notifications = [];

  Future<void> acceptInvitation({
    required String clinicCode,
    required String clientId,
    required String squeakUserId,
  }) async {
    isAccept = true;
    emit(LoadingAcceptIvationState());

    final params = AcceptInvitationParams(
      clinicCode: clinicCode,
      clientId: clientId,
      squeakUserId: squeakUserId,
    );

    final result = await acceptInvitationUseCase(params);

    result.fold(
      (failure) {
        isAccept = false;
        emit(ErrorAcceptIvationState(failure.error));
      },
      (hasValidPets) {
        isAccept = false;
        emit(SuccessAcceptIvationState(hasValidPets));
      },
    );
  }


  ClinicModel? entities;
  Future getClinicInfo(id) async {
    try {
      Response response = await DioFinalHelper.getData(
        method: '$addClinicEndPoint/$id',
        language: true,
      );

      entities = ClinicModel.fromJson(response.data['data']['clinic']);
      getClientInapp(entities!.code);
    } on DioException catch (e) {
      print(e);
    }
  }

  String clintId = '';
  Future getClientInapp(String code) async {
    getTokenFormFirebase();
    emit(LoadingGetClientState());
    try {
      String username = Username ?? 'Ahmed.Omar@Veticare.com';
      String passwordBasic = password ?? 'Password@123';
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$passwordBasic'))}';
      var dio = Dio();
      Response response = await dio.request(
        '${ConfigModel.baseApiUrlSqueak}$version/vetcare/client/${CacheHelper.getData('phone')}/$code',
        options: Options(
          method: 'GET',
          headers: {'accept': '*/*', 'Authorization': basicAuth},
        ),
      );
      print(response.data);
      print(
        '${ConfigModel.baseApiUrlSqueak}$version/vetcare/client/${CacheHelper.getData('phone')}/$code',
      );
      clintId = response.data['data']['vetICareId'];
      print(clintId);
      emit(SuccessGetClientState());
    } on DioException catch (e) {
      print(e.response);
      emit(ErrorGetClientState());
    }
  }

  String? password;
  String? Username;
  Future getTokenFormFirebase() async {
    try {
      FirebaseFirestore.instance
          .collection('UserToken')
          .doc('Is0fJjcbMCqOrWmQdKoj')
          .snapshots()
          .listen((event) {
            print(event.data());
            Username = event.data()!['Username'];
            password = event.data()!['password'];
          });
    } on Exception catch (e) {
      print(e);
    }
  }


  Future<void> getNotifications(String id) async {
    emit(NotificationsLoadingState());

    final result = await getNotificationsUseCase(id);

    result.fold(
          (failure) {
        emit(NotificationsErrorState());
      },
          (notificationsList) {
        notifications.clear();
        notifications.addAll(notificationsList);

        // Check if we need to update a specific notification
        for (final element in notifications) {
          if (element['notificationEvents'] != null &&
              element['notificationEvents'].isNotEmpty &&
              element['notificationEvents'][0]['id'] == id) {
            updateNotificationState(id);
            break;
          }
        }

        emit(NotificationsSuccessState());
      },
    );
  }

  Future<void> updateNotificationState(String id) async {
    emit(NotificationsLoadingState());

    final result = await updateNotificationStateUseCase(id);

    result.fold(
          (failure) {
        emit(NotificationsErrorState());
      },
          (_) {
        emit(NotificationsSuccessState());
      },
    );
  }
}
