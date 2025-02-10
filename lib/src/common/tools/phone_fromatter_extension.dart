extension PhoneCleaner on String {
  String cleanPhoneNumber() {
    // Telefon raqamni "+998" formatiga tozalash
    return "+998${this.replaceAll(RegExp(r'[\(\)\s-]'), '')}";
  }
}