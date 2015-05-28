// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.raf.main;

import 'dart:html' as html;
import 'package:uix/uix.dart';

class Main extends Component {
  final tag = 'p';

  final start = new DateTime.now().millisecondsSinceEpoch;
  String get elapsedSeconds => (new DateTime.now().millisecondsSinceEpoch - start / 1000).toStringAsFixed(1);

  init() {
    addSubscription(scheduler.onNextFrame.listen(invalidate));
  }

  updateView() { updateRoot(vRoot()('time: $elapsedSeconds')); }
}

main() {
  initUix();

  scheduler.run(() {
    injectComponent(new Main(), html.document.body);
  });
}
