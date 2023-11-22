import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import 'create_payment_session_state.dart';

class CreatePaymentSessionBloc extends Cubit<CreatePaymentSessionState> {
  String? _token;

  CreatePaymentSessionBloc() : super(InitialCreatePaymentSessionState()) {
    init();
  }

  void init() async {
/*
    emit(LoadingCreatePaymentSessionState());
    _token ??= await _fetchToken();

    if (_token != null) {
      emit(LoadedCreatePaymentSessionState(_token as String));
    }
*/
    emit(LoadedCreatePaymentSessionState("token loaded"));
  }

  Future<String> _fetchToken() async {
    var url = Uri.https(
      baseUrl,
      'api/auth/token',
    );
    var response = await http.post(
      url,
      headers: {"Accept": "application/json", "content-type": "application/json"},
      body: r'{'
          r'"clientId": "5a94bcc2-b961-4675-b396-c7cf33b3a9e7",'
          r'"clientSecret": "YohGexO9n6auM$6RPygyO6efQAE&PQ4moV#x"'
          r'}',
    );

    final token = jsonDecode(response.body)['token'] as String;
    return token;
  }

  Future<void> startPdfProcessing(String url) async {
    final isStoragePermissionGranted = await _checkStoragePermission();

    if (isStoragePermissionGranted) {
      final sharedDirectoryPath = await _getSharedDirectory();

      if (sharedDirectoryPath != null) {
        final glowPocDir = Directory(sharedDirectoryPath + "/TestGlowDir");
        print("glowPocDir.exists ${await glowPocDir.exists()}");

        print("glowPocDir.create ${glowPocDir.path}");
        glowPocDir.create(recursive: false);

        final testFile = File('${glowPocDir.path}/test.txt');
        testFile.create(recursive: false);
        testFile.writeAsString("msg");
        if (!(await glowPocDir.exists())) {
        }

        _startLoadPdfFile();
      } else {
        emit(StoragePermissionDeniedStateState());
      }

    } else {
      emit(StoragePermissionDeniedStateState());
    }
  }

  Future<String?> _getSharedDirectory() async {
    Directory documents = Directory("");

    if (Platform.isAndroid) {
      final temp = await getExternalStorageDirectory();
      if (temp != null) {
        documents = temp;
      } else {
        return null;
      }
    } else if (Platform.isIOS) {
      documents = await getApplicationDocumentsDirectory();
    }

    return documents.path;
  }

  Future<bool> _checkStoragePermission() async {
    final storagePermission = await Permission.storage.request();
    return storagePermission == PermissionStatus.granted;
  }

  void _startLoadPdfFile() {
    print("_startLoadPdfFile");
    emit(PdfLoadInProgressState());
  }
}
