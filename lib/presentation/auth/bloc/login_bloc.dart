import 'dart:developer';

import 'package:assignment_travaly/core/services/dio/dio_client.dart';
import 'package:assignment_travaly/core/shared_preferences/auth_storage.dart';
import 'package:assignment_travaly/core/shared_preferences/shared_preferences_keys.dart';
import 'package:assignment_travaly/presentation/auth/data/models/device_info_model.dart';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DioClient dioClient;

  LoginBloc({required this.dioClient}) : super(const LoginState()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));

      final prefs = await SharedPreferences.getInstance();
      final bool isFirstLaunch =
          prefs.getBool(SharedPreferencesKeys.isFirstLaunch) ?? true;

      if (isFirstLaunch) {
        // Register device first
        emit(state.copyWith(status: LoginStatus.deviceRegistering));

        final deviceInfoPlugin = DeviceInfoPlugin();
        final deviceInfo = await deviceInfoPlugin.androidInfo;
        final deviceInfoModel = DeviceInfoModel(
          deviceModel: deviceInfo.model,
          deviceFingerprint: deviceInfo.fingerprint,
          deviceBrand: deviceInfo.brand,
          deviceId: deviceInfo.id,
          deviceName: deviceInfo.name,
          deviceManufacturer: deviceInfo.manufacturer,
          deviceProduct: deviceInfo.product,
          deviceSerialNumber: "unknown",
        );

        log(deviceInfoModel.toString());

        final response = await dioClient.post(
          'deviceRegister',
          data: {'deviceRegister': deviceInfoModel.toJson()},
        );

        if (response.statusCode == 201) {
          log("device registered successfully");
          log(response.data.toString());
          final tkn = response.data['data']['visitorToken'];
          log(tkn);
          await AuthStorage.saveVisitorToken(tkn);

          emit(
            state.copyWith(
              status: LoginStatus.deviceRegistered,
              visitorToken: tkn,
            ),
          );
        } else {
          log(
            "device registration failed with status code ${response.statusCode} and message ${response.statusMessage}",
          );
          emit(
            state.copyWith(
              status: LoginStatus.failure,
              errorMessage: 'Device registration failed',
            ),
          );
          return;
        }

        await prefs.setBool(SharedPreferencesKeys.isFirstLaunch, false);
        log("first launch set false");
      }

      // Sign in successful
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      log("Error during sign in: $e");
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
