import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static FToast? fToast;

  static void init(BuildContext context){
    if(fToast == null){
      fToast = FToast();
      fToast!.init(context);
    }
  }

  static void toast(String msg) {
    Widget toastItem = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black45,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white),),)
        ],
      ),
    );

    fToast?.showToast(
      gravity: ToastGravity.BOTTOM,
      child: toastItem,
    );
  }
}