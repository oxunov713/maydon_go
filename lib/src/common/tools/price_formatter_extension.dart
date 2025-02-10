extension PriceFormatter on num {
  String formatWithSpace() {
    final formattedPrice = floor().toString();
    final length = formattedPrice.length;

    if (length > 3) {
      return "${formattedPrice.substring(0, length - 3)} ${formattedPrice.substring(length - 3)}";
    }
    return formattedPrice;
  }
}


