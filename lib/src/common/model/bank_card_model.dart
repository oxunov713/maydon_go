class BankCard {
  final String cardNumber;
  final String cardType;

  BankCard({
    required this.cardNumber,
    required this.cardType,
  });

  factory BankCard.fromJson(Map<String, Object?> json) {
    return BankCard(
      cardNumber: json['cardNumber'] as String,
      cardType: json['cardType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cardType': cardType,
    };
  }
}
