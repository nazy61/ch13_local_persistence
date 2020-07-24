import 'dart:io'; // Used by File
import 'dart:convert'; // Used by json

import 'package:path_provider/path_provider.dart'; // Filesystem locations

class DatabaseFileRoutines {
  // get device document directory path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // gets the local file needed
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/local_persistence.json');
  }

  // checks if the file exits
  // if no, create a new file
  // then read the file
  Future<String> readJournals() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        print("File does not Exist: ${file.absolute}");
        await writeJournals('{"journals": []}');
      }
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("error readJournals: $e");
      return "";
    }
  }

  // creates a new file and writes to it
  Future<File> writeJournals(String json) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$json');
  }

  // To read and parse from JSON data - databaseFromJson(jsonString);
  Database databaseFromJson(String str) {
    final dataFromJson = json.decode(str);
    return Database.fromJson(dataFromJson);
  }

  // To save and parse to JSON Data - databaseToJson(jsonString);
  String databaseToJson(Database data) {
    final dataToJson = data.toJson();
    return json.encode(dataToJson);
  }
}

class Database {
  List<Journal> journal;

  Database({
    this.journal,
  });

  // retrieve and map the JSON objects to a List of journals
  factory Database.fromJson(Map<String, dynamic> json) => Database(
        journal: List<Journal>.from(
          json["journals"].map(
            (x) => Journal.fromJson(x),
          ),
        ),
      );

  // convert list of journals to json
  Map<String, dynamic> toJson() => {
        "journals": List<dynamic>.from(
          journal.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class Journal {
  String id;
  String date;
  String mood;
  String note;

  Journal({
    this.id,
    this.date,
    this.mood,
    this.note,
  });

  // retrieve and convert the JSON object to a Journal class
  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
        id: json["id"],
        date: json["date"],
        mood: json["mood"],
        note: json["note"],
      );

  //  convert the Journal class to a JSON object
  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "mood": mood,
        "note": note,
      };
}

class JournalEdit {
  String action;
  Journal journal;

  JournalEdit({this.action, this.journal});
}
