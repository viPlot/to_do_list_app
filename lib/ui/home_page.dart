import 'dart:html';
import 'dart:ui';

import 'package:To_do_list_app/ui/theme.dart';
import 'package:To_do_list_app/ui/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/notifications_services.dart';
import '../services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar()
        ],
      ),
    );
  }

_addTaskBar() {
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text("Today",
                  style: headingStyle,)
              ],
            )
        ),
        MyButton(
            label: "+ Add task",
            onTap: () => null)
      ],
    ),
  );
}

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme"
          );

          notifyHelper.scheduledNotification();
        },
        child: Icon(Get.isDarkMode?Icons.wb_sunny_outline:Icons.nightlight_round,
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
}
