// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.vdom.prop;

import 'dart:html' as html;

// TODO: add more properties
class Prop {
  static const int checked = 0;
  static const int value = 1;
}

typedef void _PropSetter(html.InputElement element, dynamic value);

void _setChecked(html.InputElement element, bool value) {
  if (element.checked != value) {
    element.checked = value;
  }
}

void _setValue(html.InputElement element, String value) {
  if (element.value != value) {
    element.value = value;
  }
}

class PropInfo {
  final int id;
  final int flags;
  final dynamic defaultValue;
  final _PropSetter setter;

  const PropInfo(this.id, this.flags, this.defaultValue, this.setter);

  static const List<PropInfo> fromId = const [
    const PropInfo(0, 0, false, _setChecked),
    const PropInfo(1, 0, '', _setValue)
  ];
}
