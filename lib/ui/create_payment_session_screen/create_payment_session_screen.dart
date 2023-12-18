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
  final TextEditingController firstNameEditingController = TextEditingController(text: "");
  final TextEditingController lastNameEditingController = TextEditingController(text: "");
  final TextEditingController basketValueEditingController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    firstNameEditingController.text = context.read<MainScreenBloc>().customerFirstName;
    lastNameEditingController.text = context.read<MainScreenBloc>().customerLastName;
    basketValueEditingController.text = context.read<MainScreenBloc>().basketValue.toString();

    return WillPopScope(
      onWillPop: () async {
        widget.onBackButtonPressed();
        return false;
      },
      child: BlocBuilder<CreatePaymentSessionBloc, CreatePaymentSessionState>(builder: (_, state) {
        return Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Environment: "),
                      const SizedBox(
                        width: 8,
                      ),
                      DropdownButton<String>(
                        value: envUrls.entries
                            .firstWhere((element) => element.value == context.read<MainScreenBloc>().envUrl)
                            .key,
                        onChanged: (String? value) {
                          if (value != null) {
                            final newValue = envUrls.entries.firstWhere((element) => element.key == value).value;
                            context.read<MainScreenBloc>().envUrl = newValue;
                            setState(() {});
                          }
                        },
                        items: envUrls.keys
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: firstNameEditingController,
                    onChanged: (v) => context.read<MainScreenBloc>().customerFirstName = v,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Customer first name',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: lastNameEditingController,
                    onChanged: (v) => context.read<MainScreenBloc>().customerLastName = v,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Customer last name',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: basketValueEditingController,
                    keyboardType: TextInputType.phone,
                    onChanged: (v) => context.read<MainScreenBloc>().basketValue = v,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Basket value',
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
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 36,
                  ),
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
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
