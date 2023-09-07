class DateParserHelper {
  String parseDate(String date) {
    List<String> splitDate = date.split('-');

    if (splitDate.length != 3) {
      return date;
    }

    int year = int.parse(splitDate[0]);
    int month = int.parse(splitDate[1]);
    int day = int.parse(splitDate[2]);

    String formatedDate =
        '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';

    return formatedDate;
  }
}
