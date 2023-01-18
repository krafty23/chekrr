class Task {
  String name;
  int status;

  Task({this.name = '', this.status = 0});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        name: json['name'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'status': status,
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
