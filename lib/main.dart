import 'package:flutter/cupertino.dart';

import './widgets/home.dart';
import 'theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: getTheme(),
      home: Home(),
    );
  }
}
