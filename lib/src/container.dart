// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.container;

import 'vdom/vnode.dart';
import 'component.dart';

// TODO: add anchor implementation
abstract class Container {
  bool get isAttached;

  void insertChild(VNode container, VNode node, VNode next) {
    final nextRef = next == null ? null : next.ref;
    node.create((this as CNode));
    container.ref.insertBefore(node.ref, nextRef);
    if (isAttached) {
      node.attached();
    }
    node.render((this as CNode));
  }

  void moveChild(VNode container, VNode node, VNode next) {
    final nextRef = next == null ? null : next.ref;
    container.ref.insertBefore(node.ref, nextRef);
  }

  void removeChild(VNode container, VNode node) {
    node.ref.remove();
    node.dispose();
  }

  void updateChild(VNode container, VNode aNode, VNode bNode) {
    aNode.update(bNode, (this as CNode));
  }
}
