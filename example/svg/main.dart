// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.hello.main;

import 'dart:html' as html;
import 'package:uix/uix.dart';

part 'main.g.dart';

@ComponentMeta()
class SvgIcon extends SvgComponent {
  updateView() {
    updateRoot(vRoot(attrs: const {'width': '24', 'height': '24', 'viewBox': '0 0 24 24'})(
      vSvgElement('path', attrs: const {'d': 'M20 8.69V4h-4.69L12 .69 8.69 4H4v4.69L.69 12 4 15.31V20h4.69L12 23.31 15.31 20H20v-4.69L23.31 12 20 8.69zM12 18c-3.31 0-6-2.69-6-6s2.69-6 6-6 6 2.69 6 6-2.69 6-6 6zm0-10c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4z'})
    ));
  }
}

@ComponentMeta()
class Main extends Component {
  updateView() {
    updateRoot(vRoot()([
      vSvgElement('svg', attrs: const {'width': '24', 'height': '24', 'viewBox': '0 0 24 24'})(
        vSvgElement('path', attrs: const {'d': 'M14.4 6L14 4H5v17h2v-7h5.6l.4 2h7V6z'})
      ),
      vComponent($SvgIcon)
    ]));
  }
}

main() {
  initUix();

  injectComponent(new Main(), html.document.body);
}
