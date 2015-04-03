// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.inheritance.main;

import 'dart:html' as html;
import 'package:uix/uix.dart';

part 'main.g.dart';

class ButtonBaseData {
  final bool disabled;

  const ButtonBaseData(this.disabled);

  bool operator==(ButtonBaseData other) => disabled == other.disabled;
}

class ButtonData extends ButtonBaseData {
  final String color;

  const ButtonData({bool disabled: false, this.color: 'blue'}) : super(disabled);

  bool operator==(ButtonBaseData other) => super == other && disabled == other.disabled;
}

abstract class ButtonBase<T extends ButtonBaseData> extends Component<T> {
  int clickCounter = 0;

  void init() {
    element
      ..onClick.listen((_) {
        clickCounter++;
        invalidate();
      });
  }
}

@ComponentMeta()
class Button extends ButtonBase<ButtonData>{
  final String tag = 'button';

  updateView() {
    updateRoot(vRoot(type: 'Button', classes: data.disabled ? const ['disabled'] : null, style: {'color': data.color})([
      vElement('span')(clickCounter.toString()),
      vText(' '),
      vElement('span', children: children)
    ]));
  }
}

@ComponentMeta()
class App extends Component {
  updateView() {
    updateRoot(vRoot()(vComponent($Button, data: new ButtonData(color: 'red'))('button')));
  }
}

main() {
  initUix();

  injectComponent(new App(), html.document.body);
}
