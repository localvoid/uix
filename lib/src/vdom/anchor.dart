// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.vdom.anchor;

import 'vnode.dart';

class Anchor {
  VNode node;
  bool attached = false;

  bool get isEmpty => node == null;
  bool get isNotEmpty => node != null;

  void dispose() {
    if (node != null) {
      node.dispose();
    }
  }
}
