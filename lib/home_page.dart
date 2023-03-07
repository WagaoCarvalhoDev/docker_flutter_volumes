import 'dart:io';

import 'package:docker_flutter_volumes/MessageStorage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  final Storage storage;

  Home({Key? key, required this.storage}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();
  String text = '';
  Future<Directory>? _appDocDir;

  @override
  void initState() {
    super.initState();
    widget.storage.readData().then((String value) {
      setState(() {
        text = value;
      });
    });
  }

  Future<File> writeData() async {
    setState(() {
      text = controller.text;
      controller.text = '';
    });

    return widget.storage.writeData(text);
  }

  void getAppDirectory() {
    setState(() {
      _appDocDir = getApplicationDocumentsDirectory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reading and Writing Files'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('${text ?? "File is Empty"}'),
            TextField(
              controller: controller,
            ),
            ElevatedButton(
              onPressed: writeData,
              child: Text('Write to File'),
            ),
            ElevatedButton(
              child: Text("Get DIR path"),
              onPressed: getAppDirectory,
            ),
            FutureBuilder<Directory>(
              future: _appDocDir,
              builder:
                  (BuildContext context, AsyncSnapshot<Directory> snapshot) {
                Text text = Text('');
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    text = Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    text = Text('Path: ${snapshot.data!.path}');
                  } else {
                    text = Text('Unavailable');
                  }
                }
                return new Container(
                  child: text,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
