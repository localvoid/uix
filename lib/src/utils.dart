// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.utils;

import 'dart:async';
import 'dart:html' as html;
import 'vdom/vnode.dart';
import 'vdom/vcontext.dart';
import 'vdom/anchor.dart';
import 'component.dart';
import 'env.dart';

Future injectVNode(VNode node, html.Node container) async {
  final inject = () async {
    await scheduler.nextFrame.write();
    node.create(const VContext(false));
    container.append(node.ref);
    node.attached();
    node.render(const VContext(true));
  };

  if (identical(Zone.current, scheduler.zone)) {
    return inject();
  } else {
    return scheduler.zone.run(inject);
  }
}

Future injectComponent(Component component, html.Node container) {
  final inject = () async {
    await scheduler.nextFrame.write();
    component.create();
    component.init();
    container.append(component.element);
    component.attach();
  };

  if (identical(Zone.current, scheduler.zone)) {
    return inject();
  } else {
    return scheduler.zone.run(inject);
  }
}

Future mountComponent(Component component, html.Node node) {
  final mount = () async {
    await scheduler.nextFrame.write();
    component.mount(node);
    component.init();
    component.attach();
  };

  if (identical(Zone.current, scheduler.zone)) {
    return mount();
  } else {
    return scheduler.zone.run(mount);
  }
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
