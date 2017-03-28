import 'dart:async';

import 'package:build_runner/build_runner.dart';
import 'package:dobx_gen/core_gen.dart';
import 'package:source_gen/source_gen.dart';

Future main(List<String> args) async {
  await build(
      new PhaseGroup.singleAction(
          new GeneratorBuilder([new DobxGenerator()]),
          new InputSet('dobx_gen_e2e_example', const ['lib/*.dart'])),
      deleteFilesByDefault: true);
}
