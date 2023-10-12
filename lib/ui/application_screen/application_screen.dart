import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:poc_glow/data/model/loan_options.dart';

import 'application_screen_bloc.dart';
import 'application_screen_state.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
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
        onWebViewCreated: (controller) async {
          _webViewController = controller;
          _webViewController?.addJavaScriptHandler(
              handlerName: "SELECT_LOAN_OPTION",
              callback: (args) {
                context.read<PaymentSessionBloc>().onLoanOptionsSelected(args);
              });
        },
*/
        initialUrlRequest: URLRequest(
          url: Uri.parse(state.appUrl),
        ),
      );
    }
    return Container();
  }
}
