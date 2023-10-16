import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poc_glow/ui/application_screen/application_screen_state.dart';

import '../../data/model/loan_options.dart';
import '../../data/model/payment_session_data_model.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class ApplicationScreenBloc extends Cubit<ApplicationScreenState> {
  LoanOptions? options;
  PaymentSessionDataModel? paymentData;

  ApplicationScreenBloc() : super(ApplicationScreenInitialState());

  void init() async {
    emit(ApplicationScreenUrlLoadingState());

    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();

    if (cameraPermission != PermissionStatus.granted || microphonePermission != PermissionStatus.granted) {
      emit(ApplicationScreenNoPermissionsGrantedState());
    } else {
      var url = Uri.https(
        baseUrl,
        'api/ee/application/initialize',
      );
      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer ${paymentData?.token}",
          "content-type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(_buildMockBody()),
      );

      if (jsonDecode(response.body)['application_url'] != null) {
        emit(ApplicationScreenUrlLoadedState(appUrl: jsonDecode(response.body)['application_url']));
      }
    }
  }

  Map<String, Object> _buildMockBody() {
    return {
      "session_id": paymentData?.sessionId ?? "",
      "locale": "en-GB",
      "theme": "dark",
      "notification_url": "The URL where glow will send notifications to",
      "loan_option": {
        "monthly_payment": options?.payload.monthlyPayment, // (required)
        "upfront_payment": options?.payload.upfrontPayment, // (required)
        "interest_rate": options?.payload.interestRate, // (required)
        "term": options?.payload.term, // (required)
        "loan_product_id": "Ee_Product_COM"
      },
      "customer": {
        "customer_id": "a98853f9-9763-4929-9aca-1da3eec3be84",
        "customer_authentication": "password only",
        "customer_tenure": 60,
        "type_of_customer": "EE",
        "inGoodstanding": false,
        "first_name": "John",
        "middle_name": "",
        "last_name": "Smith",
        "nationality": "British",
        "email": "test@emailtest.com",
        "mobile_number": "+447782337053",
        "phone_number": "+447782337053",
        "billing_address": {
          "address": "Address Line 1",
          "address2": "Address Line 2",
          "city": "Address Line 3",
          "state": "Address Line 4",
          "postalcode": "FY8 2QR",
          "country": "GB"
        },
        "delivery_address": {
          "first_name": "John",
          "last_name": "Smith",
          "phone_number": "+447782337053",
          "address": "Address Line 1",
          "address2": "Address Line 2",
          "city": "Address Line 3",
          "state": "Addres Line 4",
          "postalcode": "FY8 2QR",
          "country": "GB"
        }
      },
      "basket": {
        "basket_id": paymentData?.basketId ?? "",
        "basket_version": "basket version information",
        "basket_gross_value": 1900,
        "basket_finance_total": 1900,
        "basket_non_finance_total": 0,
        "vat": 0,
        "finance_order_lines": [
          {
            "type": "physical",
            "isRecurring": true,
            "isPaid": false,
            "product": {
              "make": "Galaxy",
              "model": "Fold 5G",
              "product_category": "Mobile",
              "product_sku": "1-1900",
              "description":
                  "512Gb, space silver. A device unlike any before. Galaxy Fold 5G doesn't just change the face of the smartphone, it changes the face of tomorrow. Today, we introduce the biggest breakthrough since the mobile phone. ",
              "name": "Galaxy Fold 5G"
            },
            "expected_delivery_date": "2021-03-22",
            "quantity": 1,
            "quantity_unit": "pcs",
            "unit_gross_price": 1900,
            "unit_vat": 0,
            "imageUrl": {}
          }
        ]
      }
    };
  }
}
