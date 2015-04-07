// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.container;

import 'vcontext.dart';
import 'vnode.dart';

abstract class Container {
  bool get isAttached;

  void insertChild(VNodeCache container, VNodeCache node, VNodeCache next) {
    final nextRef = next == null ? null : next.ref;
    container.ref.insertBefore(node.ref, nextRef);
    if (isAttached) {
      node.attached();
    }
    node.render((this as VContext));
  }

  void moveChild(VNodeCache container, VNodeCache node, VNodeCache next) {
    final nextRef = next == null ? null : next.ref;
    container.ref.insertBefore(node.ref, nextRef);
  }

  void removeChild(VNodeCache container, VNodeCache node) {
    node.ref.remove();
    node.dispose();
  }

  void updateChild(VNodeCache container, VNodeCache aNode, VNode bNode) {
    aNode.update(bNode, (this as VContext));
  }
}
