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

typedef Component componentConstructor([dynamic data, List<VNode> children, Component parent]);

abstract class Component<P> extends RevisionedNode with StreamListenerNode implements VContext {
  static const int dirtyFlag = 1;
  static const int attachedFlag = 1 << 1;
  static const int svgFlag = 1 << 2;
  static const int shouldUpdateViewFlags = dirtyFlag | attachedFlag;

  final String tag = 'div';

  int flags = dirtyFlag;
  int depth = 0;
  html.Element element;
  Component _parent;
  P data_;
  List<VNode> children_;
  VNode _root;

  Component get parent => _parent;
  set parent(Component newParent) {
    _parent = newParent;
    depth = newParent == null ? 0 : newParent.depth + 1;
  }

  P get data => data_;
  set data(P newData) {
    if (data_ != newData) {
      data_ = newData;
      invalidate();
    }
  }

  List<VNode> get children => children_;
  set children(List<VNode> newChildren) {
    if (!identical(children_, newChildren)) {
      children_ = newChildren;
      invalidate();
    }
  }

  VNode get root => _root;

  bool get isDirty => (flags & dirtyFlag) != 0;
  bool get isAttached => (flags & attachedFlag) != 0;
  bool get isSvg => (flags & svgFlag) != 0;

  void create() {
    element = isSvg ?
        html.document.createElementNS('http://www.w3.org/2000/svg', tag)
      : html.document.createElement(tag);
  }

  void init() {}

  void update([_]) {
    if ((flags & shouldUpdateViewFlags) == shouldUpdateViewFlags) {
      Future future;
      if (updateState()) {
        future = updateView();
      }
      if (future == null) {
        _finishUpdate();
      } else {
        future.then(_finishUpdate);
      }
    }
  }

  void _finishUpdate([_]) {
    updateRevision();
    flags &= ~dirtyFlag;
    updated();
  }

  bool updateState() => true;
  Future updateView();

  void updateRoot(VNode n) {
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

  void invalidate([_]) {
    if ((flags & dirtyFlag) == 0) {
      flags |= dirtyFlag;

      if (!scheduler.isFrameRunning) {
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
  void updated() {}

  void attached() {}
  void detached() {}
  void disposed() {}

  void dispose() {
    if (_root != null) {
      _root.dispose();
    }
    if (isAttached) {
      flags &= ~attachedFlag;
      detached();
    }
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
      _root.detach();
    }
    flags &= ~attachedFlag;
    detached();
  }

  String toHtmlString() {
    final b = new StringBuffer();
    writeHtmlString(b);
    return b.toString();
  }

  void writeHtmlString(StringBuffer b, [VNode p]) {
    b.write('<$tag');
    if (p != null || root != null) {
      if (p != null && p.attrs != null) {
        writeAttrsToHtmlString(b, p.attrs);
      }
      if (root != null && root.attrs != null) {
        writeAttrsToHtmlString(b, root.attrs);
      }
    }
    if ((p != null && (p.type != null || (p.classes != null && p.classes.isNotEmpty)))
        || (root != null && (root.type != null || (root.classes != null && root.classes.isNotEmpty)))) {
      b.write(' class="');
      bool off = false;
      if (p.type != null) {
        b.write(p.type);
        off = true;
      }
      if (p != null && p.classes != null && p.classes.isNotEmpty) {
        if (off) {
          b.write(' ');
        }
        writeClassesToHtmlString(b, p.classes);
        off = true;
      }
      if (root != null && root.type != null) {
        if (off) {
          b.write(' ');
        }
        b.write(root.type);
        off = true;
      }
      if (root != null && root.classes != null && root.classes.isNotEmpty) {
        if (off) {
          b.write(' ');
        }
        writeClassesToHtmlString(b, root.classes);
      }
      b.write('"');
    }
    if ((p != null && p.style != null && p.style.isNotEmpty)
        || (root != null && root.style != null && root.style.isNotEmpty)) {
      b.write(' style="');
      if (p != null && p.style != null && p.style.isNotEmpty) {
        writeStyleToHtmlString(b, p.style);
      }
      if (root != null && root.style != null && root.style.isNotEmpty) {
        writeStyleToHtmlString(b, root.style);
      }
      b.write('"');
    }
    b.write('>');
    if (children != null) {
      for (var i = 0; i < children.length; i++) {
        children[i].writeHtmlString(b);
      }
    }
    b.write('</$tag>');
  }
}

abstract class SvgComponent<P> extends Component<P> {
  final String tag = 'svg';
  int flags = Component.dirtyFlag | Component.svgFlag;
}