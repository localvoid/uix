// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.hello.main;

import 'dart:async';
import 'dart:html' as html;
import 'package:uix/uix.dart';

part 'main.g.dart';

@ComponentMeta()
class Collapsable extends Component<bool> {
  updateView() {
    if (isMounting) {
      updateRoot(_build('Not Mounted'));
    }
    updateRoot(_build(children));
  }

  _build(c) => vRoot(type: 'Collapsable', classes: data ? const ['close'] : const ['open'])(c);
}

@ComponentMeta()
class Main extends Component {
  bool closed = false;
  int start = new DateTime.now().millisecondsSinceEpoch;
  int time = 0;

  String get elapsedSeconds => (time / 1000).toStringAsFixed(1);

  init() {
    element.onClick.matches('.CloseButton').listen((e) {
      e.preventDefault();
      closed = !closed;
      invalidate();
    });

    new Timer.periodic(new Duration(milliseconds: 50), (t) {
      time = new DateTime.now().millisecondsSinceEpoch - start;
      invalidate();
    });
  }

  updateView() {
    updateRoot(vRoot(type: 'Main')([
      vElement('button', type: 'CloseButton')(closed ? 'Open' : 'Close'),
      vCollapsable(data: closed)(elapsedSeconds)
    ]));
  }
}

main() {
  initUix();

  mountComponent(createMain(), html.querySelector('.Main'));
}
