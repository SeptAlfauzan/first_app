import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  int colorIndex = 999;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First App',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text('Hallo from'),
          centerTitle: true,
        ),
        body: Center(
          child: IconButton(
            onPressed: () {
              printHalo();
            },
            icon: Icon(Icons.search),
            color: Colors.amber[colorIndex],
          ),
        ),
        // floatingActionButton: IconButton(
        //   icon: Icon(Icons.send),
        //   color: Colors.black,
        //   onPressed: () => print('button clicked'),
        // ),
      ),
    );
  }

  void printHalo() {
    print('color change');
    if (colorIndex == 999) {
      colorIndex = 900;
    } else {
      colorIndex = 999;
    }
    print(colorIndex);
  }
}
