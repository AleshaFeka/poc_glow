class PaymentSessionDataModel {
  final String loanUrl;
  final String sessionId;
  final String basketId;
  final String token;

  PaymentSessionDataModel({required this.token, required this.loanUrl, required this.sessionId, required this.basketId});
}