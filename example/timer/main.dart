// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.timer.main;

import 'dart:async';
import 'dart:html' as html;
import 'package:uix/uix.dart';

part 'main.g.dart';

@ComponentMeta()
class Main extends Component<int> {
  final tag = 'p';

  String get elapsedSeconds => (data / 1000).toStringAsFixed(1);

  updateView() { updateRoot(vRoot()('time: $elapsedSeconds')); }
}

main() {
  initUix();

  final c = createMain(0);

  scheduler.nextFrame.write().then((_) {
    injectComponent(c, html.document.body);
  });

  final start = new DateTime.now().millisecondsSinceEpoch;
  new Timer.periodic(new Duration(milliseconds: 50), (t) {
    c.data = new DateTime.now().millisecondsSinceEpoch - start;
    c.invalidate();
  });
}
