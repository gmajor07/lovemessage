extension CapitalizeExtension on String {
  String capitalize() {
    if (this == null || this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
