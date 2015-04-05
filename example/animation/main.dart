// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.animation.main;

import 'dart:async';
import 'dart:html' as html;
import 'package:uix/uix.dart';
import 'package:uix/misc.dart';

$Box() => new Box();
class Box extends Component<int> {
  updateView() { updateRoot(vRoot(type: 'Box')(data.toString())); }
}

class Main extends Component<List<int>> with CssTransitionContainer {
  init() {
    initTransitionListeners();
  }

  updateView() {
    updateRoot(vRoot()([
      vElement('h1')('Animation Example'),
      vElement('div', content: true)(data.map((i) => vComponent($Box, key: i, data: i)))
    ]));
  }
}

main() {
  initUix();

  final boxes = [];
  int boxId = 0;

  for (var i = 0; i < 10; i++) {
    boxes.add(boxId++);
  }

  final c = new Main()..data = boxes;

  injectComponent(c, html.document.body);

  new Timer.periodic(const Duration(seconds: 1), (_) {
    boxes.removeAt(0);
    boxes.add(boxId++);
    c.invalidate();
  });
}