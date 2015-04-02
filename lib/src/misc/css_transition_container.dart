// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.misc.css_transition_container;

import 'dart:html' as html;
import '../env.dart';
import '../container.dart';
import '../vcontext.dart';
import '../vnode.dart';

/// *EXPERIMENTAL* class for group transitions
/// (doesn't work properly, proof of concept)
abstract class CssTransitionContainer implements Container {
  html.Element get element;

  void initTransitionListeners() {
    element.onTransitionEnd.listen(_handleTransitionEnd);
  }

  void _handleTransitionEnd(html.TransitionEvent e) {
    e.stopPropagation();

    final classes = (e.target as html.Element).classes;
    if (classes.contains('enter')) {
      classes.remove('enter');
      classes.remove('active');
    } else if (classes.contains('leave')) {
      classes.remove('leave');
      classes.remove('active');
      (e.target as html.Element).remove();
    }
  }

  void insertChild(VNode container, VNode node, VNode next) {
    assert((node.flags & VNode.componentFlag) != 0);

    final nextRef = next == null ? null : next.ref;
    node.create((this as VContext));
    container.ref.insertBefore(node.ref, nextRef);
    if (isAttached) {
      node.attached();
    }
    node.render((this as VContext));

    final e = (node.ref as html.Element);
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
  }
}
