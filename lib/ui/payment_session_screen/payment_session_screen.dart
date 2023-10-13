import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:poc_glow/data/model/loan_options.dart';
import 'package:poc_glow/ui/payment_session_screen/payment_session_state.dart';

import 'payment_session_bloc.dart';

class PaymentSessionScreen extends StatefulWidget {
  final void Function(LoanOptions) onLoanOptionsSelected;

  const PaymentSessionScreen({
    Key? key,
    required this.onLoanOptionsSelected,
  }) : super(key: key);

  @override
  State<PaymentSessionScreen> createState() => _PaymentSessionScreenState();
}

class _PaymentSessionScreenState extends State<PaymentSessionScreen> {
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    context.read<PaymentSessionBloc>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentSessionBloc, PaymentSessionState>(
      listener: (_, state) {
        if (state is PaymentSessionLoanOptionsSelectedState) {
          widget.onLoanOptionsSelected(state.options);
        }
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
    );
  }

  Widget _buildContent(PaymentSessionState state) {
    if (state is PaymentSessionUrlLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is PaymentSessionUrlReadyState) {
      return InAppWebView(
        onWebViewCreated: (controller) async {
          _webViewController = controller;
          _webViewController?.addJavaScriptHandler(
              handlerName: "SELECT_LOAN_OPTION",
              callback: (args) {
                context.read<PaymentSessionBloc>().onLoanOptionsSelected(args);
              });
        },
        initialUrlRequest: URLRequest(
          url: Uri.parse(state.loanUrl),
        ),
      );
    }
    return Container();
  }
}
