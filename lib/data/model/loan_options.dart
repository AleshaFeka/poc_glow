class LoanOptions {
  final LoanOptionType type;
  final LoanPayload payload;

  const LoanOptions({
    required this.type,
    required this.payload,
  });

  factory LoanOptions.fromJson(Map<String, dynamic> json) {
    return LoanOptions(
      type: LoanOptionType.selectLoanOption,
      payload: LoanPayload.fromJson(json['payload']['loanOption']),
    );
  }
}

class LoanPayload {
  final double upfrontPayment;
  final double interestRate;
  final double monthlyPayment;
  final int term;
  final String loanProductId;

  const LoanPayload({
    required this.upfrontPayment,
    required this.interestRate,
    required this.monthlyPayment,
    required this.term,
    required this.loanProductId,
  });

  factory LoanPayload.fromJson(Map<String, dynamic> json) {
    return LoanPayload(
      upfrontPayment:  double.parse(json['upfrontPayment'].toString()),
      interestRate: double.parse(json['interestRate'].toString()),
      monthlyPayment: double.parse(json['monthlyPayment'].toString()),
      term: int.parse(json['term'].toString()),
      loanProductId: json['loanProductId'],
    );
  }
}

enum LoanOptionType { selectLoanOption }
