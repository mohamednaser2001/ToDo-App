import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchivedTaskScreen extends  StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder:(context ,state){
          var listOfTasks=AppCubit.get(context).archivedTasks;
          return listOfTasks.length >0 ?  ListView.separated(
            itemBuilder:(context,index)=> dataItem(listOfTasks[index],context),
            separatorBuilder: (context,index)=> Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            ),
            itemCount: listOfTasks.length,
          ) : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 100,
                  color: Colors.grey,
                ),
                Text(
                  'There is no tasks yet ,please add some tasks',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        } ,
        listener: (context,state){});



  }
}
