// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.generators.component_generator;

import 'dart:async';
import 'package:analyzer/src/generated/element.dart';

import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/utils.dart';

import '../annotations.dart';

class ComponentGenerator extends GeneratorForAnnotation<ComponentMeta> {
  const ComponentGenerator();

  @override
  Future<String> generateForAnnotatedElement(Element element, ComponentMeta annotation) async {
    if (element is! ClassElement) {
      final friendlyName = friendlyNameForElement(element);
      throw new InvalidGenerationSourceError(
          'Generator cannot target `$friendlyName`.',
          todo: 'Remove the ComponentMeta annotation from `$friendlyName`.');
    }

    final classElement = element as ClassElement;
    final className = classElement.name;
    final createFnName = '\$$className';

    return '$className $createFnName() => new $className();';
  }

  @override
  String toString() => 'UixGenerator';
}
