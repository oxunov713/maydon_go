extension PhoneCleaner on String {
  String cleanPhoneNumber() {
    // Telefon raqamni "+998" formatiga tozalash
    return "+998${replaceAll(RegExp(r'[\(\)\s-]'), '')}";
  }
}