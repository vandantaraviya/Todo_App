
class TaskAddModel {
  String? id;
  String? task;
  String? description;
  String? date;
  String? time;

  TaskAddModel({this.id, this.task, this.description, this.date,this.time});

  TaskAddModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    task = json['task'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task'] = this.task;
    data['description'] = this.description;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}