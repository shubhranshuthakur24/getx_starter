import 'package:flutter/material.dart';
import 'package:getx_starter/presentation/widgets/build_circle.dart';
import 'package:getx_starter/presentation/widgets/build_rectangle.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: const Text('Home')),
      body: BuildRectangle(
        color: Colors.green,
        padding: const EdgeInsets.all(40),
        widget: BuildRectangle(
          color: Colors.yellow,
          padding: const EdgeInsets.all(50),
          widget: BuildRectangle(
            color: Colors.lightBlue,
            padding: const EdgeInsets.all(20),
            widget: const InnerColumnWidget(),
          ),
        ),
      ),
    );
  }
}
