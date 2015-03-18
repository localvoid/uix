// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.state_diff.main;

import 'dart:async';
import 'dart:html' as html;
import 'package:uix/uix.dart';

part 'main.g.dart';

class Counter extends StoreNode {
  int value = 0;
}

class CounterStore {
  Counter counter = new Counter();

  CounterStore() {
    new Timer.periodic(const Duration(milliseconds: 200), (_) {
      counter.value++;
      counter.commit();
    });
  }
}

CounterStore store;

@ComponentMeta()
class CounterView extends Component {
  int _counter;

  updateState() {
    final c = store.counter;
    listen(c);
    if (_counter != c.value) {
      _counter = c.value;
      return true;
    }
    return false;
  }

  build() => vRoot()('Counter: $_counter');
}

main() {
  initUix();

  store = new CounterStore();

  scheduler.nextFrame.write().then((_) {
    injectComponent(createCounterView(), html.document.body);
  });
}
