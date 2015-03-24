// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.forms.input;

import 'dart:html' as html;
import '../../uix.dart';

part 'text_input.g.dart';

@ComponentMeta(dirtyCheck: false)
class TextInput extends Component<String> {
  final String tag = 'input';

  updateView() {
    final html.InputElement e = element;
    if (e.value != data) {
      e.value = data;
    }
  }
}
