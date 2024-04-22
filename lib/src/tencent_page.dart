import 'package:flutter/cupertino.dart';

class TencentPage extends StatelessWidget{
  final Widget child;
  final String name;

  const TencentPage({Key? key, required this.child, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
