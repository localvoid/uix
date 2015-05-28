// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.read_write_batching.main;

import 'dart:html' as html;
import 'package:uix/uix.dart';

$OuterBox() => new OuterBox();
class OuterBox extends Component {
  updateView() {
    updateRoot(vRoot(type: 'OuterBox')(vComponent($Box)));
  }
}

$InnerBox() => new InnerBox();
class InnerBox extends Component {
  updateView() {
    updateRoot(vRoot(type: 'InnerBox')('x'));
  }
}

$Box() => new Box();
class Box extends Component {
  int _outerWidth = 0;
  int _innerWidth = 0;

  init() {
    addSubscription(html.window.onResize.listen(invalidate));
  }

  updateView() async {
    final innerBox = vComponent($InnerBox);
    updateRoot(_build(innerBox));

    await scheduler.currentFrame.read();
    _outerWidth = parent.element.clientWidth;
    _innerWidth = innerBox.ref.clientWidth;

    await scheduler.currentFrame.write();
    updateRoot(_build(vComponent($InnerBox)));
  }

  _build(innerBox) => vRoot()([
    vElement('div')('Outer $_outerWidth'),
    vElement('div')('Inner $_innerWidth'),
    innerBox
  ]);
}

class App extends Component {
  updateView() {
    updateRoot(vRoot()([
      vComponent($OuterBox),
      vComponent($OuterBox),
      vComponent($OuterBox)
    ]));
  }
}

main() {
  initUix();

  scheduler.run(() {
    injectComponent(new App(), html.document.body);
  });
}
