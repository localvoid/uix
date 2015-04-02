// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.misc.css_transition_container;

import 'dart:collection';
import 'dart:html' as html;
import '../assert.dart';
import '../env.dart';
import '../container.dart';
import '../vcontext.dart';
import '../vnode.dart';

class _CssTransitionNode {
  static const int normal = 0;
  static const int enter = 1;
  static const int leave = 2;

  int state = enter;
  VNode node;
  html.Element element;

  _CssTransitionNode(this.node, this.element);
}

/// *EXPERIMENTAL* class for group transitions
abstract class CssTransitionContainer implements Container {
  html.Element get element;

  HashMap<Object, _CssTransitionNode> _nodes = new HashMap<Object, _CssTransitionNode>();
  HashMap<html.Element, Object> _nodeKeys = new HashMap<html.Element, Object>();

  void initTransitionListeners() {
    element.onTransitionEnd.listen(_handleTransitionEnd);
  }

  void _handleTransitionEnd(html.TransitionEvent e) {
    e.stopPropagation();

    final html.Element target = e.target;
    final key = _nodeKeys[target];
    if (key != null) {
      final transitionNode = _nodes[key];
      switch (transitionNode.state) {
        case _CssTransitionNode.normal:
          break;
        case _CssTransitionNode.enter:
          final classes = target.classes;
          classes.remove('enter');
          classes.remove('active');
          transitionNode.state = _CssTransitionNode.normal;
          break;
        case _CssTransitionNode.leave:
          target.remove();
          transitionNode.node.dispose();
          _nodes.remove(key);
          _nodeKeys.remove(target);
          break;
      }
    }
  }

  void insertChild(VNode container, VNode node, VNode next) {
    assert(invariant((node.flags & VNode.componentFlag) != 0,
           'CssTransitionContainer can control Component nodes only.'));
    assert(invariant((node.key != null),
           'CssTransitionContainer can control nodes with explicit keys only.'));

    final nextRef = next == null ? null : next.ref;
    node.create((this as VContext));
    container.ref.insertBefore(node.ref, nextRef);
    if (isAttached) {
      node.attached();
    }
    node.render((this as VContext));

    final e = (node.ref as html.Element);
    _nodes[node.key] = new _CssTransitionNode(node, e);
    _nodeKeys[e] = node.key;

    e.classes.add('enter');
    scheduler.currentFrame.read().then((_) {
      e.getComputedStyle().transform;
      scheduler.currentFrame.write().then((_) {
        e.classes.add('active');
      });
    });
  }

  void moveChild(VNode container, VNode node, VNode next) {
    final nextRef = next == null ? null : next.ref;
    container.ref.insertBefore(node.ref, nextRef);
  }

  void removeChild(VNode container, VNode node) {
    final e = (node.ref as html.Element);
    final transitionNode = _nodes[node.key];

    if (transitionNode.state == _CssTransitionNode.enter) {
      e.classes.remove('enter');
      e.classes.remove('active');
    }
    transitionNode.state = _CssTransitionNode.leave;

    e.classes.add('leave');
    scheduler.currentFrame.read().then((_) {
      e.getComputedStyle().transform;
      scheduler.currentFrame.write().then((_) {
        e.classes.add('active');
      });
    });
  }

  void updateChild(VNode container, VNode aNode, VNode bNode) {
    aNode.update(bNode, (this as VContext));
    _nodes[bNode.key].node = bNode;
  }
}
