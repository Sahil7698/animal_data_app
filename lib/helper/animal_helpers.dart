import 'package:animal_data_app/model/animal_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper dbHelper = DBHelper._();

  Database? db;

  Future<void> initDB() async {
    var directory = await getDatabasesPath();
    String path = join(directory, "animal.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int ver) async {
        String query =
            "CREATE TABLE IF NOT EXISTS tbl_animal(Id INTEGER PRIMARY KEY AUTOINCREMENT,Name TEXT NOT NULL,Dec TEXT NOT NULL,Image BLOB NOT NULL);";
        await db.execute(query);
      },
    );
  }

  Future<int> insertRecord({required Animal animal}) async {
    await initDB();

    String query = "INSERT INTO tbl_animal(Name,Dec,Image) VALUES(?,?,?);";
    List args = [animal.name, animal.dec, animal.image];

    return await db!.rawInsert(query, args);
  }

  Future<List<Animal>> getAllRecords() async {
    await initDB();
    String query = "SELECT * FROM tbl_animal;";

    List<Map<String, dynamic>> allRecords = await db!.rawQuery(query);

    List<Animal> allAnimal =
        allRecords.map((e) => Animal.fromMap(data: e)).toList();
    return allAnimal;
  }

  Future<int> deleteRecords({required int id}) async {
    await initDB();

    String query = "DELETE FROM tbl_animal WHERE Id=?;";
    List args = [id];

    return await db!.rawDelete(query, args);
  }

  Future<int> updateRecords({required Animal animal, required int id}) async {
    await initDB();

    String query = "UPDATE tbl_animal SET Name=?, Dec=?, Image=? WHERE Id=?;";
    List args = [animal.name, animal.dec, animal.image, id];

    return await db!.rawUpdate(query, args);
  }

  Future<List<Animal>> fetchSearchRecords({required String Name}) async {
    await initDB();

    String query = "SELECT * FROM tbl_animal WHERE Name LIKE '%$Name%';";

    List<Map<String, dynamic>> searchRecords = await db!.rawQuery(query);

    List<Animal> searchAnimals =
        searchRecords.map((e) => Animal.fromMap(data: e)).toList();

    return searchAnimals;
  }
}
