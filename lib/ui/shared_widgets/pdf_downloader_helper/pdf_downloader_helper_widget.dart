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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PdfDownloaderHelperBloc, PdfDownloadingState>(builder: (_, state) {
      return Stack(children: [
        widget.child,
        _buildPdfTestState(state)
      ]);
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
          color: Colors.blue,
          child: Text("PermissionDeniedStateState"),
        );
        break;
      case PdfLoadInProgressState:
        resultWidget = const CircularProgressIndicator(
          color: Colors.blue,
        );
        break;
      case PdfLoadFailedState:
        resultWidget = Container(
          color: Colors.yellow,
          child: Text("PdfLoadFailedState"),
        );
        break;
      case PdfLoadSuccessState:
        resultWidget = Container(
          color: Colors.orange,
          child: Text("PdfLoadSuccessState"),
        );
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
