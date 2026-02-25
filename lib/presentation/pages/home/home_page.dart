import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: Text("Home")),
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Container(
            color: Colors.purple,
            child: Padding(
              padding: EdgeInsets.all(50),
              child: Container(
                color: Colors.amber,
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildCircle(),
                          buildCircle(),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            height: 200,
                            width: 100,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  child: Transform.rotate(
                                    angle: Math.pi,
                                    child: buildCircle(),
                                  ),
                                ),
                                Positioned(
                                  top: 100, // move second one down
                                  child: Transform.rotate(
                                    angle: Math.pi,
                                    child: buildCircle(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class buildCircle extends StatelessWidget {
  const buildCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 180 / Math.pi,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.purple,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withAlpha(120),
              spreadRadius: 4,
              blurRadius: 15,
              offset: Offset.fromDirection(1.0, 30),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(200)),
        ),
      ),
    );
  }
}
