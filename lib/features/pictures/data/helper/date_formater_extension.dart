extension DateFormatExtension on String {
  String formatDate(String value) {
    try {
      final parts = split('-');
      final formattedDate = '${parts[2]}/${parts[1]}/${parts[0]}';
      return formattedDate;
    } catch (e) {
      return value;
    }
  }
}
