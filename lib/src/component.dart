// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.component;

import 'dart:async';
import 'dart:html' as html;
import 'data/node.dart';
import 'vcontext.dart';
import 'vnode.dart';
import 'env.dart';

abstract class Component<P> extends RevisionedNode with StreamListenerNode implements VContext {
  static const dirtyFlag = 1;
  static const attachedFlag = 1 << 1;
  static const shouldUpdateViewFlags = dirtyFlag | attachedFlag;

  String get tag => 'div';

  int flags = dirtyFlag;
  int depth = 0;
  Component _parent;
  P data;
  html.Element element;
  VNode _root;

  Component get parent => _parent;
  set parent(Component c) {
    _parent = c;
    depth = c.depth + 1;
  }

  VNode get root => _root;
  set root(VNode n) {
    if (n != null) {
      if (_root == null) {
        n.ref = element;
        n.cref = this;
        n.render(this);
      } else {
        _root.update(n, this);
      }
      _root = n;
    }
  }

  List<VNode> get children => null;
  set children(List<VNode> c) {}

  bool get isDirty => (flags & dirtyFlag) != 0;
  bool get isAttached => (flags & attachedFlag) != 0;

  Component() {
    element = html.document.createElement(tag);
    init();
  }

  void init() {}

  void update([_]) {
    if ((flags & shouldUpdateViewFlags) == shouldUpdateViewFlags) {
      if (updateState()) {
        updateView();
      }
      updateRev();
      flags &= ~dirtyFlag;
    }
  }

  bool updateState() => true;
  void updateView() { root = build(); }

  VNode build() => null;

  void invalidate([_]) {
    if ((flags & dirtyFlag) == 0) {
      flags |= dirtyFlag;

      if (!scheduler.isRunning) {
        if (identical(Zone.current, scheduler.zone)) {
          scheduler.nextFrame.write(depth).then(update);
        } else {
          scheduler.zone.run(() {
            scheduler.nextFrame.write(depth).then(update);
          });
        }
      }

      resetTransientSubscriptions();
      invalidated();
    }
  }

  void invalidated() {}

  void attached() {}
  void detached() {}
  void disposed() {}

  void dispose() {
    if (_root != null) {
      _root.dispose();
    }
    flags &= ~attachedFlag;
    detached();
    resetTransientSubscriptions();
    resetSubscriptions();
    disposed();
  }

  void attach() {
    assert(!isAttached);
    flags |= attachedFlag;
    attached();
    if (_root != null) {
      _root.attach();
    }
  }

  void detach() {
    assert(isAttached);
    if (_root != null) {
      _root.detached();
    }
    flags &= ~attachedFlag;
    detached();
  }
}
