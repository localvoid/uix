// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.collapsable.main;

import 'dart:async';
import 'dart:html' as html;
import 'package:uix/uix.dart';

$StatefulCounter() => new StatefulCounter();
class StatefulCounter extends Component {
  int start = new DateTime.now().millisecondsSinceEpoch;
  int time = 0;

  String get elapsedSeconds => (time / 1000).toStringAsFixed(1);

  init() {
    new Timer.periodic(new Duration(milliseconds: 50), (t) {
      time = new DateTime.now().millisecondsSinceEpoch - start;
      invalidate();
    });
  }

  updateView() {
    updateRoot(vRoot(type: 'Counter')(elapsedSeconds));
  }
}

class BoxData {
  final Anchor anchor;
  final bool visible;

  const BoxData(this.anchor, this.visible);
}

$Box() => new Box();
class Box extends Component<BoxData> {
  updateView() {
    if (data.visible) {
      updateRoot(vRoot(type: 'Box')(vComponent($StatefulCounter, anchor: data.anchor)));
    } else {
      updateRoot(vRoot(type: 'Box'));
    }
  }
}

class Main extends Component {
  int position = 0;
  Anchor _anchor = new Anchor();

  init() {
    element.onClick.matches('.MoveButton').listen((e) {
      e.preventDefault();
      position = (position + 1) % 3;
      invalidate();
    });
  }

  updateView() {
    updateRoot(vRoot()([
      vElement('button', type: 'MoveButton')('Move'),
      vComponent($Box, data: new BoxData(_anchor, position == 0)),
      vComponent($Box, data: new BoxData(_anchor, position == 1)),
      vComponent($Box, data: new BoxData(_anchor, position == 2))
    ]));
  }

  disposed() {
    _anchor.dispose();
  }
}

main() {
  initUix();

  injectComponent(new Main(), html.document.body);
}
