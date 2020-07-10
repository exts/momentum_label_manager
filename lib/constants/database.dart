/// the sqflite file created when we create a new database if it doesn't exist
const kDatabaseFilename = "labels_example.db";

/// db tables that are created when we open a connection if one isn't created
const List<String> kDatabaseTablesCreateList = [
  "CREATE TABLE `labels` ("
      "`id` INTEGER PRIMARY KEY AUTOINCREMENT, "
      "`label_name` TEXT, "
      "`label_icon` TEXT, "
      "`label_icon_offset` REAL, "
      "`label_order` INT, "
      "`label_default` INT);",
];
