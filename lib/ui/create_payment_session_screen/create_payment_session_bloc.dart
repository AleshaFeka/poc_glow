import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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
    _registerCallback();
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
        _startLoadPdfFile("", sharedDirectoryPath);
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

  Future<void> _startLoadPdfFile(String urlString, String targetDirPath) async {
    emit(PdfLoadInProgressState());

    FlutterDownloader.enqueue(
      fileName: "glowDownload_${DateTime.now().millisecond}.pdf",
      url: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
      headers: {},
      savedDir: targetDirPath,
      saveInPublicStorage: false,
      showNotification: false,
      openFileFromNotification: false,
    );
  }

  void _proceedPdfDownloadingResult(DownloadTaskStatus status, String taskId) {
    if (status == DownloadTaskStatus.complete) {
      _proceedPdfDownloadSuccess(taskId);
    }
    if (status == DownloadTaskStatus.failed) {
      _proceedPdfDownloadFailed(taskId);
    }
    if (status == DownloadTaskStatus.running) {
      _proceedPdfInProgress(taskId);
    }
  }

  void _proceedPdfDownloadSuccess(String taskId) {
    emit(PdfLoadSuccessState());
    FlutterDownloader.open(taskId: taskId);
  }

  void _proceedPdfDownloadFailed(String taskId) {
    emit(PdfLoadFailedState());
  }

  void _proceedPdfInProgress(String taskId) {
    emit(PdfLoadInProgressState());
  }

  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _registerCallback() {
    ReceivePort _port = ReceivePort();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      _proceedPdfDownloadingResult(
        DownloadTaskStatus.values[data[1]],
        data[0],
      );
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }
}
