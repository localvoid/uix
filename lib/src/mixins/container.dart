// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.mixins.container;

import '../vnode.dart';

abstract class ContainerMixin {
  List<VNode> _children;
  List<VNode> get children => _children;
  set children(List<VNode> c) {
    _children = c;
  }
}
