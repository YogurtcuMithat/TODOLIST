import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:untitled4/helpers/database_helpers.dart';
import 'package:untitled4/models/task_model.dart';
import 'add_task.dart';

class TodoListScreens extends StatefulWidget{
  const TodoListScreens({Key key}) : super(key: key);

  @override
  _TodoListScreenState createState()=> _TodoListScreenState();

}
class _TodoListScreenState extends State<TodoListScreens>{

  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter= DateFormat('MMM dd,yyyy');
  @override
  void initState(){

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
         _updateTaskList();
    });

  }
  _updateTaskList(){
    setState(() {
      _taskList=DatabaseHelper.instance.getTaskList();
      print("setstate title"+_taskList.toString());
    });
  }
  Widget _buildTask(Task task){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: ListTile(
        title:Text(task.title?? DatabaseHelper.instance.colTitle.toString(),style:TextStyle(fontSize:18,decoration:task.status==0? TextDecoration.none:TextDecoration.lineThrough,)),
        subtitle: Text(_dateFormatter.format(task.date),style:TextStyle(fontSize:18,decoration:task.status==0?TextDecoration.none:TextDecoration.lineThrough,)),
        trailing: CheckBoxWidget(task),
        onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>AddTaskScreens(updateTaaskList:_updateTaskList,task: task,))),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
              title: "Yapılacaklar Listesi",
              theme: ThemeData(primarySwatch: Colors.red),
        home: Scaffold(
        floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => AddTaskScreens(updateTaaskList: _updateTaskList,)),) ;
          }),
          body: FutureBuilder(
            future: _taskList,
            builder: (context,snapshot){
           if(snapshot.hasData == null){
              return Center(child: CircularProgressIndicator(),);
            }else{
              List<Task> taskNewList = snapshot.data;

             final int completedTaskCount = taskNewList!=null && taskNewList.length>0 ? snapshot.data.where((Task task)=>task.status==0).toList().length: 0;
             return  taskNewList!=null && taskNewList.isNotEmpty ? ListView.builder(
               padding:const EdgeInsets.symmetric(vertical: 40),
               itemCount: 1+snapshot.data.length,
               itemBuilder: (BuildContext context, int index){
                 if(index==0){
                   return Padding(
                     padding: EdgeInsets.symmetric(horizontal: 40,),
                     child: Column (
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children:<Widget>[
                           Text('Görevlerim', style: TextStyle(color:Colors.black,fontSize:40,fontWeight: FontWeight.bold),),
                           SizedBox(height:10),
                           Text("${snapshot.data.length} tanımlı görevden"+ " "+" ${completedTaskCount}"+" görev kaldı",style: TextStyle(color:Colors.black,fontSize:15,fontWeight: FontWeight.w300),),
                         ]
                     ),
                   );
                 }
                 return _buildTask(snapshot.data[index-1]);
               },
             ): Center(child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [Text("Veri ekleyiniz."), CircularProgressIndicator(strokeWidth: 2,color: Colors.deepOrangeAccent,)],),
             ));
           }
          },
        ),
        ),
    );
  }
}

class CheckBoxWidget extends StatefulWidget {
  Task task;
  CheckBoxWidget(this.task, {Key key}) : super(key: key);

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  Future<List<Task>> _taskList;
  @override
  void initState(){
    super.initState();
    _updateTaskList();
  }
  _updateTaskList(){
    setState(() {
      _taskList=DatabaseHelper.instance.getTaskList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Checkbox(onChanged: (value) {
      widget.task.status=value?1:0;
      DatabaseHelper.instance.updateTask(widget.task);
      _updateTaskList();
      navigatorPushRoute();
    },
      activeColor: Theme.of(context).primaryColor,value: widget.task.status==1?true:false,);
  }
  navigatorPushRoute(){
    return Navigator.push(context,MaterialPageRoute(builder: (_) => TodoListScreens()),);
  }
}