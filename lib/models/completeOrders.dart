
class CompleteOrder {
  DateTime startDate = new DateTime.now().subtract(new Duration(days: 1));
  DateTime endDate = new DateTime.now();
  num limit = 10;
  num offset = 0;
}