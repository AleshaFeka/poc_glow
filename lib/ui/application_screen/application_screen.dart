import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:poc_glow/ui/main_screen_state.dart';

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
    return BlocConsumer<ApplicationScreenBloc, ApplicationScreenState>(
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
    );
  }

  Widget _buildContent(ApplicationScreenState state) {
    if (state is ApplicationScreenUrlLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ApplicationScreenUrlLoadedState) {
      return InAppWebView(
/*
        onConsoleMessage: (webViewController, consoleMessage) async {
          print("onConsoleMessage = " + jsonDecode(consoleMessage.message.toString()));

          final messageModel = jsonDecode(consoleMessage.message);
          final bloc = context.read<ApplicationScreenBloc>();

          if (messageModel['basket_id'] == bloc.paymentData?.basketId && messageModel['result'] == "FAIL") {
            widget.onDone(Result.fail);
          }
        },
*/
        onLoadStop: (_, __) {
          _webViewController?.evaluateJavascript(source: """addEventListener('message', 
            function(event) {
              if (event.data.result == "FAIL") {
                 window.flutter_inappwebview.callHandler("FINAL_PAGE_CLOSING", "MyFailArgMock")
              }
            }
          ); """);
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
              print("APPLICATION_PAUSED");
              widget.onDone(Result.pending);
            },
          );
          _webViewController?.addJavaScriptHandler(
            handlerName: "FINAL_PAGE_CLOSING",
            callback: (args) {
              //todo handle payload
              print("FINAL_PAGE_CLOSING ${args}");
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
