import 'dart:ui';

import 'package:To_do_list_app/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function onTap;
  const MyButton({Key key, this.label, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClr
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
