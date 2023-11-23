import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pdf_downloader_helper_bloc.dart';
import 'pdf_downloader_helper_state.dart';

class PdfDownloaderHelperWidget extends StatefulWidget {
  final Widget child;

  const PdfDownloaderHelperWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<PdfDownloaderHelperWidget> createState() => _PdfDownloaderHelperWidgetState();
}

class _PdfDownloaderHelperWidgetState extends State<PdfDownloaderHelperWidget> {
  bool successVisibility = false;
  bool showIconSuccess = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PdfDownloaderHelperBloc, PdfDownloadingState>(builder: (_, state) {
      return Stack(children: [widget.child, _buildPdfTestState(state)]);
    });
  }

  Widget _buildPdfTestState(PdfDownloadingState state) {
    Widget resultWidget = Container();

    switch (state.runtimeType) {
      case CheckingStoragePermissionState:
        resultWidget = const CircularProgressIndicator(
          color: Colors.grey,
        );
        break;
      case StoragePermissionDeniedStateState:
        resultWidget = Container(
          color: Colors.red,
          child: Text("PermissionDeniedStateState"),
        );
        break;
      case PdfLoadInProgressState:
        successVisibility = true;
        showIconSuccess = true;
        resultWidget = const CircularProgressIndicator(
          color: Colors.blue,
        );
        break;
      case PdfLoadFailedState:
        resultWidget = Container(
          color: Colors.red,
          child: Text("PdfLoadFailedState"),
        );
        break;
      case PdfLoadSuccessState:
        if (showIconSuccess) {
          Timer(const Duration(milliseconds: 500), () {
            setState(() {
              successVisibility = false;
            });
          });
          resultWidget = AnimatedOpacity(
            opacity: successVisibility ? 1 : 0,
            duration: const Duration(milliseconds: 1000),
            onEnd: () {
              showIconSuccess = false;
            },
            child: Image.asset("assets/images/ic_success.png"),
          );
        } else {
          const Placeholder();
        }
        break;
    }

    return Center(child: resultWidget);
  }

  @override
  void dispose() {
    context.read<PdfDownloaderHelperBloc>().dispose();
    super.dispose();
  }
}
