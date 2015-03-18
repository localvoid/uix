// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.timer.main;

import 'dart:async';
import 'dart:html' as html;
import 'package:uix/uix.dart';

part 'main.g.dart';

@ShallowEqOperator()
class CounterProps extends CounterPropsShallowEqOperator {
  final int value;

  const CounterProps(this.value);
}

@ComponentMeta()
class Counter extends Component<CounterProps> {
  String get tag => 'p';

  build() => vRoot()('value: ${data.value}');
}

@ComponentMeta()
class Main extends Component {
  int _value = 0;

  void init() {
    final start = new DateTime.now().millisecondsSinceEpoch;
    new Timer.periodic(new Duration(milliseconds: 50), (t) {
      _value = ((new DateTime.now().millisecondsSinceEpoch - start) / 1000).floor();
      invalidate();
    });
  }

  build() => vRoot()(vCounter(data: new CounterProps(_value)));
}

main() {
  initUix();

  scheduler.nextFrame.write().then((_) {
    injectComponent(createMain(), html.document.body);
  });
}