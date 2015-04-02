// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-04-02T03:34:07.799Z

part of uix.example.animation.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class Box
// **************************************************************************

Box createBox([int data, List<VNode> children, Component parent]) {
  return new Box()
    ..parent = parent
    ..data = data
    ..children = children;
}
VNode vBox({int data, Object key, String type, Map<String, String> attrs,
    Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createBox,
    flags: VNode.componentFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);

// **************************************************************************
// Generator: UixGenerator
// Target: class Main
// **************************************************************************

Main createMain([List data, List<VNode> children, Component parent]) {
  return new Main()
    ..parent = parent
    ..data = data
    ..children = children;
}
VNode vMain({List data, Object key, String type, Map<String, String> attrs,
    Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createMain,
    flags: VNode.componentFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);
