// ========================================================================
// Copyright 2017 David Yu
// ------------------------------------------------------------------------
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ========================================================================
// @author dyu
// @created 2017/03/28

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/utils.dart';

import 'package:build/build.dart';

import './core.dart';

class DobxGenerator extends GeneratorForAnnotation<Dobx> {
  const DobxGenerator();

  @override
  Future<String> generateForAnnotatedElement(
      Element element, Dobx annotation, BuildStep buildStep) async {
    if (element is! ClassElement) {
      var friendlyName = friendlyNameForElement(element);
      throw new InvalidGenerationSourceError(
          'Generator cannot target `$friendlyName`.',
          todo: 'Remove the @dobx annotation from `$friendlyName`.');
    }

    final classElement = element as ClassElement,
        name = classElement.name,
        buf = new StringBuffer();

    var i = 0;
    for (var fe in classElement.fields) {
      buf.writeln(fieldDecl(fe));
      buf.writeln(fieldMethod(fe, ++i));
    }

    return '''
    class _$name extends PubSub implements $name {
      $buf
    }
    $name _\$$name() { return new _$name(); }
    ''';
  }

  String fieldDecl(FieldElement fe) {
    return '${fe.type.name} _${fe.name};';
  }

  String fieldMethod(FieldElement fe, int id) {
    final name = fe.name,
      type = fe.type.name;

    return '''
    $type get $name { \$sub($id); return _$name; }
    void set $name($type $name) {
      if ($name != null && $name == _$name) return;
      _$name = $name ?? ${_defaultValue(fe)};
      \$pub($id);
    }
    ''';
  }

  String _defaultValue(FieldElement fe) {
    switch (fe.type.name) {
      case 'String': return "''";
      case 'bool': return 'false';
      default: return '0';
    }
  }
}