import 'package:http/http.dart' as http;
import 'dart:convert';

List<Task> TaskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String TaskToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
List<PastTask> PastTaskFromJson(String str) =>
    List<PastTask>.from(json.decode(str).map((x) => PastTask.fromJson(x)));

String PastTaskToJson(List<PastTask> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<TaskFull> TaskFullFromJson(String str) =>
    List<TaskFull>.from(json.decode(str).map((x) => TaskFull.fromJson(x)));

String TaskFullToJson(List<TaskFull> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  String name;
  String text;
  int status;
  int id;
  int folder_id;
  int item_id;
  String folder_name;

  Task({
    this.name = '',
    this.text = '',
    this.status = 0,
    this.id = 0,
    this.folder_id = 0,
    this.item_id = 0,
    this.folder_name = '',
  });
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        name: json['name'] as String,
        text: json['text'] as String,
        status: int.tryParse(json['status']) as int,
        id: int.tryParse(json['id']) as int,
        folder_id: int.tryParse(json['folder_id']) as int,
        item_id: int.tryParse(json['item_id']) as int,
        folder_name: json['folder_name'].toString() as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'text': text,
        'status': status,
        'id': id,
      };
}

class PastTask {
  String name;
  String date;
  String time;
  int status;
  int id;

  PastTask(
      {this.name = '',
      this.date = '',
      this.time = '',
      this.status = 0,
      this.id = 0});
  factory PastTask.fromJson(Map<String, dynamic> json) => PastTask(
        name: json['name'] as String,
        date: json['statuschange_day'] +
            '.' +
            json['statuschange_month'] +
            '.' +
            json['statuschange_year'] as String,
        time: json['statuschange_hour'] +
            ':' +
            json['statuschange_minute'] +
            ':' +
            json['statuschange_second'] as String,
        status: int.tryParse(json['status']) as int,
        id: int.tryParse(json['id']) as int,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
        'time': time,
        'status': status,
        'id': id,
      };
}

class TaskFull {
  String name;
  int status;
  int id;
  String image_filename;
  int item_id;
  int folder_id;
  String startdate;
  String enddate;

  TaskFull({
    this.name = '',
    this.status = 0,
    this.id = 0,
    this.image_filename = '',
    this.item_id = 0,
    this.folder_id = 0,
    this.startdate = '',
    this.enddate = '',
  });
  factory TaskFull.fromJson(Map<String, dynamic> json) => TaskFull(
        name: json['name'] as String,
        status: int.tryParse(json['status']) as int,
        id: int.tryParse(json['id']) as int,
        image_filename: json['image_filename'] as String,
        item_id: int.tryParse(json['item_id']) as int,
        folder_id: int.tryParse(json['folder_id']) as int,
        startdate: json['startdate'] as String,
        enddate: json['enddate'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'status': status,
        'id': id,
        'image_filename': image_filename,
        'item_id': item_id,
        'folder_id': folder_id,
        'startdate': startdate,
        'enddate': enddate,
      };
}

class TaskDetails {
  String name;
  int uid;
  var schedule_count;
  var schedule_unit;
  bool isChecked;
  bool isChecked2;
  bool isChecked3;
  bool isChecked4;
  bool isChecked5;
  bool isChecked6;
  bool isChecked7;

  TaskDetails(
    this.name,
    this.uid,
    this.schedule_count,
    this.schedule_unit,
    this.isChecked,
    this.isChecked2,
    this.isChecked3,
    this.isChecked4,
    this.isChecked5,
    this.isChecked6,
    this.isChecked7,
  );

  @override
  String toString() {
    return '{ ${this.name}, ${this.uid} }';
  }
}

class TaskId {
  String id;

  TaskId(this.id);

  @override
  String toString() {
    return '{ ${this.id} }';
  }
}
