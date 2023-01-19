import 'package:http/http.dart' as http;
import 'dart:convert';

List<Task> TaskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String TaskToJson(List<Task> data) =>
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
