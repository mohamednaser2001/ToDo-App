

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_task/new_task_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit(): super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex=0;
  List<Widget> screens=[
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];

  List<String> titles = [
    'New Task',
    'Done Task',
    'Archived Task',
  ];

  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }


  late Database lastDatabase;
  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archivedTasks =[];


  void createDatabase()
  {
     openDatabase(
      'todoTasks',
      version: 1,
      onCreate: (database,version){       // When creating the db, create the table

        print('data base created');
        database.execute('CREATE TABLE ToDo (id INTEGER PRIMARY KEY, title TEXT, date TEXT,time TEXT,status TEXT)').then((value) {
          print('table created');
        }).catchError((error){
          print('error is ${error.toString()}');
        });
      },

      onOpen: (database){

        getDataFromDatabase(database);

        print('data base opened');
      },
    ).then((value) {
      lastDatabase=value;
      emit(AppCreateDatabaseState());
    });
  }

  void getDataFromDatabase(lastDatabase)
  {
    newTasks=[];
    archivedTasks=[];
    doneTasks=[];

    emit(AppGetDatabaseLoadingState());
     lastDatabase.rawQuery('select * from ToDo').then((value) {
       print('$newTasks');

       value.forEach((element){
         if(element['status']=='new'){
           newTasks.add(element);
         }
         else if(element['status']=='done'){
           doneTasks.add(element);
         }
         else {
           archivedTasks.add(element);
         }
       });


       emit(AppGetDatabaseState());
     });
  }

  void updateData({
  required String status,
    required int id,
}){
    lastDatabase.rawUpdate(
        'update ToDo set status = ? where id = ?',
        ['$status',id]
    );

    getDataFromDatabase(lastDatabase);
    emit(AppUpdateDatabaseState());
  }


  bool isBottomSheetShown = false;
  IconData fABIcon = Icons.edit;

  void changeBottomSheetState({
       required bool isShow,
       required IconData icon,
     }){
    isBottomSheetShown=isShow;
    fABIcon=icon;

    getDataFromDatabase(lastDatabase);
    emit(AppChangeBottomSheetState());
  }


  void deleteDate({required int id}){
    lastDatabase.rawUpdate(
        'delete from ToDo where id = ?',
        [id]
    );

    getDataFromDatabase(lastDatabase);
    emit(AppDeleteDatabaseState());
  }

  insetIntoDatabase({
    required String title ,
    required String date ,
    required String time}) async
  {
    await lastDatabase.transaction((txn) {
      return txn.rawInsert('insert into ToDo (title,date,time,status) values("$title","$date","$time","new")').then((value) {
        print('$value inserted');
        emit(AppInsertIntoDatabaseState());

        getDataFromDatabase(lastDatabase);

      }).catchError((error){
        print('error when inserting record ${error.toString()}');
      });
    });
  }


}