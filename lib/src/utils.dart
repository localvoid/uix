// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.utils;

import 'dart:html' as html;
import 'vnode.dart';
import 'vcontext.dart';
import 'component.dart';

void injectVNode(VNode node, html.Node container) {
  node.create(const VContext(false));
  container.append(node.ref);
  node.attached();
  node.render(const VContext(true));
}

void injectComponent(Component component, html.Node container) {
  container.append(component.element);
  component.attach();
  component.update();
}

VNode vText(String data, {Object key}) => new VNode.text(data, key: key);

VNode vElement(String tag, {Object key, String type, Map<String, String> attrs,
  Map<String, String> style, List<String> classes, List<VNode> children}) =>
      new VNode.element(tag, key: key, type: type, attrs: attrs, style: style,
          classes: classes, children: children);

VNode vRoot({String type, Map<String, String> attrs, Map<String, String> style,
  List<String> classes, List<VNode> children}) =>
      new VNode.root(type: type, attrs: attrs, style: style,
          classes: classes, children: children);
