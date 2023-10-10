import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/data/main_screen_state.dart';
import 'package:poc_glow/data/main_screen_bloc.dart';
import 'package:poc_glow/ui/home_screen/create_payment_session_screen.dart';

import 'shared_widgets/glow_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(state),
          body: _buildScreen(state),
        );
      },
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
        return CreatePaymentSessionScreen(
          onPressed: () {
            context.read<MainScreenBloc>().goToCreatePaymentSession();
          },
        );
      case PaymentSessionState:
        return Container(color: Colors.green, height: 100, width: 100);
      case ApplicationState:
        return Container(color: Colors.yellow, height: 100, width: 100);
      case FinalState:
        return Container(color: Colors.grey, height: 100, width: 100);
    }
    return Container();
  }

  Widget _buildBottomButtons(MainScreenState state) {
    if (state is CreatePaymentSessionState) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GlowButton(
          const EdgeInsets.only(left: 16, right: 16),
          child: const Text("Reset"),
          onPressed: () {
            context.read<MainScreenBloc>().proceedReset();
          },
        ),
        if (state is WebViewInteractionState)
          GlowButton(
            const EdgeInsets.only(right: 16),
            child: const Text("Continue"),
            isAccent: true,
            onPressed: () {
              context.read<MainScreenBloc>().proceedContinue();
            },
          )
      ],
    );
  }

  AppBar? _buildAppBar(MainScreenState state) {
    return state is! WebViewInteractionState
        ? null
        : AppBar(
            title: const Text("widget.title"),
          );
  }
}
