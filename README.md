# dobx_gen
Generate dobx observables via [source_gen](https://github.com/dart-lang/source_gen)

## Example
### lib/todo.dart
```
library hello;

import 'package:dobx/dobx.dart';
import 'package:dobx_gen/core.dart';

part 'hello.g.dart';

@dobx
class Todo {

  String title;
  bool completed;

  factory Todo() => _$Todo(); // this method is generated
}
```

### pubspec.yaml
```
name: hello
description: dobx_gen example
version: 0.1.0

dependencies:
  dobx: ^0.7.0
  dobx_gen: ^0.1.0

dev_dependencies:
  build_runner: ^0.3.0+1
```

### tool/build.dart
```
import 'dart:async';

import 'package:build_runner/build_runner.dart';
import 'package:dobx_gen/core_gen.dart';
import 'package:source_gen/source_gen.dart';

Future main(List<String> args) async {
  await build(
      new PhaseGroup.singleAction(
          new GeneratorBuilder([new DobxGenerator()]),
          new InputSet('hello', const ['lib/*.dart'])),
      deleteFilesByDefault: true);
}
```

### Generated code
```sh
dart tool/build.dart
```

