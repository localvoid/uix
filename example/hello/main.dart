// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.hello.main;

import 'dart:html' as html;
import 'package:uix/uix.dart';

part 'main.g.dart';

@ComponentMeta()
class Main extends Component<String> {
  updateView() { updateRoot(vRoot()('Hello ${data}')); }
}

main() {
  initUix();

  injectComponent(new Main()..data = 'World', html.document.body);
}
