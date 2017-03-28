library hello;

import 'package:dobx/dobx.dart';
import 'package:dobx_gen/core.dart';

part 'hello.g.dart';

@dobx
abstract class Todo {

  String title;
  bool completed;

  factory Todo() => _$Todo(
    title: 'hello, world!',
    completed: false,
  );
}