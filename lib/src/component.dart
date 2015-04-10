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

/// Component is a basic block to build user interfaces.
///
/// Example:
///
///     class Button extends Component<String> {
///       updateView() {
///         updateRoot(vRoot(type: 'Button')(data));
///       }
///     }
///
abstract class Component<P> extends RevisionedNode with StreamListenerNode implements VContext {
  /// Flag indicating that Component is dirty and should be updated.
  static const int dirtyFlag = 1;

  /// Flag indicating that Component is attached to the html document.
  static const int attachedFlag = 1 << 1;

  /// Flag indicating that root [element] is in svg namespace.
  static const int svgFlag = 1 << 2;

  /// Flag indicating that Component in the process of mounting on top of
  /// the existing html nodes.
  static const int mountingFlag = 1 << 3;

  /// Set of flags indicating that Component should be updated.
  static const int shouldUpdateViewFlags = dirtyFlag | attachedFlag;

  /// Tag name of the root [element].
  final String tag = 'div';

  /// Flags.
  int flags = dirtyFlag;

  /// Depth of the Component in the Component tree.
  ///
  /// It is used as a priority for dom write tasks. Components with the
  /// lowest depth have highest priority.
  int depth = 0;

  /// Reference to the html Element.
  html.Element element;

  /// Protected property that contains data input.
  P data_;

  /// Protected property that contains children input.
  List<VNode> children_;

  Component _parent;
  VNode _root;

  /// Parent Component.
  Component get parent => _parent;
  set parent(Component newParent) {
    _parent = newParent;
    depth = newParent == null ? 0 : newParent.depth + 1;
  }

  /// Data input.
  P get data => data_;
  set data(P newData) {
    if (data_ != newData) {
      data_ = newData;
      invalidate();
    }
  }

  /// Children input.
  List<VNode> get children => children_;
  set children(List<VNode> newChildren) {
    if (!identical(children_, newChildren)) {
      children_ = newChildren;
      invalidate();
    }
  }

  /// Reference to the root virtual dom node.
  VNode get root => _root;

  /// Component is dirty and should be updated.
  bool get isDirty => (flags & dirtyFlag) != 0;

  /// Component is attached to the html document.
  bool get isAttached => (flags & attachedFlag) != 0;

  /// [element] is in svg namespace.
  bool get isSvg => (flags & svgFlag) != 0;

  /// Component in the process of mounting on top of the existing html nodes.
  bool get isMounting => (flags & mountingFlag) != 0;

  /// Lifecycle method `create`.
  ///
  /// Create method should create root [element].
  ///
  /// Invoked during the [Scheduler] *write dom* phase.
  void create() {
    element = html.document.createElement(tag);
  }

  /// Lifecycle method `mount`.
  ///
  /// Mount method should mount Component on top of the existing html element.
  ///
  /// Invoked during the [Scheduler] *write dom* phase.
  void mount(html.Element e) {
    flags |= mountingFlag;
    element = e;
  }

  /// Lifecycle method `init`.
  ///
  /// Initialize component. This method is called after [create], or [mount]
  /// methods.
  ///
  /// Invoked during the [Scheduler] *write dom* phase.
  void init() {}

  /// Lifecycle method `update`.
  ///
  /// If Component [isDirty], update method will run [updateState], and if
  /// update state method returns `true`, it will run [updateView] method.
  /// When updating is finished, lifecycle method [updated] will be invoked.
  ///
  /// Invoked during the [Scheduler] *write dom* phase.
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

  /// Lifecycle method `updateState`.
  ///
  /// Update internal state, it should return `bool` value that indicates
  /// that the internal state changes will result in a modified view
  /// representation of the component.
  ///
  /// Invoked during the [Scheduler] *write dom* phase.
  bool updateState() => true;

  /// Lifecycle method `updateView`.
  ///
  /// Update view.
  ///
  /// Invoked during the [Scheduler] *write dom* phase.
  Future updateView();

  /// Update internal tree using virtual dom representation.
  ///
  /// If this method is called during [isMounting] phase, then virtual dom
  /// will be mounted on top of the existing html tree.
  void updateRoot(VNode n) {
    assert(n != null);
    if (_root == null) {
      n.cref = this;
      if ((flags & mountingFlag) != 0) {
        n.mount(element, this);
        flags &= ~mountingFlag;
      } else {
        n.ref = element;
        n.render(this);
      }
    } else {
      _root.update(n, this);
    }
    _root = n;
  }

  /// Invalidate Component.
  ///
  /// Component will be marked as dirty and added to the update queue. All
  /// transient subscriptions will be canceled immediately.
  void invalidate([_]) {
    if ((flags & dirtyFlag) == 0) {
      flags |= dirtyFlag;
      cancelTransientSubscriptions();
      invalidated();
    }
    if ((flags & shouldUpdateViewFlags) == shouldUpdateViewFlags) {
      if (scheduler.isFrameRunning) {
        scheduler.currentFrame.write(depth).then(update);
      } else {
        if (identical(Zone.current, scheduler.zone)) {
          scheduler.nextFrame.write(depth).then(update);
        } else {
          scheduler.zone.run(() {
            scheduler.nextFrame.write(depth).then(update);
          });
        }
      }
    }
  }

  /// Lifecycle method `invalidated`.
  ///
  /// Invoked after [invalidate] method is called.
  void invalidated() {}

  /// Lifecycle method `updated`.
  ///
  /// Invoked during the [Scheduler] *write dom* phase after [update] method
  /// is finished.
  void updated() {}

  /// Lifecycle method `attached`.
  ///
  /// Invoked during the [Scheduler] *write dom* phase when Component is
  /// attached to the html document.
  void attached() {}

  /// Lifecycle method `detached`.
  ///
  /// Invoked during the [Scheduler] *write dom* phase when Component is
  /// detached from the html document.
  void detached() {}

  /// Lifecycle method `disposed`.
  ///
  /// Invoked during the [Scheduler] *write dom* phase when Component is
  /// disposed.
  void disposed() {}

  /// Dispose Component.
  ///
  /// This method should be called when Component is no longer in use.
  ///
  /// *NOTE*: Use it only when you want to manually control the lifecycle of
  /// the Component, otherwise just use helper methods like [injectComponent]
  /// that will call lifecycle methods in the right order.
  void dispose() {
    if (_root != null) {
      _root.dispose();
    }
    if (isAttached) {
      flags &= ~attachedFlag;
      detached();
    }
    cancelTransientSubscriptions();
    cancelSubscriptions();
    disposed();
  }

  /// Attach `Component`.
  ///
  /// This method should be called when Component is attached to the
  /// html document.
  ///
  /// *NOTE*: Use it only when you want to manually control the lifecycle of
  /// the Component, otherwise just use helper methods like [injectComponent]
  /// that will call lifecycle methods in the right order.
  void attach() {
    assert(!isAttached);
    flags |= attachedFlag;
    invalidate();
    attached();
    if (_root != null) {
      _root.attach();
    }
  }

  /// Detach `Component`.
  ///
  /// This method should be called when Component is detached to the
  /// html document.
  ///
  /// *NOTE*: Use it only when you want to manually control the lifecycle of
  /// the Component, otherwise just use helper methods like [injectComponent]
  /// that will call lifecycle methods in the right order.
  void detach() {
    assert(isAttached);
    if (_root != null) {
      _root.detach();
    }
    flags &= ~attachedFlag;
    detached();
  }

  /// Serialize Component as a html string, ignoring any internal state.
  String toHtmlString() {
    final b = new StringBuffer();
    writeHtmlString(b);
    return b.toString();
  }

  /// Serialize Component to StringBuffer [b], ignoring any internal state.
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
      if (p != null && p.type != null) {
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
    if (root != null && root.children != null) {
      for (var i = 0; i < root.children.length; i++) {
        root.children[i].writeHtmlString(b);
      }
    }
    b.write('</$tag>');
  }
}

/// Base class for Components with a root element in Svg namespace.
abstract class SvgComponent<P> extends Component<P> {
  final String tag = 'svg';
  int flags = Component.dirtyFlag | Component.svgFlag;

  void create() {
    element = html.document.createElementNS('http://www.w3.org/2000/svg', tag);
  }
}

/// Component constructor type.
///
/// *NOTE*:It will be removed when
/// [metaclasses](https://github.com/gbracha/metaclasses) will be implemented
/// in Dart.
typedef Component componentConstructor();
