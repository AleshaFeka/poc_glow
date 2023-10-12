import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/ui/application_screen/application_screen_bloc.dart';
import 'package:poc_glow/ui/main_screen_bloc.dart';
import 'package:poc_glow/ui/create_payment_session_screen/create_payment_session_screen.dart';
import 'package:poc_glow/ui/final_screen/final_screen.dart';
import 'package:poc_glow/ui/payment_session_screen/payment_session_screen.dart';

import 'application_screen/application_screen.dart';
import 'create_payment_session_screen/create_payment_session_bloc.dart';
import 'main_screen_state.dart';
import 'payment_session_screen/payment_session_bloc.dart';
import 'shared_widgets/glow_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _createPaymentSessionBloc = CreatePaymentSessionBloc();
  final _paymentSessionBloc = PaymentSessionBloc();
  final _applicationScreenBloc = ApplicationScreenBloc();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<MainScreenBloc>().proceedReset();
        return false;
      },
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(state),
            body: _buildScreen(state),
          );
        },
      ),
    );
  }

  Widget _buildScreen(MainScreenState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildContent(state),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildBottomButtons(state),
          )
        ],
      ),
    );
  }

  Widget _buildContent(MainScreenState state) {
    switch (state.runtimeType) {
      case CreatePaymentSessionState:
        return BlocProvider.value(
          value: _createPaymentSessionBloc,
          child: CreatePaymentSessionScreen(
            onPressed: (token) {
              context.read<MainScreenBloc>().goToCreatePaymentSession(token);
            },
          ),
        );
      case PaymentSessionState:
        _paymentSessionBloc.token = (state as PaymentSessionState).token;
        return BlocProvider.value(
          value: _paymentSessionBloc,
          child: PaymentSessionScreen(
            onLoanOptionsSelected: (loanOptions) {
              context.read<MainScreenBloc>().onLoanOptionsSelected(loanOptions);
            },
          ),
        );
      case ApplicationState:
        _applicationScreenBloc.options = (state as ApplicationState).options;
        _applicationScreenBloc.paymentData = _paymentSessionBloc.model;
        return BlocProvider.value(
          value: _applicationScreenBloc,
          child: ApplicationScreen(),
        );
      case FinalState:
        return FinalScreen();
    }
    return Container();
  }

  Widget _buildBottomButtons(MainScreenState state) {
    if (state is CreatePaymentSessionState) return Container();

    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: GlowButton(
              const EdgeInsets.only(left: 16, right: 16),
              child: const Text("Reset"),
              onPressed: () {
                context.read<MainScreenBloc>().proceedReset();
              },
            ),
          ),
          if (state is PaymentSessionState)
            Expanded(
              child: GlowButton(
                const EdgeInsets.only(right: 16),
                child: const Text("Continue"),
                isAccent: true,
                onPressed: state.isAbleToContinue
                    ? () {
                        context.read<MainScreenBloc>().proceedContinue();
                      }
                    : null,
              ),
            )
        ],
      ),
    );
  }

  AppBar? _buildAppBar(MainScreenState state) {
    return state is! WebViewInteractionState
        ? null
        : AppBar(
            title: Row(
              children: const [
                BackButton(),
                Text("Back"),
              ],
            ),
          );
  }
}
