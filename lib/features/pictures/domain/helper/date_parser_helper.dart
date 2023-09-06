class DateParserHelper {
  String dateParser(String date) {
    List<String> splittedDate = date.split('-');

    if (splittedDate.length != 3) {
      return date;
    }

    int year = int.parse(splittedDate[0]);
    int month = int.parse(splittedDate[1]);
    int day = int.parse(splittedDate[2]);

    String formatedDate =
        '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';

    return formatedDate;
  }
}
