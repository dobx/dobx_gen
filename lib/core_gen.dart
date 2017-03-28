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

    final ce = element as ClassElement;
    return _implClass(ce);
    //return annotation.mixin ? _subClass(ce) : _implClass(ce);
  }

  String _implClass(ClassElement ce) {
    var name = ce.name,
        body = new StringBuffer(),
        params = new StringBuffer(),
        assign_params = new StringBuffer(),
        i = 0;

    String val;
    for (var fe in ce.fields) {
      val = _defaultValue(fe);
      // the compiler allows '=' to assing default value but build_runner complains about it
      params.writeln('${fe.type.name} ${fe.name} : $val,');
      assign_params.writeln('.._${fe.name} = ${fe.name}');
      body.writeln('${fe.type.name} _${fe.name};');
      body.writeln(_implMethod(++i, fe.type.name, fe.name, val));
    }

    return '''
    class _$name extends PubSub implements $name {
      $body
    }
    $name _\$$name({
      $params
    }) {
      return new _$name()
        $assign_params;
    }
    ''';
  }

  String _implMethod(int id, String type, String name, String val) {
    return '''
    $type get $name { \$sub($id); return _$name; }
    void set $name($type $name) {
      if ($name != null && $name == _$name) return;
      _$name = $name ?? $val;
      \$pub($id);
    }
    ''';
  }

  String _defaultValue(FieldElement fe) {
    switch (fe.type.name) {
      case 'String': return "''";
      case 'bool': return 'false';
      case 'double': return '0.0';
      case 'num': return '0';
      case 'int': return '0';
      default: return 'null';
    }
  }

  /*bool _isPrivateField(FieldElement fe) {
    // starts with '_'
    return 95 == fe.name.codeUnitAt(0);
  }

  String _subClass(ClassElement ce) {
    var name = ce.name,
        buf = new StringBuffer(),
        i = 0;

    String val;
    for (var fe in ce.fields) {
      if (_isPrivateField(fe) && 'null' != (val = _defaultValue(fe)))
        buf.writeln(_implMethod(++i, fe.type.name, fe.name.substring(1), val));
    }

    return '''
    class _$name extends $name with PubSub {
      _$name();
      $buf
    }
    $name _\$$name() { return new _$name(); }
    ''';
  }*/
}