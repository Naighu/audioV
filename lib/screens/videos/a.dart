import 'package:flutter/material.dart';

class A extends StatefulWidget {
  const A({Key? key}) : super(key: key);

  @override
  _AState createState() => _AState();
}

class _AState extends State<A> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("called twice");
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
