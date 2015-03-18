// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.generators.shallow_eq_generator;

import 'dart:async';
import 'package:analyzer/src/generated/element.dart';

import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/utils.dart';

import '../annotations.dart';

class ShallowEqGenerator extends GeneratorForAnnotation<ShallowEqOperator> {
  const ShallowEqGenerator();

  @override
  Future<String> generateForAnnotatedElement(Element element, ShallowEqOperator annotation) async {
    if (element is! ClassElement) {
      final friendlyName = frieldlyNameForElement(element);
      throw new InvalidGenerationSourceError(
          'Generator cannot target `$friendlyName`.',
          todo: 'Remove the ShallowEqOperator annotation from `$friendlyName`.');
    }

    final classElement = element as ClassElement;
    final className = classElement.name;

    final fields = classElement.fields.fold(<String, FieldElement>{},
            (map, field) {
          map[field.name] = field;
          return map;
        }) as Map<String, FieldElement>;

    final mixinName = '_${className}ShallowEqOperator';

    final buffer = new StringBuffer();
    buffer.writeln('abstract class $mixinName {');
    fields.forEach((name, field) {
      buffer.writeln('  ${field.type.name} get $name;');
    });

    buffer.writeln('  const $mixinName();');

    buffer.writeln('  bool operator==(${className} other) =>');
    buffer.write('  (identical(this, other) || (');
    buffer.write('    ');
    buffer.write(fields.keys.map((name) => '($name == other.$name)').join(' && '));
    buffer.write('));');

    buffer.writeln('}');

    return buffer.toString();
  }

  @override
  String toString() => 'UixGenerator';
}
