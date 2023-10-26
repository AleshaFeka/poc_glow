import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:poc_glow/data/model/loan_options.dart';
import 'package:poc_glow/ui/main_screen_bloc.dart';
import 'package:poc_glow/ui/payment_session_screen/payment_session_state.dart';

import 'payment_session_bloc.dart';

class PaymentSessionScreen extends StatefulWidget {
  final void Function(LoanOptions) onLoanOptionsSelected;
  final void Function() onBackButtonPressed;

  const PaymentSessionScreen({
    Key? key,
    required this.onLoanOptionsSelected,
    required this.onBackButtonPressed,
  }) : super(key: key);

  @override
  State<PaymentSessionScreen> createState() => _PaymentSessionScreenState();
}

class _PaymentSessionScreenState extends State<PaymentSessionScreen> {
  final InAppWebViewGroupOptions _inAppWebViewGroupOptions = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
        mediaPlaybackRequiresUserGesture: false,
        preferredContentMode: UserPreferredContentMode.MOBILE,
        supportZoom: false,
        javaScriptEnabled: true,
        transparentBackground: false,
        useShouldInterceptFetchRequest: false,
        useShouldInterceptAjaxRequest: false,
        useShouldOverrideUrlLoading: true,
        allowFileAccessFromFileURLs: false,
        allowUniversalAccessFromFileURLs: false),
    ios: IOSInAppWebViewOptions(
      contentInsetAdjustmentBehavior: IOSUIScrollViewContentInsetAdjustmentBehavior.AUTOMATIC,
      applePayAPIEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: false,
      useShouldInterceptRequest: true,
      allowContentAccess: false,
      mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      allowFileAccess: false,
      domStorageEnabled: false,
      geolocationEnabled: false,
    ),
  );

  InAppWebViewController? _webViewController;
  double _webViewContainerHeight = 2500;

  @override
  void initState() {
    super.initState();
    context.read<PaymentSessionBloc>().init();
    context.read<MainScreenBloc>().themeChangeNotifier.setSingleListener(
          context.read<PaymentSessionBloc>().onThemeChanged,
        );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onBackButtonPressed();
        return false;
      },
      child: BlocConsumer<PaymentSessionBloc, PaymentSessionState>(
        listener: (_, state) {
          if (state is PaymentSessionLoanOptionsSelectedState) {
            widget.onLoanOptionsSelected(state.options);
          }

          if (state is PaymentSessionThemeChangedState) {
            _notifyThemeChanged(state.brightness);
          }
        },
        buildWhen: (_, currentState) {
          return currentState is! PaymentSessionThemeChangedState;
        },
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

  void _notifyThemeChanged(Brightness brightness) {
    final themeName = brightness == Brightness.light ? "LIGHT" : "DARK";
    _webViewController?.evaluateJavascript(source: """
              window.dispatchEvent(new Event('THEME_CHANGED', {"theme" : "$themeName"}));             
    """);
  }

  Widget _buildContent(PaymentSessionState state) {
    if (state is PaymentSessionUrlLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is PaymentSessionUrlReadyState) {
      return SingleChildScrollView(
        child: SizedBox(
          height: _webViewContainerHeight,
          child: InAppWebView(
            shouldOverrideUrlLoading: context.read<PaymentSessionBloc>().onOverrideUrl,
            initialOptions: _inAppWebViewGroupOptions,
            onWebViewCreated: (controller) async {
              _webViewController = controller;

              _webViewController?.addJavaScriptHandler(
                handlerName: "SELECT_LOAN_OPTION",
                callback: _onLoanOptionSelected,
              );

              _webViewController?.addJavaScriptHandler(
                handlerName: "SET_WEB_VIEW_HEIGHT_HANDLER",
                callback: _onHeightChanged,
              );
            },
            onLoadStop: (_, __) {
              _notifyThemeChanged(context.read<MainScreenBloc>().themeChangeNotifier.getCurrentSystemBrightness());
            },
            initialUrlRequest: URLRequest(
              url: Uri.parse(state.loanUrl),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  void _onLoanOptionSelected(List<dynamic> args) {
    context.read<PaymentSessionBloc>().onLoanOptionsSelected(args);
    _webViewController?.evaluateJavascript(source: """
                      window.flutter_inappwebview.callHandler(
                        'SET_WEB_VIEW_HEIGHT_HANDLER', 
                        {"webViewScrollHeight" :document.querySelector('div').scrollHeight}
                      );
                    """);
  }

  void _onHeightChanged(dynamic args) {
    final data = args.first;

    if (data['webViewScrollHeight'] != null) {
      double newHeight = 0.0;
      try {
        newHeight = double.parse(data['webViewScrollHeight'].toString());
      } catch (ignored) {
        //Just ignore, not change height.
      }

      if (newHeight > 0.0) {
        setState(() {
          _webViewContainerHeight = newHeight;
        });
      }
    }
  }
}
