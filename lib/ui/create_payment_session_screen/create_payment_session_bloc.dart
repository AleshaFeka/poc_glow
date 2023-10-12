import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import 'create_payment_session_state.dart';

class CreatePaymentSessionBloc extends Cubit<CreatePaymentSessionState> {
  String? _token;
  CreatePaymentSessionBloc() : super(InitialCreatePaymentSessionState()) {
    init();
  }

  void init() async {
    emit(LoadingCreatePaymentSessionState());
    _token ??= await _fetchToken();

    if (_token != null) {
      emit(LoadedCreatePaymentSessionState(_token as String));
    }
  }

  Future<String> _fetchToken() async {
    var url = Uri.https(
      baseUrl,
      'api/auth/token',
    );
    var response = await http.post(
      url,
      headers: {"Accept": "application/json", "content-type": "application/json"},
      body:
          r'{'
          r'"clientId": "5a94bcc2-b961-4675-b396-c7cf33b3a9e7",'
          r'"clientSecret": "YohGexO9n6auM$6RPygyO6efQAE&PQ4moV#x"'
          r'}',
    );

    final token = jsonDecode(response.body)['token'] as String;
    return token;
  }
}

