import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled4/models/task_model.dart';
class DatabaseHelper{
  DatabaseHelper._instance();
  static final DatabaseHelper instance= DatabaseHelper._instance();
  static Database _db;



  /////////
  String tasksTables ='task_table';
  String colId='id';
  String colTitle='title';
  String colDate='date';
  String colStatus='status';
  ////////

  Future<Database> get db async{
    _db ??= await _initDb();
    return _db;
  }
  Future<Database> _initDb() async{
    Directory dir= await getApplicationDocumentsDirectory();
    String path=dir.path+'todo_list.db';
    final todoListDb=await openDatabase(path,version: 1,onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db,int version) async{
    await db.execute('CREATE TABLE $tasksTables($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate DATE,$colStatus INTEGER)');
    print("helpersdeneme $colTitle");
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async{
    Database db= await this.db;
    final List <Map<String,dynamic>> result = await db.query (tasksTables);
    return result;
  }

  Future <List<Task>> getTaskList() async{
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList=[];
    for (var taskMap in taskMapList) {
      taskList.add(Task.fromMap(taskMap));
    }
    taskList.sort((taskA,taskB)=>taskA.date.compareTo(taskB.date));
    return taskList;
  }

  Future<int> insertTask(Task task) async{
    Database db= await this.db;
    final int result= await db.insert (tasksTables, task.toMap());
    return result;
  }

  Future<int>updateTask(Task task) async{
    Database db=await this.db;
    final int result= await db.update(tasksTables,task.toMap(),where:'$colId=?',whereArgs: [task.id]);
    print(task.id.toString()+" "+task.title.toString()+" DatabaseHeleper");
    return result;
  }

  Future<int>deleteTAsk(int id)async{
    Database db=await this.db;
    final int result= await db.delete(tasksTables,where:'$colId=?',whereArgs: [id],);
    return result;
  }
}