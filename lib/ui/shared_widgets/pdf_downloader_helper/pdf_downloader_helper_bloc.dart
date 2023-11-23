import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'pdf_downloader_helper_state.dart';

class PdfDownloaderHelperBloc extends Cubit<PdfDownloadingState> {
  PdfDownloaderHelperBloc() : super(PdfDownloadingInitialState());

  Future<void> startPdfProcessing(String url) async {
    _registerCallback();
    final isStoragePermissionGranted = await _checkStoragePermission();

    if (isStoragePermissionGranted) {
      final sharedDirectoryPath = await _getSharedDirectory();

      if (sharedDirectoryPath != null) {
        _startLoadPdfFile(url, sharedDirectoryPath);
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

    await FlutterDownloader.enqueue(
      fileName: "glowDownload_${DateTime.now().millisecondsSinceEpoch}.pdf",
      url: urlString,
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
      _proceedPdfDownloadFailed();
    }
    if (status == DownloadTaskStatus.running) {
      _proceedPdfInProgress();
    }
  }

  void _proceedPdfDownloadSuccess(String taskId) {
    emit(PdfLoadSuccessState());
    _unregisterCallback();

    //Little delay just to prevent this issue on iOS
    //https://github.com/fluttercommunity/flutter_downloader/issues/248
    Future.delayed(
      Duration(milliseconds: Platform.isIOS ? 500 : 0),
      () {
        FlutterDownloader.open(taskId: taskId);
      },
    );
  }

  void _proceedPdfDownloadFailed() {
    _unregisterCallback();
    emit(PdfLoadFailedState());
  }

  void _proceedPdfInProgress() {
    emit(PdfLoadInProgressState());
  }

  void dispose() {
    _unregisterCallback();
  }

  void _unregisterCallback() {
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
