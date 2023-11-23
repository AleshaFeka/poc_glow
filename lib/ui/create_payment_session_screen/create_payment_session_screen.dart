import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/ui/create_payment_session_screen/create_payment_session_bloc.dart';
import 'package:poc_glow/ui/shared_widgets/glow_button.dart';

import '../../main.dart';
import 'create_payment_session_state.dart';

class CreatePaymentSessionScreen extends StatelessWidget {
  final void Function(String) onPressed;
  final void Function() onBackButtonPressed;

  const CreatePaymentSessionScreen({required this.onPressed, Key? key, required this.onBackButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        onBackButtonPressed();
        return false;
      },
      child: BlocBuilder<CreatePaymentSessionBloc, CreatePaymentSessionState>(builder: (_, state) {
        return Expanded(
          child: Center(
            child: SizedBox(
              width: 188,
              child: GlowButton(
                EdgeInsets.zero,
                child: state is LoadedCreatePaymentSessionState
                    ? const Text("Create Payment")
                    : const CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                isAccent: true,
                onPressed: state is LoadedCreatePaymentSessionState
                    ? () {
                        onPressed(state.token);
                      }
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}
