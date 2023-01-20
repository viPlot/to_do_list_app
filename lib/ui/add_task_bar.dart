import 'dart:html';
import 'dart:ui';

import 'package:To_do_list_app/ui/theme.dart';
import 'package:To_do_list_app/ui/widgets/button.dart';
import 'package:To_do_list_app/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:date_picker_timeline/date_widget.dart';
import 'package:intl/intl.dart';
import 'package:To_do_list_app/ui/theme.dart';
import 'package:To_do_list_app/ui/widgets/button.dart';
import 'package:To_do_list_app/ui/widgets/input_field.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate =  DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "9:30 PM";
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "Never";
  List<String> repeatList = ["Never", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(title: "Title", hint: "Enter your title", controller: _titleController),
              MyInputField(title: "Note", hint: "Enter your note", controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate)),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  color: Colors.grey
                  onPressed: () {
                    print("Hi there");
                    _getDateFromUser();
                  }
                ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                        title: "Start time",
                        hint: _startTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime:true);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        colo: Colors.grey,
                      )
                    ),
                    )
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: MyInputField(
                        title: "End time",
                        hint: _endTime,
                        widget: IconButton(
                            onPressed: () {
                              _getTimeFromUser(isStartTime:false);
                            },
                            icon: Icon(
                              Icons.access_time_rounded,
                              colo: Colors.grey,
                            )
                        )
                    )
                  )
                ],
              ),
              MyInputField(title: "Remind", hint: "$_selectedRemind minutes early"),
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height:0),
                  onChanged: (String newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString())
                    );
                  }
                  ).toList(),
                ),
              MyInputField(title: "Repeat", hint: "$_selectedRepeat"),
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height:0),
                  onChanged: (String newValue) {
                    setState(() {
                      _selectedRepeat = newValue;
                    });
                  },
                  items: repeatist.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, TextStyle(color: Colors.grey))
                    );
                  }
                  ).toList(),
                ),
              SizedBox(height: 18),
              Row(
                  MainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center
                children: [
                  _colorPalette(),
                  MyButton(label: "Create Task", onTap: () => _validatedDate())
                ]
              )
            ],
          ),
        )
      )
    );
  }

  _validatedDate() {
    if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty)
      _addTaskToDB();
      Get.back();
    else if(_titleController.text.isEmpty || _noteController.text.isEmpty)
      Get.snackbar("Required", "All fields are required",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
        icon: Icon(Icons.warning_amber_rounded)
      );
  }

  _addTaskToDB() async{
    int value = await _taskController.addTask(
      task: Task(
        note: _noteController. text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      )
    );
    print("task id is "+"$value");
  }

  _colorPalette() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("color",
            style: titleStyle,
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: List<Widget>.generate(
                3,
                    (int index) {
                  return GestureDetector(
                      onTap: () {
                        setState((){
                          _selectedColor = index;
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            radius:  14,
                            backgroundColor: index == 0? primaryClr: index == 1? pinkClr:yellowClr,
                            child: _selectedColor == index?Icon(Icons.done,
                                color: Colors.white,
                                size: 16
                            ):Container(),
                          )
                      )
                  );
                }
            ),
          )
        ]
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(Icons.arrow_back,
            size: 20,
            color: Get.isDarkMode?Colors.white:Colors.black
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage(
              "images/user.png"
          ),
        ),
        SizedBox(width: 20,)
      ],
    );
  }

  _getDateFromUser() async {
    DateTime _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2123)
    );

    if(_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
    else
      print("It is something wrong");

  }

  _getTimeFromUser(bool isStartTime) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(context);
    if(pickedTime == null) {
      print("Time canceled");
    }
    else if (isStartTime == true)
      setState(() {
        _startTime = _formattedTime;
      });
    else if(isStartTime == false)
      _endTime = _formattedTime;
  }

  _showTimePicker() {
    return _showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      )
    );
  }

}
