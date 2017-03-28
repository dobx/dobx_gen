library hello;

import 'package:dobx/dobx.dart';
import 'package:dobx_gen/core.dart';

part 'hello.g.dart';

@dobx
class Todo {

  String title;
  bool completed;

  factory Todo() => _$Todo();
}