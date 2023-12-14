import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/ui/create_payment_session_screen/create_payment_session_bloc.dart';
import 'package:poc_glow/ui/shared_widgets/glow_button.dart';

import '../../main.dart';
import '../main_screen_bloc.dart';
import 'create_payment_session_state.dart';

class CreatePaymentSessionScreen extends StatefulWidget {
  final void Function(String) onPressed;
  final void Function() onBackButtonPressed;

  const CreatePaymentSessionScreen({required this.onPressed, Key? key, required this.onBackButtonPressed})
      : super(key: key);

  @override
  State<CreatePaymentSessionScreen> createState() => _CreatePaymentSessionScreenState();
}

class _CreatePaymentSessionScreenState extends State<CreatePaymentSessionScreen> {
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
        widget.onBackButtonPressed();
        return false;
      },
      child: BlocBuilder<CreatePaymentSessionBloc, CreatePaymentSessionState>(builder: (_, state) {
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
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
                            widget.onPressed(state.token);
                          }
                        : null,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dark Theme", style: Theme.of(context).textTheme.bodyLarge),
                    Checkbox(
                      value: context.read<MainScreenBloc>().isDarkTheme,
                      onChanged: (isDarkTheme) {
                        context.read<MainScreenBloc>().darkTheme = isDarkTheme ?? false;
                        setState(() {
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
