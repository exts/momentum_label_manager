abstract class DataObject<T> {
  static const String TableName = "";
  static const List<String> ColumnNames = [];
  T copyWith(Map data);
}
