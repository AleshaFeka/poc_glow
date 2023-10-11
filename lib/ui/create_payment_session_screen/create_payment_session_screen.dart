import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/ui/create_payment_session_screen/create_payment_session_bloc.dart';
import 'package:poc_glow/ui/shared_widgets/glow_button.dart';

import 'create_payment_session_state.dart';

class CreatePaymentSessionScreen extends StatelessWidget {
  final void Function() onPressed;

  const CreatePaymentSessionScreen({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePaymentSessionBloc, CreatePaymentSessionState>(builder: (context, state) {
      return Expanded(
        child: Center(
          child: SizedBox(
            width: 188,
            child: GlowButton(
              EdgeInsets.zero,
              child: state is LoadedCreatePaymentSessionState
                  ? const Text("Create Payment")
                  : const CircularProgressIndicator(color: Colors.grey,),
              isAccent: true,
              onPressed: state is LoadedCreatePaymentSessionState ? onPressed : null,
            ),
          ),
        ),
      );
    });
  }
}
