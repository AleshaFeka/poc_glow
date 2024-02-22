import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:poc_glow/ui/application_screen/application_screen_state.dart';
import 'package:poc_glow/ui/shared_widgets/pdf_downloader_helper/pdf_downloader_helper_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/model/loan_options.dart';
import '../../data/model/payment_session_data_model.dart';
import '../../data/url_provider.dart';

const _pdfUrlPattern = "/api/agreement/pdf/authorised";
const _pdfUrlPostfix = ".pdf";

class ApplicationScreenBloc extends Cubit<ApplicationScreenState> {

  PdfDownloaderHelperBloc? _pdfDownloaderBloc;
  LoanOptions? options;
  PaymentSessionDataModel? paymentData;
  AppLifecycleListener? _listener;
  String themeName = "";
  String customerFirstName = "";
  String customerLastName = "";
  String basketValueGross = "";

  bool _isLoadCompleted = false;
  bool _shouldCheckPermissionsAfterResume = false;

  ApplicationScreenBloc() : super(ApplicationScreenInitialState());

  void init(PdfDownloaderHelperBloc bloc) async {
    _pdfDownloaderBloc = bloc;
    _isLoadCompleted = false;

    _listener ??= AppLifecycleListener(
      onResume: () async {
        if (_shouldCheckPermissionsAfterResume) {
          _shouldCheckPermissionsAfterResume = false;
          _onAppResume();
        }
      },
    );

    _checkPermissionsAndLoadUrl();
  }

  void onThemeChanged(brightness) {
    emit(ApplicationScreenThemeChangedState(brightness));
  }

  Future<void> _checkPermissionsAndLoadUrl() async {
    emit(ApplicationScreenUrlLoadingState());

    final cameraPermission = await Permission.camera.request();

    if (cameraPermission != PermissionStatus.granted) {
      emit(ApplicationScreenNoPermissionsGrantedState());
    } else {
      await _loadAppUrl();
    }
  }

  Future<void> _onAppResume() async {
    _checkPermissionsAndLoadUrl();
  }

  Future<void> _loadAppUrl() async {
    var url = Uri.https(
      EeUrlProvider.getCurrentEnvUrl(),
      'api/ee/application/initialize',
    );

    print("App screen. url - $url");

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

  Future<void> onOpenAppSettings() async {
    _shouldCheckPermissionsAfterResume = true;
    await AppSettings.openAppSettings(type: AppSettingsType.settings);
  }

  void onLoadStop() {
    _isLoadCompleted = true;
  }

  Future<NavigationActionPolicy> onOverrideUrl(InAppWebViewController _, NavigationAction op) async {
    final url = op.request.url;

    if (url != null && await canLaunchUrl(url)) {

      if (url.toString().contains(_pdfUrlPattern) || url.toString().endsWith(_pdfUrlPostfix)) {
        _pdfDownloaderBloc?.startPdfProcessing(url.toString());
        return NavigationActionPolicy.CANCEL;
      }

      if (Platform.isIOS && op.iosWKNavigationType != IOSWKNavigationType.LINK_ACTIVATED) {
        return NavigationActionPolicy.ALLOW;
      }

      await launchUrl(url);
      return NavigationActionPolicy.CANCEL;
    }

    return NavigationActionPolicy.ALLOW;
  }

  void onBackButtonPressed() {
    if (_isLoadCompleted && state is ApplicationScreenUrlLoadedState) {
      emit(
        ApplicationScreenBackButtonPressedState(appUrl: (state as ApplicationScreenUrlLoadedState).appUrl),
      );
    }
  }

  Map<String, Object> _buildMockBody() {
    return {
      "session_id": paymentData?.sessionId ?? "",
      "locale": "en-GB",
      "theme": themeName,
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
        "title": "Miss",
        "first_name": customerFirstName,
        "middle_name": "",
        "last_name": customerLastName,
        "nationality": "British",
        "email": "test@emailtest.com",
        "mobile_number": "+375297894527",
        "phone_number": "+375297894527",
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
        "basket_gross_value": int.parse(basketValueGross),
        "basket_finance_total": int.parse(basketValueGross),
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
            "unit_gross_price": int.parse(basketValueGross),
            "unit_vat": 0,
            "imageUrl": {}
          }
        ]
      }
    };
  }

  void dispose() {
    _listener?.dispose();
  }
}
