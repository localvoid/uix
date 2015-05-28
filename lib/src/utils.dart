// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.utils;

import 'dart:async';
import 'dart:html' as html;
import 'vdom/vnode.dart';
import 'vdom/anchor.dart';
import 'component.dart';
import 'env.dart';

Future injectComponent(Component component, html.Node container) async {
  await scheduler.nextFrame.write();
  component.descriptor.parent = scheduler.rootCNode;
  component.create();
  component.init();
  container.append(component.element);
  component.descriptor.attach();
  component.descriptor.update();
}

Future mountComponent(Component component, html.Node node) async {
  await scheduler.nextFrame.write();
  component.descriptor.parent = scheduler.rootCNode;
  component.descriptor.mount(node);
  component.init();
  component.descriptor.attach();
  component.descriptor.update();
}

VNode vText(String data, {Object key}) => new VNode.text(data, key: key);

VNode vElement(String tag, {Object key, String type, Map<int, dynamic> attrs, Map<String, String> customAttrs,
  Map<int, String> style, List<String> classes, List<VNode> children, Anchor anchor,
  bool content: false}) =>
      new VNode.element(tag, key: key, type: type, attrs: attrs, customAttrs: customAttrs, style: style,
          classes: classes, children: children, anchor: anchor, content: content);

VNode vSvgElement(String tag, {Object key, String type, Map<int, dynamic> attrs, Map<String, String> customAttrs,
  Map<int, String> style, List<String> classes, List<VNode> children, Anchor anchor,
  bool content: false}) =>
      new VNode.svgElement(tag, key: key, type: type, attrs: attrs, customAttrs: customAttrs, style: style,
          classes: classes, children: children, anchor: anchor, content: content);

VNode vRoot({String type, Map<int, dynamic> attrs, Map<String, String> customAttrs, Map<int, String> style,
  List<String> classes, List<VNode> children, bool content: false}) =>
      new VNode.root(type: type, attrs: attrs, customAttrs: customAttrs, style: style,
          classes: classes, children: children, content: content);

VNode vComponent(componentConstructor componentType, {Object key, dynamic data,
  String type, Map<int, dynamic> attrs, Map<String, String> customAttrs, Map<int, String> style,
  List<String> classes, List<VNode> children, Anchor anchor}) =>
      new VNode.component(componentType, key: key, data: data, type: type,
          attrs: attrs, customAttrs: customAttrs, style: style, classes: classes, children: children,
          anchor: anchor);
