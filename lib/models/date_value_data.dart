class DateValueData {
  DateTime date;
  double value;

  DateValueData(this.date, this.value);

  static DateValueData empty() {
    return DateValueData(DateTime.fromMicrosecondsSinceEpoch(0), -1.0);
  }
}
