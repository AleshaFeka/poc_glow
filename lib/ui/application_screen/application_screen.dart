import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:poc_glow/data/model/result.dart';

import 'application_screen_bloc.dart';
import 'application_screen_state.dart';

class ApplicationScreen extends StatefulWidget {
  final Function(Result) onDone;

  const ApplicationScreen({Key? key, required this.onDone}) : super(key: key);

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    context.read<ApplicationScreenBloc>().init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ApplicationScreenBloc>().onWillPop();
        return false;
      },
      child: BlocConsumer<ApplicationScreenBloc, ApplicationScreenState>(
        listener: (BuildContext context, state) {},
        builder: (_, state) {
          return Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD9D9D9),
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: _buildContent(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(ApplicationScreenState state) {
    if (state is ApplicationScreenUrlLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ApplicationScreenNoPermissionsGrantedState) {
      return const Center(child: Text("No Permissions Granted."));
    }
    if (state is ApplicationScreenUrlLoadedState) {
      return InAppWebView(
        androidOnPermissionRequest: (_, __, resources) async {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT,
          );
        },
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(mediaPlaybackRequiresUserGesture: false),
        ),
        onLoadStop: (_, __) {
          context.read<ApplicationScreenBloc>().onLoadStop();
        },
        onWebViewCreated: (controller) async {
          _webViewController = controller;
          _webViewController?.addJavaScriptHandler(
            handlerName: "APPLICATION_COMPLETED",
            callback: (args) {
              print("APPLICATION_COMPLETED");
              widget.onDone(Result.success);
            },
          );
          _webViewController?.addJavaScriptHandler(
            handlerName: "APPLICATION_PAUSED",
            callback: (args) {
              widget.onDone(Result.pending);
            },
          );
          _webViewController?.addJavaScriptHandler(
            handlerName: "APPLICATION_CANCEL_ACCEPTED",
            callback: (args) {
              widget.onDone(Result.cancelAccepted);
            },
          );
          _webViewController?.addJavaScriptHandler(
            handlerName: "APPLICATION_PAUSE_ACCEPTED",
            callback: (args) {
              widget.onDone(Result.pauseAccepted);
            },
          );
          _webViewController?.addJavaScriptHandler(
            handlerName: "APPLICATION_CANCELLED",
            callback: (args) {
              widget.onDone(Result.fail);
            },
          );
        },
        initialUrlRequest: URLRequest(
          url: Uri.parse(state.appUrl),
        ),
      );
    }
    return Container();
  }
}
