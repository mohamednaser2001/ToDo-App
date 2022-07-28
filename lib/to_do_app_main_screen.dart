import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_task/new_task_screen.dart';
import 'package:flutter/src/material/date_picker.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';


class ToDoAppMainScreen extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (BuildContext context)=> AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is AppInsertIntoDatabaseState){
            Navigator.pop(context);
            timeController.text='';
            titleController.text='';
            dateController.text='';

          }
        },
        builder: (context,state){
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              titleSpacing: 20.0,
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            body: state is AppGetDatabaseLoadingState ? Center(child: CircularProgressIndicator()) : cubit.screens[cubit.currentIndex],

            floatingActionButton: FloatingActionButton(
              onPressed: () async
              {
                if(cubit.isBottomSheetShown){

                  if(formKey.currentState!.validate()){

                    cubit.insetIntoDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text
                    );

                   /*
                    insetIntoDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text).then((value)
                    {
                      Navigator.pop(context);

                     // setState(() {
                       // fABIcon=Icons.edit;
                      //});

                      isBottomSheetShown=false;
                    });

                    */
                  }


                }
                else {
                  scaffoldKey.currentState!.showBottomSheet((context) {
                    return Form(
                      key: formKey,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: titleController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Title must be entered';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Task Title',
                                prefixIcon: Icon(
                                  Icons.title,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: timeController,
                              onTap: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text=value!.format(context);
                                });
                              },
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Time must be entered';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Task Time',
                                prefixIcon: Icon(
                                  Icons.timer,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: dateController,
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2030-11-03'),
                                ).then((value) {
                                  dateController.text = value.toString();
                                  print(dateController.text);
                                });
                              },
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Date must be entered';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Task Date',
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    elevation: 20.0;
                  }
                  ).closed.then((value)
                  {
                    // when the bottom sheet closed
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  }
                  );
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,
                  );
                }
                //insetIntoDatabase();
              },
              child: Icon(
                cubit.fABIcon,
              ),
            ),

            bottomNavigationBar: BottomNavigationBar(
              onTap: (index){
                cubit.changeIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'New Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.done,
                  ),
                  label: 'Done Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive,
                  ),
                  label: 'Archive Tasks',
                ),
              ],
              currentIndex: cubit.currentIndex,
            ),

          );

        },
      ),
    );
    /*
    */
  }





}

