extension PriceFormatter on num {
  String formatWithSpace() {
    final formattedPrice = this.floor().toString();
    final length = formattedPrice.length;

    if (length > 3) {
      return "${formattedPrice.substring(0, length - 3)} ${formattedPrice.substring(length - 3)}";
    }
    return formattedPrice;
  }
}

extension PhoneCleaner on String {
  String cleanPhoneNumber() {
    // Telefon raqamni "+998" formatiga tozalash
    return "+998${this.replaceAll(RegExp(r'[\(\)\s-]'), '')}";
  }
}
