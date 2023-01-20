import 'package:http/http.dart' as http;
import 'dart:convert';

List<Task> TaskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String TaskToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<TaskFull> TaskFullFromJson(String str) =>
    List<TaskFull>.from(json.decode(str).map((x) => TaskFull.fromJson(x)));

String TaskFullToJson(List<TaskFull> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  String name;
  int status;
  int id;

  Task({this.name = '', this.status = 0, this.id = 0});
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        name: json['name'] as String,
        status: int.tryParse(json['status']) as int,
        id: int.tryParse(json['id']) as int,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
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

  TaskDetails(this.name, this.uid, this.schedule_count, this.schedule_unit);

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
