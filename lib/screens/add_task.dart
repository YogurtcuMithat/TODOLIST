import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled4/helpers/database_helpers.dart';
import 'package:untitled4/models/task_model.dart';
import 'package:untitled4/screens/todo_list_screens.dart';

class AddTaskScreens extends StatefulWidget {
  final Function updateTaaskList;
  final Task task;
  const AddTaskScreens({Key key,this.updateTaaskList, this.task}) : super(key: key);
  //AddTaskScreen(){this.task;}

  @override
  _AddTaskScreens createState() => _AddTaskScreens();
}

class _AddTaskScreens extends State<AddTaskScreens> {
  /////////
  final _formKey = GlobalKey<FormState>();
  //final List<String> _priorities = ['Önemsiz', 'Normal', 'Önemli'];
  final DateFormat _dateFormat=DateFormat('MMM dd,yyyy');
  ////////
  TextEditingController _dateController= new TextEditingController();
  TextEditingController _titleController = new TextEditingController();
  ////////
  String _title = "";
  //String _priority="";
  DateTime _date = DateTime.now();
  ///////
  @override
  void initState(){
    super.initState();
    if(widget.task!=null){
      _title=widget.task.title;
      _date=widget.task.date;
    }
  }
  _handleDatePicker() async{
    final DateTime date=await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000),lastDate: DateTime(2050),);
    if(date!=null && date !=_date){
      setState(() {
        _date= date;
      });
      _dateController.text=_dateFormat.format(date);
    }
  }
  _submit(){
   if(_formKey.currentState.validate()){
     _formKey.currentState.save();
     print("$_title, $_date");

     Task task=Task(title:_titleController.text, date:_date);
     if(widget.task==null)
       {
         print('TİTLE VALUE - ${_titleController.text}');
        task.status=0;
         DatabaseHelper.instance.insertTask(task);
       }else{
       task.title=widget.task.title;
       task.id=widget.task.id;
       task.date=widget.task.date;
       task.status=widget.task.status;
       DatabaseHelper.instance.updateTask(task);
     }
     widget.updateTaaskList();
     Navigator.pop(context);
    }else{
     print('VALIDATE ERROR SUBMIT');
    }
   }
   _delete(){
    DatabaseHelper.instance.deleteTAsk(widget.task.id);
    widget.updateTaaskList();
    Navigator.pop(context);
   }
  ///////

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40,vertical: 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon((Icons.arrow_drop_down_circle), color: Colors.red),
              ),
              SizedBox(height: 20,),
              Text(widget.task==null?'GÖREV EKLE':'Görevi güncelle', style: TextStyle(color: Colors.red, fontSize: 40, fontWeight: FontWeight.bold,),),
              SizedBox(height: 10,),

              //////////////
              //////////////
              ///taskDefinition(_formKey,_title),
              //////////////

              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: TextField(
                        controller: _titleController,
                        style: TextStyle(fontSize: 18,),
                        decoration: InputDecoration(
                          labelText: 'Başlık',
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                        ),

                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        controller: _dateController,
                        onTap: _handleDatePicker,
                        style: TextStyle(fontSize: 18,),
                        decoration: InputDecoration(
                          labelText: 'Tarih',
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //////////////
              Container(
                margin:EdgeInsets.symmetric(vertical: 20),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: FlatButton(
                  child: Text(widget.task==null?"Kaydet":"Güncelle",style: TextStyle(color:Colors.lightGreenAccent,fontSize: 20),),
                  onPressed: _submit,
                ),
              ),
              deleteButton(),
              //////////////
            ],
          ),
        ),
      ),
    );
  }

  Widget deleteButton() {
    if (widget.task!=null) {
      return Container(margin:EdgeInsets.symmetric(vertical: 20),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30)
        ),
        child: FlatButton(
          child: Text("Sil",style: TextStyle(color:Colors.lightGreenAccent,fontSize: 20),),
          onPressed: _delete,
        ),
      );
    }else{if(widget.task==null)return Text(""); else Text("Geçerli bir id bulunamadı ");}
    }
  }
//TODO priority selected yapalım

//region Görev önceliği
/*
  Widget prioritySelected(List<String> _priorities,String _priority) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40,vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DropdownButtonFormField(
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 22,
                        iconEnabledColor: Colors.lightGreenAccent,
                        iconDisabledColor: Colors.black54,
                        items: _priorities.map((String priority){
                            return DropdownMenuItem<String>(
                                value: priority,
                                child: Text(priority, style: TextStyle(color: Colors.black, fontSize: 18,),),);
                                }).toList(),),
                  Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconSize: 22,
                          iconEnabledColor: Colors.lightGreenAccent,
                          style: TextStyle(fontSize: 18,),
                          decoration: InputDecoration(
                            labelText: 'Önem derecesi',
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (input) =>_priority==null?'Önem derecesini girin':null,
                          onChanged: (value) {
                            setState(() {
                              _priority=value;
                            });
                          },
                        ),
                      ),
            ],
          ),
        ),
        ),
      ),
    );
  }
  *///endregion

