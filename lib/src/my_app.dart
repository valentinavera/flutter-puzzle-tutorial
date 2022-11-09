import 'package:flutter/material.dart';
import 'package:my_puzzle/src/ui/pages/game/puzzle_view_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PuzzleViewPage(),
    );
  }
}
