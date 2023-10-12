import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:poc_glow/data/model/loan_options.dart';

import 'payment_session_state.dart';

class PaymentSessionBloc extends Cubit<PaymentSessionState> {
  LoanOptions? _options;
  String token = "";
  String _loanUrl = "";

  PaymentSessionBloc() : super(PaymentSessionUrlLoadingState());

  void init() async {
    _loanUrl = await _fetchUrl();
    print("loanUrl = $_loanUrl");
    emit(PaymentSessionUrlLoadedState(_loanUrl));
  }

  void onLoanOptionsSelected(List<dynamic> args) {
    if (args.first != null) {
      final jsonRaw = args.first as Map<String, dynamic>;
      _options = LoanOptions.fromJson(jsonRaw);

      if (_options != null) {
        emit(PaymentSessionLoanOptionsSelectedState(_loanUrl, _options!));
      }
    }
  }

  Future<String> _fetchUrl() async {
    var url = Uri.https(
      'platform-api.dev03.glowfinsvs.com',
      'api/ee/paymentSession',
    );
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "content-type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(_mockedRequestData),
    );

    final loanUrl = jsonDecode(response.body)['loan_application_url'] as String;

    return loanUrl;
  }
}

final _mockedRequestData = {
  "country": "GB",
  // (required) ISO 3166-1 alpha-2, the country code where the transaction is initiated from
  "currency": "GBP",
  // (required) ISO 4217, the currency code of the transaction
  "locale": "en-GB",
  // (optional) ISO 639-1, the language associated with the customer interaction. Defaults to product default locale.
  "theme": "EE_dark",
  // (optional) Theme to apply to payment options/calculator widget
  "allowed_proposal_codes": [
    // (optional) Used to limit the finance product option (product id) to be made available to the finance widget. If not provided, preferred finance option will be returned.
    "Ee_Product_COM"
  ],
  "sales_channel": {
    "type": "com",
    // (required) The channel the sale has been initiated from, "web", "mobile", "telesale", "assisted"
    "company_name": "EE",
    // (required) The integrator company name
    "sales_channel_id": "xxx",
    // (required) Unique identifier for store and telesale channel, where relevant. If not online or telesale than send "xxx"
    "sales_rep_id": "xxx",
    // (optional) Unique sales agent/ in-store colleague identifier
    "channel_address": {
      // (optional)
      "address": "Address Line 1",
      "address2": "Address Line 2",
      "city": "Address Line 3",
      "state": "Address Line 4",
      "postalcode": "SO23 8BA",
      "country": "GB" // (required) ISO 3166-1 alpha-2
    }
  },
  "basket": {
    // (required)
    "basket_id": DateTime.now().microsecondsSinceEpoch.toString(),
    // (required) unique basket reference
    "basket_gross_value": 1900,
    // (required) the total basket value for all items in the basket, all payment methods
    "basket_finance_total": 1900,
    // (required) the total value for all items to be financed. Not null, send as 0
    "basket_non_finance_total": 0,
    // (required) the total value for all items to be paid by other payment methods. Not null, send as 0
    "vat": 0,
    // (optional) The total VAT amount for all items to be financed, defaults to 0
    "finance_order_lines": [
      // (required)
      {
        "type": "physical",
        // (required) free form
        "isRecurring": false,
        // (optional) Identifier for whether the products is a recurring charge. True identifies that recurring payments apply to the order item.
        "isPaid": true,
        // (optional) True identifies that the item has already been paid for.
        "product": {
          "make": "Galaxy",
          // (required)
          "model": "Fold 5G",
          //  (required)
          "product_category": "Mobile",
          // (required)
          "product_sku": "1-1900",
          // (required)
          "description":
              "512Gb, space silver. A device unlike any before. Galaxy Fold 5G doesn't just change the face of the smartphone, it changes the face of tomorrow. Today, we introduce the biggest breakthrough since the mobile phone. ",
          // (required)
          "name": "Galaxy Fold 5G"
          // (required)
        },
        "expected_delivery_date": "2023-09-22",
        // (required) YYYY-MM-
        "quantity": 1,
        // (required) number of units purchased
        "quantity_unit": "pcs",
        // (required) measurement of unit. Not validated
        "unit_gross_price": 1900,
        // (required) This is the price of the item, inclusive of VAT. Major denomination implied, unless decimal is provided (2 decimals implied, unless the ISO4217 "currency" code supports 3 decimals)
        "unit_vat": 0,
        // (optional) This the VAT portion of the price. Major denomination implied, unless decimal is provided (2 decimals implied, unless the ISO4217 "currency" code supports 3 decimals)
        "imageUrl": {}
      }
    ]
  }
};
