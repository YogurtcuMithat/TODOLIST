class Task {
  int id;
  String title;
  DateTime date ;
  int status=0; //0 bitmedi 1 bitti

  Task({this.id, this.title, this.date, this.status});

  Task.withId({this.id, this.title, this.date, this.status});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) {
      map["id"] = id;
    }
    map['title'] = title/*==null ? title : map['title']*/;
    map["date"] = date.toIso8601String(); /*ISO 8601, tarih ve saatle ilgili verilerin değişimini kapsayan ISO standartı*/
    map["status"] = status;
    print("TaskModel test  $title");
    return map;
  }

  factory Task.fromMap(Map<String, dynamic>map){
    return Task.withId(
      id: map["id"],
      title: map["title"]/*==null ? map["title"] : map["title"]*/,
      date: DateTime.parse(map["date"]),
      status: map["status"],
    );
  }
}